/*
 * fee_buffers.c
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#include "fee_buffers.h"

alt_msgdma_dev *dma_m1_dev = NULL;
alt_msgdma_dev *dma_m2_dev = NULL;

bool fee_init_m1_dma(void) {
	bool status = TRUE;
	alt_u16 counter = 0;

	// open dma device
	dma_m1_dev = alt_msgdma_open((char *) FEE_DMA_M1_NAME);

	// check if the device was opened
	if (dma_m1_dev == NULL) {
		// device not opened
		status = FALSE;
	} else {
		// device opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(dma_m1_dev->csr_base,
				ALTERA_MSGDMA_CSR_RESET_MASK);
		while (IORD_ALTERA_MSGDMA_CSR_STATUS(dma_m1_dev->csr_base)
				& ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
			usleep(1);
			counter++;
			if (counter >= 5000) { //wait at most 5ms for the device to be reseted
				status = FALSE;
				break;
			}
		}
	}

	return status;
}

bool fee_init_m2_dma(void) {
	bool status = TRUE;
	alt_u16 counter = 0;

	// open dma device
	dma_m2_dev = alt_msgdma_open((char *) FEE_DMA_M2_NAME);

	// check if the device was opened
	if (dma_m2_dev == NULL) {
		// device not opened
		status = FALSE;
	} else {
		// device opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(dma_m2_dev->csr_base,
				ALTERA_MSGDMA_CSR_RESET_MASK);
		while (IORD_ALTERA_MSGDMA_CSR_STATUS(dma_m2_dev->csr_base)
				& ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
			usleep(1);
			counter++;
			if (counter >= 5000) { //wait at most 5ms for the device to be reseted
				status = FALSE;
				break;
			}
		}
	}

	return status;
}

bool fee_dma_m1_transfer(alt_u32 *ddr_initial_address, alt_u16 size_in_blocks,
		alt_u8 buffer_side, alt_u8 channel_buffer_id) {
	bool status = TRUE;
	alt_u16 cnt = 0;

	alt_msgdma_extended_descriptor dma_extended_descriptor;

	alt_u32 dest_addr_low = 0;
	alt_u32 dest_addr_high = 0;

	alt_u32 src_addr_low = 0;
	alt_u32 src_addr_high = 0;

	alt_u32 control_bits = 0x00000000;

	switch (channel_buffer_id) {
	case channel_a_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_A_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_A_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_A_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_A_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_b_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_B_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_B_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_B_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_B_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_c_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_C_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_C_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_C_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_C_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_d_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_D_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_D_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_D_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_D_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_e_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_E_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_E_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_E_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_E_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_f_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_F_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_F_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_F_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_F_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_g_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_G_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_G_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_G_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_G_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_h_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_H_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_H_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_H_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_H_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	default:
		status = FALSE;
		break;
	}

	src_addr_low = (alt_u32) FEE_M1_BASE_ADDR_LOW
			+ (alt_u32) ddr_initial_address;
	src_addr_high = (alt_u32) FEE_M1_BASE_ADDR_HIGH;

	if (status) {
		if (dma_m1_dev == NULL) {
			status = FALSE;
		} else {
			for (cnt = 0; cnt < size_in_blocks; cnt++) {
				if (msgdma_construct_extended_mm_to_mm_descriptor(dma_m1_dev,
						&dma_extended_descriptor, (alt_u32 *) src_addr_low,
						(alt_u32 *) dest_addr_low,
						FEE_PIXEL_BLOCK_SIZE_BYTES, control_bits,
						(alt_u32 *) src_addr_high, (alt_u32 *) dest_addr_high,
						1, 1, 1, 1, 1)) {
					status = FALSE;
					break;
				} else {
					if (msgdma_extended_descriptor_sync_transfer(dma_m1_dev,
							&dma_extended_descriptor)) {
						status = FALSE;
						break;
					}
					src_addr_low += (alt_u32) FEE_PIXEL_BLOCK_SIZE_BYTES;
					src_addr_high = (alt_u32) FEE_M1_BASE_ADDR_HIGH;
				}
			}
		}
	}
	return status;
}

bool fee_dma_m2_transfer(alt_u32 *ddr_initial_address, alt_u16 size_in_blocks,
		alt_u8 buffer_side, alt_u8 channel_buffer_id) {
	bool status = TRUE;
	alt_u16 cnt = 0;

	alt_msgdma_extended_descriptor dma_extended_descriptor;

	alt_u32 dest_addr_low = 0;
	alt_u32 dest_addr_high = 0;

	alt_u32 src_addr_low = 0;
	alt_u32 src_addr_high = 0;

	alt_u32 control_bits = 0x00000000;

	switch (channel_buffer_id) {
	case channel_a_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_A_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_A_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_A_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_A_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_b_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_B_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_B_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_B_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_B_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_c_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_C_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_C_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_C_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_C_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_d_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_D_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_D_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_D_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_D_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_e_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_E_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_E_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_E_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_E_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_f_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_F_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_F_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_F_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_F_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_g_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_G_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_G_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_G_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_G_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	case channel_h_buffer:
		switch (buffer_side) {
		case right_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_H_RIGHT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high =
					(alt_u32) FEE_CHANNEL_H_RIGHT_BUFFER_BASE_ADDR_HIGH;
			break;
		case left_buffer:
			dest_addr_low = (alt_u32) FEE_CHANNEL_H_LEFT_BUFFER_BASE_ADDR_LOW;
			dest_addr_high = (alt_u32) FEE_CHANNEL_H_LEFT_BUFFER_BASE_ADDR_HIGH;
			break;
		default:
			status = FALSE;
			break;
		}
		break;
	default:
		status = FALSE;
		break;
	}

	src_addr_low = (alt_u32) FEE_M2_BASE_ADDR_LOW
			+ (alt_u32) ddr_initial_address;
	src_addr_high = (alt_u32) FEE_M2_BASE_ADDR_HIGH;

	if (status) {
		if (dma_m2_dev == NULL) {
			status = FALSE;
		} else {
			for (cnt = 0; cnt < size_in_blocks; cnt++) {
				if (msgdma_construct_extended_mm_to_mm_descriptor(dma_m2_dev,
						&dma_extended_descriptor, (alt_u32 *) src_addr_low,
						(alt_u32 *) dest_addr_low,
						FEE_PIXEL_BLOCK_SIZE_BYTES, control_bits,
						(alt_u32 *) src_addr_high, (alt_u32 *) dest_addr_high,
						1, 1, 1, 1, 1)) {
					status = FALSE;
					break;
				} else {
					if (msgdma_extended_descriptor_sync_transfer(dma_m2_dev,
							&dma_extended_descriptor)) {
						status = FALSE;
						break;
					}
					src_addr_low += (alt_u32) FEE_PIXEL_BLOCK_SIZE_BYTES;
					src_addr_high = (alt_u32) FEE_M2_BASE_ADDR_HIGH;
				}
			}
		}
	}
	return status;
	return status;
}
