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

// spw channel 1 [a]
#define FEEB_CH_1_R_BUFF_BASE_ADDR_LOW  0x00000000
#define FEEB_CH_1_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_1_R_BUFF_SPAN           0x1FFF
#define FEEB_CH_1_L_BUFF_BASE_ADDR_LOW  0x00010000
#define FEEB_CH_1_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_1_L_BUFF_SPAN           0x1FFF
// spw channel 2 [b]
#define FEEB_CH_2_R_BUFF_BASE_ADDR_LOW  0x00002000
#define FEEB_CH_2_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_2_R_BUFF_SPAN           0x1FFF
#define FEEB_CH_2_L_BUFF_BASE_ADDR_LOW  0x00012000
#define FEEB_CH_2_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_2_L_BUFF_SPAN           0x1FFF
// spw channel 3 [c]
#define FEEB_CH_3_R_BUFF_BASE_ADDR_LOW  0x00004000
#define FEEB_CH_3_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_3_R_BUFF_SPAN           0x1FFF
#define FEEB_CH_3_L_BUFF_BASE_ADDR_LOW  0x00014000
#define FEEB_CH_3_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_3_L_BUFF_SPAN           0x1FFF
// spw channel 4 [d]
#define FEEB_CH_4_R_BUFF_BASE_ADDR_LOW  0x00006000
#define FEEB_CH_4_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_4_R_BUFF_SPAN           0x1FFF
#define FEEB_CH_4_L_BUFF_BASE_ADDR_LOW  0x00016000
#define FEEB_CH_4_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_4_L_BUFF_SPAN           0x1FFF
// spw channel 5 [e]
#define FEEB_CH_5_R_BUFF_BASE_ADDR_LOW  0x00008000
#define FEEB_CH_5_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_5_R_BUFF_SPAN           0x1FFF
#define FEEB_CH_5_L_BUFF_BASE_ADDR_LOW  0x00018000
#define FEEB_CH_5_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_5_L_BUFF_SPAN           0x1FFF
// spw channel 6 [f]
#define FEEB_CH_6_R_BUFF_BASE_ADDR_LOW  0x0000a000
#define FEEB_CH_6_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_6_R_BUFF_SPAN           0x1FFF
#define FEEB_CH_6_L_BUFF_BASE_ADDR_LOW  0x0001a000
#define FEEB_CH_6_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_6_L_BUFF_SPAN           0x1FFF
// spw channel 7 [g]
#define FEEB_CH_7_R_BUFF_BASE_ADDR_LOW  0x0000c000
#define FEEB_CH_7_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_7_R_BUFF_SPAN           0x1FFF
#define FEEB_CH_7_L_BUFF_BASE_ADDR_LOW  0x0001c000
#define FEEB_CH_7_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_7_L_BUFF_SPAN           0x1FFF
// spw channel 8 [h]
#define FEEB_CH_8_R_BUFF_BASE_ADDR_LOW  0x0000e000
#define FEEB_CH_8_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_8_R_BUFF_SPAN           0x1FFF
#define FEEB_CH_8_L_BUFF_BASE_ADDR_LOW  0x0001e000
#define FEEB_CH_8_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define FEEB_CH_8_L_BUFF_SPAN           0x1FFF
// ddr mem
#define FEEB_M1_BASE_ADDR_LOW           0x00000000
#define FEEB_M1_BASE_ADDR_HIGH          0x00000000
#define FEEB_M1_SPAN                    0x7FFFFFFF
#define FEEB_M2_BASE_ADDR_LOW           0x80000000
#define FEEB_M2_BASE_ADDR_HIGH          0x00000000
#define FEEB_M2_SPAN                    0x7FFFFFFF
//
#define FEEB_DMA_M1_NAME                DMA_DDR_M1_CSR_NAME
#define FEEB_DMA_M2_NAME                DMA_DDR_M2_CSR_NAME
//
#define FEEB_PIXEL_BLOCK_SIZE_BYTES     136
#define FEEB_BUFFER_SIZE_BYTES          (FEEB_PIXEL_BLOCK_SIZE_BYTES * 16)

typedef struct FeebPixelDataBlock {
	alt_u16 usiPixel[64];
	alt_u64 ulliMask;
} TFeebPixelDataBlock;

typedef struct FeebBufferDataBlock {
	TFeebPixelDataBlock xPixelDataBlock[16];
} TFeebBufferDataBlock;

enum FeebBufferSide {
	eFeebRightBuffer = 0, eFeebLeftBuffer = 1
} EFeebBufferSide;

enum FeeChBufferId {
	eFeebCh1Buffer = 1,
	eFeebCh2Buffer = 2,
	eFeebCh3Buffer = 3,
	eFeebCh4Buffer = 4,
	eFeebCh5Buffer = 5,
	eFeebCh6Buffer = 6,
	eFeebCh7Buffer = 7,
	eFeebCh8Buffer = 8
} EFeeChBufferId;

bool bFeebInitM1Dma(void);
bool bFeebInitM2Dma(void);
bool bFeebDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiSizeInBlocks,
		alt_u8 ucBufferSide, alt_u8 ucChBufferId);
bool bFeebDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiSizeInBlocks,
		alt_u8 ucBufferSide, alt_u8 ucChBufferId);

#endif /* FEE_BUFFERS_H_ */
