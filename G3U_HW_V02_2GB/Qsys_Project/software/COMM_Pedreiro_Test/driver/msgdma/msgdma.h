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

#ifndef __MSGDMA_H__
#define __MSGDMA_H__

#include <stddef.h>
#include <errno.h>

#include "sys/alt_dev.h"
#include "alt_types.h"
#include "altera_msgdma.h"
#include "altera_msgdma_csr_regs.h"
#include "altera_msgdma_descriptor_regs.h"
#include "altera_msgdma_response_regs.h"
#include "altera_msgdma_prefetcher_regs.h"
#include "os/alt_sem.h"
#include "os/alt_flag.h"

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*******************************************************************************
 *  Public API
 ******************************************************************************/

int msgdma_extended_descriptor_async_transfer(
	alt_msgdma_dev *dev,
	alt_msgdma_extended_descriptor *desc);

int msgdma_construct_extended_mm_to_mm_descriptor (
	alt_msgdma_dev *dev,
	alt_msgdma_extended_descriptor *descriptor, 
	alt_u32 *read_address, 
	alt_u32 *write_address, 
	alt_u32 length, 
	alt_u32 control, alt_u32 *read_address_high, alt_u32 *write_address_high, alt_u16 sequence_number,
	alt_u8 read_burst_count,
	alt_u8 write_burst_count, 
	alt_u16 read_stride, 
	alt_u16 write_stride);

int msgdma_extended_descriptor_sync_transfer(
	alt_msgdma_dev *dev,
	alt_msgdma_extended_descriptor *desc);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __MSGDMA_H__ */
