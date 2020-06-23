/*
 * simucam_dma.h
 *
 *  Created on: 10/01/2019
 *      Author: rfranca
 */

#ifndef SIMUCAM_DMA_H_
#define SIMUCAM_DMA_H_

#include "../../simucam_definitions.h"
#include "../../api_driver/ddr2/ddr2.h"
#include "../../driver/comm/fee_buffers/fee_buffers.h"
#include "../../driver/ftdi/ftdi.h"

//! [constants definition]
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
	eSdmaCh1Buffer = 0, eSdmaCh2Buffer, eSdmaCh3Buffer, eSdmaCh4Buffer, eSdmaCh5Buffer, eSdmaCh6Buffer,
} ESdmaChBufferId;

enum SdmaFtdiOperation {
	eSdmaTxFtdi = 0, eSdmaRxFtdi,
} ESdmaFtdiOperation;
//! [public module structs definition]

//! [public function prototypes]
bool bSdmaInitComm1Dmas(void);
bool bSdmaInitComm2Dmas(void);
bool bSdmaInitComm3Dmas(void);
bool bSdmaInitComm4Dmas(void);
bool bSdmaInitComm5Dmas(void);
bool bSdmaInitComm6Dmas(void);
bool bSdmaInitFtdiRxDma(void);
bool bSdmaInitFtdiTxDma(void);
bool bSdmaResetCommDma(alt_u8 ucChBufferId, alt_u8 ucBufferSide, bool bWait);
bool bSdmaResetFtdiDma(bool bWait);
bool bSdmaCommDmaTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId);
bool bSdmaFtdiDmaTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucFtdiOperation);

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
