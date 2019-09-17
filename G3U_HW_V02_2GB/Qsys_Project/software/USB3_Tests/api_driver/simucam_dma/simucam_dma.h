/*
 * simucam_dma.h
 *
 *  Created on: 10/01/2019
 *      Author: rfranca
 */

#ifndef SIMUCAM_DMA_H_
#define SIMUCAM_DMA_H_

#include "../../driver/msgdma/msgdma.h"
#include "../../simucam_definitions.h"

//! [constants definition]
// address
// spw channel 1 [a]
#define SDMA_CH_1_L_BUFF_BASE_ADDR_LOW  0x00000000
#define SDMA_CH_1_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_1_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_1_R_BUFF_BASE_ADDR_LOW  0x00008000
#define SDMA_CH_1_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_1_R_BUFF_SPAN           0x1FFF
// spw channel 2 [b]
#define SDMA_CH_2_L_BUFF_BASE_ADDR_LOW  0x00010000
#define SDMA_CH_2_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_2_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_2_R_BUFF_BASE_ADDR_LOW  0x00018000
#define SDMA_CH_2_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_2_R_BUFF_SPAN           0x1FFF
// spw channel 3 [c]
#define SDMA_CH_3_L_BUFF_BASE_ADDR_LOW  0x00020000
#define SDMA_CH_3_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_3_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_3_R_BUFF_BASE_ADDR_LOW  0x00028000
#define SDMA_CH_3_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_3_R_BUFF_SPAN           0x1FFF
// spw channel 4 [d]
#define SDMA_CH_4_L_BUFF_BASE_ADDR_LOW  0x00030000
#define SDMA_CH_4_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_4_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_4_R_BUFF_BASE_ADDR_LOW  0x00038000
#define SDMA_CH_4_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_4_R_BUFF_SPAN           0x1FFF
// spw channel 5 [e]
#define SDMA_CH_5_L_BUFF_BASE_ADDR_LOW  0x00040000
#define SDMA_CH_5_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_5_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_5_R_BUFF_BASE_ADDR_LOW  0x00048000
#define SDMA_CH_5_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_5_R_BUFF_SPAN           0x1FFF
// spw channel 6 [f]
#define SDMA_CH_6_L_BUFF_BASE_ADDR_LOW  0x00050000
#define SDMA_CH_6_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_6_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_6_R_BUFF_BASE_ADDR_LOW  0x00058000
#define SDMA_CH_6_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_6_R_BUFF_SPAN           0x1FFF
// spw channel 7 [g]
#define SDMA_CH_7_L_BUFF_BASE_ADDR_LOW  0x00060000
#define SDMA_CH_7_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_7_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_7_R_BUFF_BASE_ADDR_LOW  0x00068000
#define SDMA_CH_7_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_7_R_BUFF_SPAN           0x1FFF
// spw channel 8 [h]
#define SDMA_CH_8_L_BUFF_BASE_ADDR_LOW  0x00070000
#define SDMA_CH_8_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_8_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_8_R_BUFF_BASE_ADDR_LOW  0x00078000
#define SDMA_CH_8_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_8_R_BUFF_SPAN           0x1FFF
// ftdi tx/rx buffer
#define SDMA_FTDI_BUFF_BASE_ADDR_LOW    0x00000000
#define SDMA_FTDI_BUFF_BASE_ADDR_HIGH   0x00000002
#define SDMA_FTDI_BUFF_SPAN             0x1FFF
// ddr mem
#define SDMA_M1_BASE_ADDR_LOW           0x00000000
#define SDMA_M1_BASE_ADDR_HIGH          0x00000000
#define SDMA_M1_SPAN                    0x7FFFFFFF
#define SDMA_M2_BASE_ADDR_LOW           0x80000000
#define SDMA_M2_BASE_ADDR_HIGH          0x00000000
#define SDMA_M2_SPAN                    0x7FFFFFFF
//
#define SDMA_DMA_M1_NAME                DMA_DDR_M1_CSR_NAME
#define SDMA_DMA_M2_NAME                DMA_DDR_M2_CSR_NAME
//
#define SDMA_PIXEL_BLOCK_SIZE_BYTES     (unsigned long)136u
#define SDMA_MAX_BLOCKS					(unsigned long)16u

#define SDMA_BUFFER_SIZE_BYTES          (unsigned long)(SDMA_PIXEL_BLOCK_SIZE_BYTES * SDMA_MAX_BLOCKS)


// bit masks
//! [constants definition]

//! [public module structs definition]
typedef struct SdmaPixelDataBlock {
	alt_u16 usiPixel[64];
	alt_u64 ulliMask;
} TSdmaPixelDataBlock;

typedef struct SdmaBufferDataBlock {
	TSdmaPixelDataBlock xPixelDataBlock[16];
} TSdmaBufferDataBlock;

enum SdmaBufferSide {
	eSdmaLeftBuffer = 0, eSdmaRightBuffer, 
} ESdmaBufferSide;

enum SdmaChBufferId {
	eSdmaCh1Buffer = 0,
	eSdmaCh2Buffer = 1,
	eSdmaCh3Buffer = 2,
	eSdmaCh4Buffer = 3,
	eSdmaCh5Buffer = 4,
	eSdmaCh6Buffer = 5,
	eSdmaCh7Buffer = 6,
	eSdmaCh8Buffer = 7
} ESdmaChBufferId;

enum SdmaFtdiOperation {
	eSdmaTxFtdi = 0, eSdmaRxFtdi,
} ESdmaFtdiOperation;
//! [public module structs definition]

//! [public function prototypes]
bool bSdmaInitM1Dma(void);
bool bSdmaInitM2Dma(void);
bool bSdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks,
		alt_u8 ucBufferSide, alt_u8 ucChBufferId);
bool bSdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks,
		alt_u8 ucBufferSide, alt_u8 ucChBufferId);
bool bSdmaDmaM1FtdiTransfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucFtdiOperation);
bool bSdmaDmaM2FtdiTransfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucFtdiOperation);
bool bSdmaSetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* SIMUCAM_DMA_H_ */