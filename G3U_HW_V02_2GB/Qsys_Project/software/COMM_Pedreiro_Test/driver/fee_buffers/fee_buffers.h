/*
 * fee_buffers.h
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#ifndef FEE_BUFFERS_H_
#define FEE_BUFFERS_H_

#include "../../utils/meb_includes.h"
#include "../../logic/dma/dma.h"

// spw channel a [1]
#define FEE_CHANNEL_A_RIGHT_BUFFER_BASE_ADDR_LOW  0x00000000
#define FEE_CHANNEL_A_RIGHT_BUFFER_BASE_ADDR_HIGH 0x00000001
#define FEE_CHANNEL_A_RIGHT_BUFFER_SPAN           0x1FFF
#define FEE_CHANNEL_A_LEFT_BUFFER_BASE_ADDR_LOW   0x00010000
#define FEE_CHANNEL_A_LEFT_BUFFER_BASE_ADDR_HIGH  0x00000001
#define FEE_CHANNEL_A_LEFT_BUFFER_SPAN            0x1FFF
// spw channel b [2]
#define FEE_CHANNEL_B_RIGHT_BUFFER_BASE_ADDR_LOW  0x00002000
#define FEE_CHANNEL_B_RIGHT_BUFFER_BASE_ADDR_HIGH 0x00000001
#define FEE_CHANNEL_B_RIGHT_BUFFER_SPAN           0x1FFF
#define FEE_CHANNEL_B_LEFT_BUFFER_BASE_ADDR_LOW   0x00012000
#define FEE_CHANNEL_B_LEFT_BUFFER_BASE_ADDR_HIGH  0x00000001
#define FEE_CHANNEL_B_LEFT_BUFFER_SPAN            0x1FFF
// spw channel c [3]
#define FEE_CHANNEL_C_RIGHT_BUFFER_BASE_ADDR_LOW  0x00004000
#define FEE_CHANNEL_C_RIGHT_BUFFER_BASE_ADDR_HIGH 0x00000001
#define FEE_CHANNEL_C_RIGHT_BUFFER_SPAN           0x1FFF
#define FEE_CHANNEL_C_LEFT_BUFFER_BASE_ADDR_LOW   0x00014000
#define FEE_CHANNEL_C_LEFT_BUFFER_BASE_ADDR_HIGH  0x00000001
#define FEE_CHANNEL_C_LEFT_BUFFER_SPAN            0x1FFF
// spw channel d [4]
#define FEE_CHANNEL_D_RIGHT_BUFFER_BASE_ADDR_LOW  0x00006000
#define FEE_CHANNEL_D_RIGHT_BUFFER_BASE_ADDR_HIGH 0x00000001
#define FEE_CHANNEL_D_RIGHT_BUFFER_SPAN           0x1FFF
#define FEE_CHANNEL_D_LEFT_BUFFER_BASE_ADDR_LOW   0x00016000
#define FEE_CHANNEL_D_LEFT_BUFFER_BASE_ADDR_HIGH  0x00000001
#define FEE_CHANNEL_D_LEFT_BUFFER_SPAN            0x1FFF
// spw channel e [5]
#define FEE_CHANNEL_E_RIGHT_BUFFER_BASE_ADDR_LOW  0x00008000
#define FEE_CHANNEL_E_RIGHT_BUFFER_BASE_ADDR_HIGH 0x00000001
#define FEE_CHANNEL_E_RIGHT_BUFFER_SPAN           0x1FFF
#define FEE_CHANNEL_E_LEFT_BUFFER_BASE_ADDR_LOW   0x00018000
#define FEE_CHANNEL_E_LEFT_BUFFER_BASE_ADDR_HIGH  0x00000001
#define FEE_CHANNEL_E_LEFT_BUFFER_SPAN            0x1FFF
// spw channel f [6]
#define FEE_CHANNEL_F_RIGHT_BUFFER_BASE_ADDR_LOW  0x0000a000
#define FEE_CHANNEL_F_RIGHT_BUFFER_BASE_ADDR_HIGH 0x00000001
#define FEE_CHANNEL_F_RIGHT_BUFFER_SPAN           0x1FFF
#define FEE_CHANNEL_F_LEFT_BUFFER_BASE_ADDR_LOW   0x0001a000
#define FEE_CHANNEL_F_LEFT_BUFFER_BASE_ADDR_HIGH  0x00000001
#define FEE_CHANNEL_F_LEFT_BUFFER_SPAN            0x1FFF
// spw channel g [7]
#define FEE_CHANNEL_G_RIGHT_BUFFER_BASE_ADDR_LOW  0x0000c000
#define FEE_CHANNEL_G_RIGHT_BUFFER_BASE_ADDR_HIGH 0x00000001
#define FEE_CHANNEL_G_RIGHT_BUFFER_SPAN           0x1FFF
#define FEE_CHANNEL_G_LEFT_BUFFER_BASE_ADDR_LOW   0x0001c000
#define FEE_CHANNEL_G_LEFT_BUFFER_BASE_ADDR_HIGH  0x00000001
#define FEE_CHANNEL_G_LEFT_BUFFER_SPAN            0x1FFF
// spw channel h [8]
#define FEE_CHANNEL_H_RIGHT_BUFFER_BASE_ADDR_LOW  0x0000e000
#define FEE_CHANNEL_H_RIGHT_BUFFER_BASE_ADDR_HIGH 0x00000001
#define FEE_CHANNEL_H_RIGHT_BUFFER_SPAN           0x1FFF
#define FEE_CHANNEL_H_LEFT_BUFFER_BASE_ADDR_LOW   0x0001e000
#define FEE_CHANNEL_H_LEFT_BUFFER_BASE_ADDR_HIGH  0x00000001
#define FEE_CHANNEL_H_LEFT_BUFFER_SPAN            0x1FFF
// ddr mem
#define FEE_M1_BASE_ADDR_LOW  0x00000000
#define FEE_M1_BASE_ADDR_HIGH 0x00000000
#define FEE_M1_SPAN           0x7FFFFFFF
#define FEE_M2_BASE_ADDR_LOW  0x80000000
#define FEE_M2_BASE_ADDR_HIGH 0x00000000
#define FEE_M2_SPAN           0x7FFFFFFF
//
#define FEE_DMA_M1_NAME DMA_DDR_M1_CSR_NAME
#define FEE_DMA_M2_NAME DMA_DDR_M2_CSR_NAME
//
#define FEE_PIXEL_BLOCK_SIZE_BYTES 2176

typedef struct fee_pixel_data_block_t {
	alt_u16 pixel[64];
	alt_u64 mask;
} fee_pixel_data_block_t;

typedef struct fee_buffer_data_block_t {
	fee_pixel_data_block_t pixel_data_block[16];
} fee_buffer_data_block_t;

enum fee_buffer_side_t {
	right_buffer = 0, left_buffer = 1
} fee_buffer_side_t;

enum fee_channel_buffer_id_t {
	channel_a_buffer = 1,
	channel_b_buffer = 2,
	channel_c_buffer = 3,
	channel_d_buffer = 4,
	channel_e_buffer = 5,
	channel_f_buffer = 6,
	channel_g_buffer = 7,
	channel_h_buffer = 8
} fee_channel_buffer_id_t;

bool fee_init_m1_dma(void);
bool fee_init_m2_dma(void);
bool fee_dma_m1_transfer(alt_u32 *ddr_initial_address, alt_u16 size_in_blocks,
		alt_u8 buffer_side, alt_u8 channel_buffer_id);
bool fee_dma_m2_transfer(alt_u32 *ddr_initial_address, alt_u16 size_in_blocks,
		alt_u8 buffer_side, alt_u8 channel_buffer_id);

#endif /* FEE_BUFFERS_H_ */
