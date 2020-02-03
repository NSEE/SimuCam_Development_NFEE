/******************************************************************************
 *                                                                             *
 * License Agreement                                                           *
 *                                                                             *
 * Copyright (c) 2014 Altera Corporation, San Jose, California, USA.           *
 * All rights reserved.                                                        *
 *                                                                             *
 * Permission is hereby granted, free of charge, to any person obtaining a     *
 * copy of this software and associated documentation files (the "Software"),  *
 * to deal in the Software without restriction, including without limitation   *
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
 * and/or sell copies of the Software, and to permit persons to whom the       *
 * Software is furnished to do so, subject to the following conditions:        *
 *                                                                             *
 * The above copyright notice and this permission notice shall be included in  *
 * all copies or substantial portions of the Software.                         *
 *                                                                             *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
 * DEALINGS IN THE SOFTWARE.                                                   *
 *                                                                             *
 * This agreement shall be governed in all respects by the laws of the State   *
 * of California and by the laws of the United States of America.              *
 *                                                                             *
 ******************************************************************************/

#include "msgdma.h"

/*******************************************************************************
 *  Private API
 ******************************************************************************/
static int msgdma_write_extended_descriptor(alt_u32 *csr_base,
		alt_u32 *descriptor_base, alt_msgdma_extended_descriptor *descriptor);
static int msgdma_construct_extended_descriptor(alt_msgdma_dev *dev,
		alt_msgdma_extended_descriptor *descriptor, alt_u32 *read_address,
		alt_u32 *write_address, alt_u32 length, alt_u32 control,
		alt_u32 *read_address_high, alt_u32 *write_address_high,
		alt_u16 sequence_number, alt_u8 read_burst_count,
		alt_u8 write_burst_count, alt_u16 read_stride, alt_u16 write_stride);
static int msgdma_descriptor_async_transfer(alt_msgdma_dev *dev,
		alt_msgdma_standard_descriptor *standard_desc,
		alt_msgdma_extended_descriptor *extended_desc);
static int msgdma_descriptor_sync_transfer(alt_msgdma_dev *dev,
		alt_msgdma_standard_descriptor *standard_desc,
		alt_msgdma_extended_descriptor *extended_desc);

/* 
 * Functions for writing descriptor structure to the dispatcher.  If you disable 
 * some of the extended features in the hardware then you should pass in 0 for 
 * that particular descriptor element. These disabled elements will not be 
 * buffered by the dispatcher block.
 * 
 * This function is non-blocking and will return an error code if there is no 
 * room to write another descriptor to the dispatcher. It is recommended to call
 * 'read_descriptor_buffer_full' and make sure it returns '0' before calling 
 * this function.
 */

/*
 * This function is used for writing extended descriptors to the dispatcher.  
 It handles only 32-bit descriptors.
 */
static int msgdma_write_extended_descriptor(alt_u32 *csr_base,
		alt_u32 *descriptor_base, alt_msgdma_extended_descriptor *descriptor) {
	if (0 != (IORD_ALTERA_MSGDMA_CSR_STATUS(csr_base) &
	ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
		/*at least one descriptor buffer is full, returning so that this function
		 is non-blocking*/
		return -ENOSPC;
	}

	IOWR_ALTERA_MSGDMA_DESCRIPTOR_READ_ADDRESS(descriptor_base,
			(alt_u32 )descriptor->read_address_low);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_WRITE_ADDRESS(descriptor_base,
			(alt_u32 )descriptor->write_address_low);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_LENGTH(descriptor_base,
			descriptor->transfer_length);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_SEQUENCE_NUMBER(descriptor_base,
			descriptor->sequence_number);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_READ_BURST(descriptor_base,
			descriptor->read_burst_count);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_WRITE_BURST(descriptor_base,
			descriptor->write_burst_count);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_READ_STRIDE(descriptor_base,
			descriptor->read_stride);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_WRITE_STRIDE(descriptor_base,
			descriptor->write_stride);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_READ_ADDRESS_HIGH(descriptor_base,
			(alt_u32 )descriptor->read_address_high);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_WRITE_ADDRESS_HIGH(descriptor_base,
			(alt_u32 )descriptor->write_address_high);
	IOWR_ALTERA_MSGDMA_DESCRIPTOR_CONTROL_ENHANCED(descriptor_base,
			descriptor->control);
	return 0;
}

/*
 * Helper functions for constructing mm_to_st, st_to_mm, mm_to_mm extended 
 * descriptors. Unnecessary elements are set to 0 for completeness and will be 
 * ignored by the hardware.
 * Returns:
 * - status: return 0 (success)
 *           return -EINVAL (invalid argument, could be due to argument which 
 *                          has larger value than hardware setting value)
 */
static int msgdma_construct_extended_descriptor(alt_msgdma_dev *dev,
		alt_msgdma_extended_descriptor *descriptor, alt_u32 *read_address,
		alt_u32 *write_address, alt_u32 length, alt_u32 control,
		alt_u32 *read_address_high, alt_u32 *write_address_high,
		alt_u16 sequence_number, alt_u8 read_burst_count,
		alt_u8 write_burst_count, alt_u16 read_stride, alt_u16 write_stride) {
	if (dev->max_byte < length || dev->max_stride < read_stride
			|| dev->max_stride < write_stride || dev->enhanced_features != 1) {
		return -EINVAL;
	}

	descriptor->read_address_low = read_address;
	descriptor->write_address_low = write_address;
	descriptor->transfer_length = length;
	descriptor->sequence_number = sequence_number;
	descriptor->read_burst_count = read_burst_count;
	descriptor->write_burst_count = write_burst_count;
	descriptor->read_stride = read_stride;
	descriptor->write_stride = write_stride;
	descriptor->read_address_high = read_address_high;
	descriptor->write_address_high = write_address_high;
	descriptor->control = control | ALTERA_MSGDMA_DESCRIPTOR_CONTROL_GO_MASK;

	return 0;

}

/*
 * Helper functions for descriptor in async transfer.
 * Arguments:# This driver supports HAL types
 * - *dev: Pointer to msgdma device (instance) structure.
 * - *standard_desc: Pointer to single standard descriptor.
 * - *extended_desc: Pointer to single extended descriptor.
 *
 *note: Either one of both *standard_desc and *extended_desc must 
 *      be assigned with NULL, another with proper pointer value.
 *      Failing to do so can cause the function return with "-EPERM "
 *
 * If a callback routine has been previously registered with this
 * particular msgdma controller, transfer will be set up to enable interrupt 
 * generation. It is the responsibility of the application developer to check 
 * source interruption, status completion and creating suitable interrupt 
 * handling. Note: "stop on error" of CSR control register is always masking 
 * within this function. The CSR control can be set by user through calling 
 * "alt_register_callback" by passing user used defined control setting.
 *
 * Returns:
 * 0 -> success
 * -ENOSPC -> FIFO descriptor buffer is full
 * -EPERM -> operation not permitted due to descriptor type conflict
 * -ETIME -> Time out and skipping the looping after 5 msec.
 */
static int msgdma_descriptor_async_transfer(alt_msgdma_dev *dev,
		alt_msgdma_standard_descriptor *standard_desc,
		alt_msgdma_extended_descriptor *extended_desc) {
	alt_u32 control = 0;
	alt_irq_context context = 0;
	alt_u16 counter = 0;
	alt_u32 fifo_read_fill_level = (
	IORD_ALTERA_MSGDMA_CSR_DESCRIPTOR_FILL_LEVEL(dev->csr_base) &
	ALTERA_MSGDMA_CSR_READ_FILL_LEVEL_MASK) >>
	ALTERA_MSGDMA_CSR_READ_FILL_LEVEL_OFFSET;
	alt_u32 fifo_write_fill_level = (
	IORD_ALTERA_MSGDMA_CSR_DESCRIPTOR_FILL_LEVEL(dev->csr_base) &
	ALTERA_MSGDMA_CSR_WRITE_FILL_LEVEL_MASK) >>
	ALTERA_MSGDMA_CSR_WRITE_FILL_LEVEL_OFFSET;

	/* Return with error immediately if one of read/write buffer is full */
	if ((dev->descriptor_fifo_depth <= fifo_write_fill_level)
			|| (dev->descriptor_fifo_depth <= fifo_read_fill_level)) {
		/*at least one write or read FIFO descriptor buffer is full,
		 returning so that this function is non-blocking*/
		return -ENOSPC;
	}

	/*
	 * When running in a multi threaded environment, obtain the "regs_lock"
	 * semaphore. This ensures that accessing registers is thread-safe.
	 */
//	ALT_SEM_PEND(dev->regs_lock, 0);

	/* Stop the msgdma dispatcher from issuing more descriptors to the
	 read or write masters  */
	/* stop issuing more descriptors */
	control = ALTERA_MSGDMA_CSR_STOP_DESCRIPTORS_MASK;
	/* making sure the read-modify-write below can't be pre-empted */
	context = alt_irq_disable_all();
	IOWR_ALTERA_MSGDMA_CSR_CONTROL(dev->csr_base, control);
	/*
	 * Clear any (previous) status register information
	 * that might occlude our error checking later.
	 */
	IOWR_ALTERA_MSGDMA_CSR_STATUS(dev->csr_base,
			IORD_ALTERA_MSGDMA_CSR_STATUS(dev->csr_base));
	alt_irq_enable_all(context);

	if (NULL != standard_desc && NULL == extended_desc) {
		counter = 0; /* reset counter */
		/*writing descriptor structure to the dispatcher, wait until descriptor
		 write is succeed*/
#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp, "invalid dma descriptor option\n");
	}
#endif

		/*
		 * Now that access to the registers is complete, release the
		 * registers semaphore so that other threads can access the
		 * registers.
		 */
//		ALT_SEM_POST(dev->regs_lock);

		return -ETIME;
	} else if (NULL == standard_desc && NULL != extended_desc) {
		counter = 0; /* reset counter */
		/*writing descriptor structure to the dispatcher, wait until descriptor
		 write is succeed*/
		while (0
				!= msgdma_write_extended_descriptor(dev->csr_base,
						dev->descriptor_base, extended_desc)) {
			alt_busy_sleep(1); /* delay 1us */
			if (5000 <= counter) /* time_out if waiting longer than 5 msec */
			{
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					debug(fp, "time out after 5 msec while waiting free FIFO buffer for storing extended descriptor\n");
				}
				#endif
				/*
				 * Now that access to the registers is complete, release the
				 * registers semaphore so that other threads can access the
				 * registers.
				 */
//				ALT_SEM_POST(dev->regs_lock);

				return -ETIME;
			}
			counter++;
		}
	} else {
		/*
		 * Now that access to the registers is complete, release the registers
		 * semaphore so that other threads can access the registers.
		 */
//		ALT_SEM_POST(dev->regs_lock);

		/* operation not permitted due to descriptor type conflict */
		return -EPERM;
	}

	/*
	 * If a callback routine has been previously registered which will be
	 * called from the msgdma ISR. Set up controller to:
	 *  - Run
	 *  - Stop on an error with any particular descriptor
	 */
	if (dev->callback) {

		control |= (dev->control |
		ALTERA_MSGDMA_CSR_STOP_ON_ERROR_MASK |
		ALTERA_MSGDMA_CSR_GLOBAL_INTERRUPT_MASK);
		control &= (~ALTERA_MSGDMA_CSR_STOP_DESCRIPTORS_MASK);
		/* making sure the read-modify-write below can't be pre-empted */
		context = alt_irq_disable_all();
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(dev->csr_base, control);
		alt_irq_enable_all(context);
	}
	/*
	 * No callback has been registered. Set up controller to:
	 *   - Run
	 *   - Stop on an error with any particular descriptor
	 *   - Disable interrupt generation
	 */
	else {
		control |= (dev->control |
		ALTERA_MSGDMA_CSR_STOP_ON_ERROR_MASK);
		control &= (~ALTERA_MSGDMA_CSR_STOP_DESCRIPTORS_MASK)
				& (~ALTERA_MSGDMA_CSR_GLOBAL_INTERRUPT_MASK);
		/* making sure the read-modify-write below can't be pre-empted */
		context = alt_irq_disable_all();
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(dev->csr_base, control);
		alt_irq_enable_all(context);
	}

	/*
	 * Now that access to the registers is complete, release the registers
	 * semaphore so that other threads can access the registers.
	 */
//	ALT_SEM_POST(dev->regs_lock);

	return 0;
}

/*
 * Helper functions for descriptor in sync transfer.
 * Arguments:
 * - *dev: Pointer to msgdma device (instance) structure.
 * - *standard_desc: Pointer to single standard descriptor.
 * - *extended_desc: Pointer to single extended descriptor.
 *
 * Note: Either one of both *standard_desc and *extended_desc must 
 *      be assigned with NULL, another with proper pointer value.
 *      Failing to do so can cause the function return with "-EPERM "
 *
 * "stop on error" of CSR control register is always being masked and interrupt 
 * is always disabled within this function.
 * The CSR control can be set by user through calling "alt_register_callback" 
 * with passing user defined control setting.
 *
 * Returns:
 * 0 -> success
 * error -> errors or conditions causing msgdma stop issuing commands to masters. 
 *          check the bit set in the error with CSR status register.
 * -EPERM -> operation not permitted due to descriptor type conflict
 * -ETIME -> Time out and skipping the looping after 5 msec.
 */
static int msgdma_descriptor_sync_transfer(alt_msgdma_dev *dev,
		alt_msgdma_standard_descriptor *standard_desc,
		alt_msgdma_extended_descriptor *extended_desc) {
	alt_u32 control = 0;
	alt_irq_context context = 0;
	alt_u32 csr_status = 0;
	alt_u16 counter = 0;
	alt_u32 fifo_read_fill_level = (
	IORD_ALTERA_MSGDMA_CSR_DESCRIPTOR_FILL_LEVEL(dev->csr_base) &
	ALTERA_MSGDMA_CSR_READ_FILL_LEVEL_MASK) >>
	ALTERA_MSGDMA_CSR_READ_FILL_LEVEL_OFFSET;
	alt_u32 fifo_write_fill_level = (
	IORD_ALTERA_MSGDMA_CSR_DESCRIPTOR_FILL_LEVEL(dev->csr_base) &
	ALTERA_MSGDMA_CSR_WRITE_FILL_LEVEL_MASK) >>
	ALTERA_MSGDMA_CSR_WRITE_FILL_LEVEL_OFFSET;
	alt_u32 error = ALTERA_MSGDMA_CSR_STOPPED_ON_ERROR_MASK |
	ALTERA_MSGDMA_CSR_STOPPED_ON_EARLY_TERMINATION_MASK |
	ALTERA_MSGDMA_CSR_STOP_STATE_MASK |
	ALTERA_MSGDMA_CSR_RESET_STATE_MASK;

	/* Wait for available FIFO buffer to store new descriptor*/
	while ((dev->descriptor_fifo_depth <= fifo_write_fill_level)
			|| (dev->descriptor_fifo_depth <= fifo_read_fill_level)) {
		alt_busy_sleep(1); /* delay 1us */
#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"\n-- DMA can't write in the descriptor \n ");
	}
#endif
		if (5000 <= counter) /* time_out if waiting longer than 5 msec */
		{
#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp, "time out after 5 msec while waiting free FIFO buffer for storing descriptor\n");
	}
#endif
			return -ETIME;
		}
		counter++;
		fifo_read_fill_level = (
		IORD_ALTERA_MSGDMA_CSR_DESCRIPTOR_FILL_LEVEL(dev->csr_base) &
		ALTERA_MSGDMA_CSR_READ_FILL_LEVEL_MASK) >>
		ALTERA_MSGDMA_CSR_READ_FILL_LEVEL_OFFSET;
		fifo_write_fill_level = (
		IORD_ALTERA_MSGDMA_CSR_DESCRIPTOR_FILL_LEVEL(dev->csr_base) &
		ALTERA_MSGDMA_CSR_WRITE_FILL_LEVEL_MASK) >>
		ALTERA_MSGDMA_CSR_WRITE_FILL_LEVEL_OFFSET;
	}

	/*
	 * When running in a multi threaded environment, obtain the "regs_lock"
	 * semaphore. This ensures that accessing registers is thread-safe.
	 */
	ALT_SEM_PEND(dev->regs_lock, 0);

	/* Stop the msgdma dispatcher from issuing more descriptors to the
	 read or write masters  */
	/* making sure the read-modify-write below can't be pre-empted */
	context = alt_irq_disable_all();
	IOWR_ALTERA_MSGDMA_CSR_CONTROL(dev->csr_base,
			ALTERA_MSGDMA_CSR_STOP_DESCRIPTORS_MASK);
	/*
	 * Clear any (previous) status register information
	 * that might occlude our error checking later.
	 */
	IOWR_ALTERA_MSGDMA_CSR_STATUS(dev->csr_base,
			IORD_ALTERA_MSGDMA_CSR_STATUS(dev->csr_base));

	if (NULL != standard_desc && NULL == extended_desc) {
		counter = 0; /* reset counter */
		/*writing descriptor structure to the dispatcher, wait until descriptor
		 write is succeed*/
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "invalid dma descriptor option\n");
		}
		#endif

		/*
		 * Now that access to the registers is complete, release the
		 * registers semaphore so that other threads can access the
		 * registers.
		 */
		ALT_SEM_POST(dev->regs_lock);

		return -ETIME;
	} else if (NULL == standard_desc && NULL != extended_desc) {
		counter = 0; /* reset counter */
		/*writing descriptor structure to the dispatcher, wait until descriptor
		 write is succeed*/
		while (0
				!= msgdma_write_extended_descriptor(dev->csr_base,
						dev->descriptor_base, extended_desc)) {
			alt_busy_sleep(1); /* delay 1us */
			if (5000 <= counter) /* time_out if waiting longer than 5 msec */
			{
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					debug(fp, "time out after 5 msec while writing extended descriptor to FIFO\n");
				}
				#endif

				/*
				 * Now that access to the registers is complete, release the
				 * registers semaphore so that other threads can access the
				 * registers.
				 */
				ALT_SEM_POST(dev->regs_lock);

				return -ETIME;
			}
			counter++;
		}
	} else {
		/*
		 * Now that access to the registers is complete, release the registers
		 * semaphore so that other threads can access the registers.
		 */
		ALT_SEM_POST(dev->regs_lock);

		/* operation not permitted due to descriptor type conflict */
		return -EPERM;
	}

	/*
	 * Set up msgdma controller to:
	 * - Disable interrupt generation
	 * - Run once a valid descriptor is written to controller
	 * - Stop on an error with any particular descriptor
	 */
	IOWR_ALTERA_MSGDMA_CSR_CONTROL(dev->csr_base,
			(dev->control | ALTERA_MSGDMA_CSR_STOP_ON_ERROR_MASK ) & (~ALTERA_MSGDMA_CSR_STOP_DESCRIPTORS_MASK) & (~ALTERA_MSGDMA_CSR_GLOBAL_INTERRUPT_MASK));

	alt_irq_enable_all(context);

	counter = 0; /* reset counter */

	csr_status = IORD_ALTERA_MSGDMA_CSR_STATUS(dev->csr_base);

	/* Wait for any pending transfers to complete or checking any errors or
	 conditions causing descriptor to stop dispatching */
	while (!(csr_status & error) && (csr_status & ALTERA_MSGDMA_CSR_BUSY_MASK)) {
		alt_busy_sleep(1); /* delay 1us */
		if (5000 <= counter) /* time_out if waiting longer than 5 msec */
		{
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				debug(fp, "time out after 5 msec while waiting for any pending transfer complete\n");
			}
			#endif

			/*
			 * Now that access to the registers is complete, release the registers
			 * semaphore so that other threads can access the registers.
			 */
			ALT_SEM_POST(dev->regs_lock);

			return -ETIME;
		}
		counter++;
		csr_status = IORD_ALTERA_MSGDMA_CSR_STATUS(dev->csr_base);
	}

	/*Errors or conditions causing the dispatcher stopping issuing read/write
	 commands to masters*/
	if (0 != (csr_status & error)) {
		/*
		 * Now that access to the registers is complete, release the registers
		 * semaphore so that other threads can access the registers.
		 */
		ALT_SEM_POST(dev->regs_lock);

		return error;
	}

	/* Stop the msgdma dispatcher from issuing more descriptors to the
	 read or write masters  */
	/* stop issuing more descriptors */
	control = IORD_ALTERA_MSGDMA_CSR_CONTROL(dev->csr_base) |
	ALTERA_MSGDMA_CSR_STOP_DESCRIPTORS_MASK;
	/* making sure the read-modify-write below can't be pre-empted */
	context = alt_irq_disable_all();
	IOWR_ALTERA_MSGDMA_CSR_CONTROL(dev->csr_base, control);
	/*
	 * Clear any (previous) status register information
	 * that might occlude our error checking later.
	 */
	IOWR_ALTERA_MSGDMA_CSR_STATUS(dev->csr_base,
			IORD_ALTERA_MSGDMA_CSR_STATUS(dev->csr_base));
	alt_irq_enable_all(context);

	/*
	 * Now that access to the registers is complete, release the registers
	 * semaphore so that other threads can access the registers.
	 */
	ALT_SEM_POST(dev->regs_lock);

	return 0;

}

/*
 * Functions for constructing extended descriptors.  If you disable some of the
 * extended features in the hardware then you should pass in 0 for that 
 * particular descriptor element. These disabled elements will not be buffered 
 * by the dispatcher block.
 * Returns:
 * - status: return 0 (success)
 *           return -EINVAL (invalid argument, could be due to argument which 
 *                          has larger value than hardware setting value)
 */
int iMsgdmaConstructExtendedMmToMmDescriptor(alt_msgdma_dev *pxDev,
		alt_msgdma_extended_descriptor *pxDescriptor, alt_u32 *puliReadAddress,
		alt_u32 *puliWriteAddress, alt_u32 uliLength, alt_u32 uliControl,
		alt_u32 *puliReadAddressHigh, alt_u32 *puliWriteAddressHigh,
		alt_u16 usiSequenceNumber, alt_u8 ucReadBurstCount,
		alt_u8 ucWriteBurstCount, alt_u16 usiReadStride, alt_u16 usiWriteStride) {

	return msgdma_construct_extended_descriptor(pxDev, pxDescriptor,
			puliReadAddress, puliWriteAddress, uliLength, uliControl,
			puliReadAddressHigh, puliWriteAddressHigh, usiSequenceNumber,
			ucReadBurstCount, ucWriteBurstCount, usiReadStride, usiWriteStride);

}

/*
 * alt_msgdma_extended_descriptor_async_transfer
 *
 * Set up and commence a non-blocking transfer of one descriptors at a time.
 *
 * If the FIFO buffer for one of read/write is full at the time of this call, 
 * the routine will immediately return -ENOSPC, the application can then
 * decide how to proceed without being blocked.
 *
 * Arguments:
 * - *dev: Pointer to msgdma device (instance) struct.
 * - *desc: Pointer to single (ready to run) descriptor.
 *
 * Returns:
 * 0 -> success
 * -ENOSPC -> FIFO descriptor buffer is full
 * -EPERM -> operation not permitted due to descriptor type conflict
 * -ETIME -> Time out and skipping the looping after 5 msec.
 */
int iMsgdmaExtendedDescriptorAsyncTransfer(alt_msgdma_dev *pxDev,
		alt_msgdma_extended_descriptor *pxDesc) {
	/*
	 * Error detection/handling should be performed at the application
	 * or callback level as appropriate.
	 */
	return msgdma_descriptor_async_transfer(pxDev, NULL, pxDesc);
}

/*
 * alt_msgdma_extended_descriptor_sync_transfer
 *
 * This function will start commencing a blocking transfer of one extended 
 * descriptor at a time. If the FIFO buffer for one of read/write is full at the 
 * time of this call, the routine will wait until free FIFO buffer available for 
 * continue processing.
 *
 * The function will return "-1" if errors or conditions causing the dispatcher 
 * stop issuing the commands to both read and write masters before both read and 
 * write command buffers are empty.
 *
 * Additional error information is available in the status bits of
 * each descriptor that the msgdma processed; it is the responsibility
 * of the user's application to search through the descriptor 
 * to gather specific error information.
 *
 *
 * Arguments:
 * - *dev: Pointer to msgdma device (instance) structure.
 * - *desc: Pointer to single (ready to run) descriptor.
 *
 * Returns:
 * - status: return 0 (success)
 *           return error (errors or conditions causing msgdma stop issuing 
 *		commands to masters)
 *           Suggest suggest checking the bit set in the error with CSR status 
 *		register.
 *           return -EPERM (operation not permitted due to descriptor type 
 *		conflict)
 *           return -ETIME (Time out and skipping the looping after 5 msec)
 */
int iMsgdmaExtendedDescriptorSyncTransfer(alt_msgdma_dev *pxDev,
		alt_msgdma_extended_descriptor *pxDesc) {
	return msgdma_descriptor_sync_transfer(pxDev, NULL, pxDesc);
}

