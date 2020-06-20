/*
 * simucam_dma.h
 *
 *  Created on: 10/01/2019
 *      Author: rfranca
 */

#ifndef SIMUCAM_DMA_H_
#define SIMUCAM_DMA_H_

#include "../../simucam_definitions.h"
#include "../../driver/comm/fee_buffers/fee_buffers.h"
#include "../../driver/ftdi/ftdi.h"

//! [constants definition]
#define SDMA_M1_BASE_ADDR               (alt_u64)0x0000000000000000
#define SDMA_M1_SPAN                    (alt_u32)0x7FFFFFFF
#define SDMA_M2_BASE_ADDR               (alt_u64)0x0000000080000000
#define SDMA_M2_SPAN                    (alt_u32)x7FFFFFFF

#define SDMA_PIXEL_BLOCK_SIZE_BYTES     (alt_u32)136u
#define SDMA_MAX_BLOCKS					(alt_u32)493447u
#define SDMA_BUFFER_SIZE_BYTES          (alt_u32)(SDMA_PIXEL_BLOCK_SIZE_BYTES * SDMA_MAX_BLOCKS)
//! [constants definition]

//! [public module structs definition]
union MemoryAddress {
	alt_u64 ulliMemAddr64b;
	alt_u32 uliMemAddr32b[2];
};

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
	eSdmaCh2Buffer,
	eSdmaCh3Buffer,
	eSdmaCh4Buffer,
	eSdmaCh5Buffer,
	eSdmaCh6Buffer,
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
