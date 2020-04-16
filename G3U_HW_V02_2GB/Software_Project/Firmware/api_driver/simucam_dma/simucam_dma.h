/*
 * simucam_dma.h
 *
 *  Created on: 10/01/2019
 *      Author: rfranca
 */

#ifndef SIMUCAM_DMA_H_
#define SIMUCAM_DMA_H_

#include "../../simucam_definitions.h"
#include "../../driver/msgdma/msgdma.h"
#include "../../driver/comm/fee_buffers/fee_buffers.h"
#include "../../driver/ftdi/ftdi.h"

//! [constants definition]
// address
// spw channel 1 [a]
#define SDMA_CH_1_L_BUFF_BASE_ADDR_LOW  0x00000000
#define SDMA_CH_1_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_1_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_1_R_BUFF_BASE_ADDR_LOW  0x04000000
#define SDMA_CH_1_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_1_R_BUFF_SPAN           0x1FFF
// spw channel 2 [b]
#define SDMA_CH_2_L_BUFF_BASE_ADDR_LOW  0x08000000
#define SDMA_CH_2_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_2_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_2_R_BUFF_BASE_ADDR_LOW  0x0C000000
#define SDMA_CH_2_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_2_R_BUFF_SPAN           0x1FFF
// spw channel 3 [c]
#define SDMA_CH_3_L_BUFF_BASE_ADDR_LOW  0x10000000
#define SDMA_CH_3_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_3_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_3_R_BUFF_BASE_ADDR_LOW  0x14000000
#define SDMA_CH_3_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_3_R_BUFF_SPAN           0x1FFF
// spw channel 4 [d]
#define SDMA_CH_4_L_BUFF_BASE_ADDR_LOW  0x18000000
#define SDMA_CH_4_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_4_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_4_R_BUFF_BASE_ADDR_LOW  0x1C000000
#define SDMA_CH_4_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_4_R_BUFF_SPAN           0x1FFF
// spw channel 5 [e]
#define SDMA_CH_5_L_BUFF_BASE_ADDR_LOW  0x20000000
#define SDMA_CH_5_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_5_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_5_R_BUFF_BASE_ADDR_LOW  0x24000000
#define SDMA_CH_5_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_5_R_BUFF_SPAN           0x1FFF
// spw channel 6 [f]
#define SDMA_CH_6_L_BUFF_BASE_ADDR_LOW  0x28000000
#define SDMA_CH_6_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_6_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_6_R_BUFF_BASE_ADDR_LOW  0x2C000000
#define SDMA_CH_6_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_6_R_BUFF_SPAN           0x1FFF
// spw channel 7 [g]
#define SDMA_CH_7_L_BUFF_BASE_ADDR_LOW  0x30000000
#define SDMA_CH_7_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_7_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_7_R_BUFF_BASE_ADDR_LOW  0x34000000
#define SDMA_CH_7_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_7_R_BUFF_SPAN           0x1FFF
// spw channel 8 [h]
#define SDMA_CH_8_L_BUFF_BASE_ADDR_LOW  0x38000000
#define SDMA_CH_8_L_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_8_L_BUFF_SPAN           0x1FFF
#define SDMA_CH_8_R_BUFF_BASE_ADDR_LOW  0x3C000000
#define SDMA_CH_8_R_BUFF_BASE_ADDR_HIGH 0x00000001
#define SDMA_CH_8_R_BUFF_SPAN           0x1FFF
// ftdi tx/rx buffer
#define SDMA_FTDI_BUFF_BASE_ADDR_LOW    0x00000000
#define SDMA_FTDI_BUFF_BASE_ADDR_HIGH   0x00000002
#define SDMA_FTDI_BUFF_SPAN             0x7FFF
// ddr mem
#define SDMA_M1_BASE_ADDR_LOW           0x00000000
#define SDMA_M1_BASE_ADDR_HIGH          0x00000000
#define SDMA_M1_SPAN                    0x7FFFFFFF
#define SDMA_M2_BASE_ADDR_LOW           0x80000000
#define SDMA_M2_BASE_ADDR_HIGH          0x00000000
#define SDMA_M2_SPAN                    0x7FFFFFFF
//
#define SDMA_DMA_CH_1_LEFT_NAME         DMA_COMM_1_LEFT_CSR_NAME
#define SDMA_DMA_CH_1_RIGHT_NAME        DMA_COMM_1_RIGHT_CSR_NAME
#define SDMA_DMA_CH_2_LEFT_NAME         DMA_COMM_2_LEFT_CSR_NAME
#define SDMA_DMA_CH_2_RIGHT_NAME        DMA_COMM_2_RIGHT_CSR_NAME
#define SDMA_DMA_CH_3_LEFT_NAME         DMA_COMM_3_LEFT_CSR_NAME
#define SDMA_DMA_CH_3_RIGHT_NAME        DMA_COMM_3_RIGHT_CSR_NAME
#define SDMA_DMA_CH_4_LEFT_NAME         DMA_COMM_4_LEFT_CSR_NAME
#define SDMA_DMA_CH_4_RIGHT_NAME        DMA_COMM_4_RIGHT_CSR_NAME
#define SDMA_DMA_CH_5_LEFT_NAME         DMA_COMM_5_LEFT_CSR_NAME
#define SDMA_DMA_CH_5_RIGHT_NAME        DMA_COMM_5_RIGHT_CSR_NAME
#define SDMA_DMA_CH_6_LEFT_NAME         DMA_COMM_6_LEFT_CSR_NAME
#define SDMA_DMA_CH_6_RIGHT_NAME        DMA_COMM_6_RIGHT_CSR_NAME
#define SDMA_DMA_FTDI_RX_NAME           DMA_FTDI_RX_USB3_CSR_NAME
#define SDMA_DMA_FTDI_TX_NAME           DMA_FTDI_TX_USB3_CSR_NAME

//
#define SDMA_PIXEL_BLOCK_SIZE_BYTES     (unsigned long)136u
#define SDMA_MAX_BLOCKS					(unsigned long)493447u
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
bool bSdmaInitCh1Dmas(void);
bool bSdmaInitCh2Dmas(void);
bool bSdmaInitCh3Dmas(void);
bool bSdmaInitCh4Dmas(void);
bool bSdmaInitCh5Dmas(void);
bool bSdmaInitCh6Dmas(void);
bool bSdmaInitFtdiRxDma(void);
bool bSdmaInitFtdiTxDma(void);
bool bSdmaResetChDma(alt_u8 ucChBufferId, alt_u8 ucBufferSide, bool bWait);
bool bSdmaResetFtdiDma(bool bWait);
bool bSdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId);
bool bSdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId);
bool bSdmaSetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId);
bool bFTDIDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucFtdiOperation);
bool bFTDIDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucFtdiOperation);
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
