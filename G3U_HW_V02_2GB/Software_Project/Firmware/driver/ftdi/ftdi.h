/*
 * ftdi.h
 *
 *  Created on: 5 de set de 2019
 *      Author: rfranca
 */

#ifndef DRIVER_FTDI_FTDI_H_
#define DRIVER_FTDI_FTDI_H_

#include "../../simucam_definitions.h"
#include "../../utils/queue_commands_list.h"
#include "../../utils/meb.h"
#include "../../utils/communication_configs.h"
#include "../../rtos/tasks_configurations.h"

//! [constants definition]
#define FTDI_RX_BUFFER_IRQ               4
#define FTDI_MODULE_BASE_ADDR            FTDI_USB3_0_BASE
#define FTDI_BUFFER_SIZE_TRANSFER	     8192
//! [constants definition]

//! [public module structs definition]
/* FTDI IRQ Control Register Struct */
typedef struct FtdiFtdiIrqControl {
	bool bFtdiGlobalIrqEn; /* FTDI Global IRQ Enable */
} TFtdiFtdiIrqControl;

/* FTDI Rx IRQ Control Register Struct */
typedef struct FtdiRxIrqControl {
	bool bRxBuff0RdableIrqEn; /* Rx Buffer 0 Readable IRQ Enable */
	bool bRxBuff1RdableIrqEn; /* Rx Buffer 1 Readable IRQ Enable */
	bool bRxBuffLastRdableIrqEn; /* Rx Last Buffer Readable IRQ Enable */
	bool bRxBuffLastEmptyIrqEn; /* Rx Last Buffer Empty IRQ Enable */
	bool bRxCommErrIrqEn; /* Rx Communication Error IRQ Enable */
} TFtdiRxIrqControl;

/* FTDI Rx IRQ Flag Register Struct */
typedef struct FtdiRxIrqFlag {
	bool bRxBuff0RdableIrqFlag; /* Rx Buffer 0 Readable IRQ Flag */
	bool bRxBuff1RdableIrqFlag; /* Rx Buffer 1 Readable IRQ Flag */
	bool bRxBuffLastRdableIrqFlag; /* Rx Last Buffer Readable IRQ Flag */
	bool bRxBuffLastEmptyIrqFlag; /* Rx Last Buffer Empty IRQ Flag */
	bool bRxCommErrIrqFlag; /* Rx Communication Error IRQ Flag */
} TFtdiRxIrqFlag;

/* FTDI Rx IRQ Flag Clear Register Struct */
typedef struct FtdiRxIrqFlagClr {
	bool bRxBuff0RdableIrqFlagClr; /* Rx Buffer 0 Readable IRQ Flag Clear */
	bool bRxBuff1RdableIrqFlagClr; /* Rx Buffer 1 Readable IRQ Flag Clear */
	bool bRxBuffLastRdableIrqFlagClr; /* Rx Last Buffer Readable IRQ Flag Clear */
	bool bRxBuffLastEmptyIrqFlagClr; /* Rx Last Buffer Empty IRQ Flag Clear */
	bool bRxCommErrIrqFlagClr; /* Rx Communication Error IRQ Flag Clear */
} TFtdiRxIrqFlagClr;

/* FTDI Module Control Register Struct */
typedef struct FtdiFtdiModuleControl {
	bool bModuleStart; /* Stop Module Operation */
	bool bModuleStop; /* Start Module Operation */
	bool bModuleClear; /* Clear Module Memories */
	bool bModuleLoopbackEn; /* Enable Module USB Loopback */
} TFtdiFtdiModuleControl;

/* FTDI Half-CCD Request Control Register Struct */
typedef struct FtdiHalfCcdReqControl {
	alt_u16 usiHalfCcdReqTimeout; /* Half-CCD Request Timeout */
	alt_u8 ucHalfCcdFeeNumber; /* Half-CCD FEE Number */
	alt_u8 ucHalfCcdCcdNumber; /* Half-CCD CCD Number */
	alt_u8 ucHalfCcdCcdSide; /* Half-CCD CCD Side */
	alt_u16 usiHalfCcdCcdHeight; /* Half-CCD CCD Height */
	alt_u16 usiHalfCcdCcdWidth; /* Half-CCD CCD Width */
	alt_u16 usiHalfCcdExpNumber; /* Half-CCD Exposure Number */
	bool bRequestHalfCcd; /* Request Half-CCD */
	bool bAbortHalfCcdReq; /* Abort Half-CCD Request */
	bool bRstHalfCcdController; /* Reset Half-CCD Controller */
} TFtdiHalfCcdReqControl;

/* FTDI Half-CCD Reply Status Register Struct */
typedef struct FtdiHalfCcdReplyStatus {
	alt_u8 ucHalfCcdFeeNumber; /* Half-CCD FEE Number */
	alt_u8 ucHalfCcdCcdNumber; /* Half-CCD CCD Number */
	alt_u8 ucHalfCcdCcdSide; /* Half-CCD CCD Side */
	alt_u16 usiHalfCcdCcdHeight; /* Half-CCD CCD Height */
	alt_u16 usiHalfCcdCcdWidth; /* Half-CCD CCD Width */
	alt_u16 usiHalfCcdExpNumber; /* Half-CCD Exposure Number */
	alt_u32 uliHalfCcdImgLengthBytes; /* Half-CCD Image Length [Bytes] */
	bool bHalfCcdReceived; /* Half-CCD Received */
	bool bHalfCcdControllerBusy; /* Half-CCD Controller Busy */
	bool bHalfCcdLastRxBuff; /* Half-CCD Last Rx Buffer */
} TFtdiHalfCcdReplyStatus;

/* FTDI Rx Buffer Status Register Struct */
typedef struct FtdiRxBufferStatus {
	bool bRxBuff0Rdable; /* Rx Buffer 0 Readable */
	bool bRxBuff0Empty; /* Rx Buffer 0 Empty */
	alt_u16 usiRxBuff0UsedBytes; /* Rx Buffer 0 Used [Bytes] */
	bool bRxBuff0Full; /* Rx Buffer 0 Full */
	bool bRxBuff1Rdable; /* Rx Buffer 1 Readable */
	bool bRxBuff1Empty; /* Rx Buffer 1 Empty */
	alt_u16 usiRxBuff1UsedBytes; /* Rx Buffer 1 Used [Bytes] */
	bool bRxBuff1Full; /* Rx Buffer 1 Full */
	bool bRxDbuffRdable; /* Rx Double Buffer Readable */
	bool bRxDbuffEmpty; /* Rx Double Buffer Empty */
	alt_u16 usiRxDbuffUsedBytes; /* Rx Double Buffer Used [Bytes] */
	bool bRxDbuffFull; /* Rx Double Buffer Full */
} TFtdiRxBufferStatus;

/* FTDI Tx Buffer Status Register Struct */
typedef struct FtdiTxBufferStatus {
	bool bTxBuff0Wrable; /* Tx Buffer 0 Writeable */
	bool bTxBuff0Empty; /* Tx Buffer 0 Empty */
	alt_u16 usiTxBuff0SpaceBytes; /* Tx Buffer 0 Space [Bytes] */
	bool bTxBuff0Full; /* Tx Buffer 0 Full */
	bool bTxBuff1Wrable; /* Tx Buffer 1 Writeable */
	bool bTxBuff1Empty; /* Tx Buffer 1 Empty */
	alt_u16 usiTxBuff1SpaceBytes; /* Tx Buffer 1 Space [Bytes] */
	bool bTxBuff1Full; /* Tx Buffer 1 Full */
	bool bTxDbuffWrable; /* Tx Double Buffer Writeable */
	bool bTxDbuffEmpty; /* Tx Double Buffer Empty */
	alt_u16 usiTxDbuffSpaceBytes; /* Tx Double Buffer Space [Bytes] */
	bool bTxDbuffFull; /* Tx Double Buffer Full */
} TFtdiTxBufferStatus;

/* FTDI Rx Communication Error Register Struct */
typedef struct FtdiRxCommError {
	bool bRxCommErrState; /* Rx Communication Error State */
	alt_u16 usiRxCommErrCode; /* Rx Communication Error Code */
	bool bHalfCcdReqNackErr; /* Half-CCD Request Nack Error */
	bool bHalfCcdReplyHeadCrcErr; /* Half-CCD Reply Wrong Header CRC Error */
	bool bHalfCcdReplyHeadEohErr; /* Half-CCD Reply End of Header Error */
	bool bHalfCcdReplyPayCrcErr; /* Half-CCD Reply Wrong Payload CRC Error */
	bool bHalfCcdReplyPayEopErr; /* Half-CCD Reply End of Payload Error */
	bool bHalfCcdReqMaxTriesErr; /* Half-CCD Request Maximum Tries Error */
	bool bHalfCcdReplyCcdSizeErr; /* Half-CCD Request CCD Size Error */
	bool bHalfCcdReqTimeoutErr; /* Half-CCD Request Timeout Error */
} TFtdiRxCommError;

/* FTDI Reserved Register Struct */
typedef struct FtdiReserved {
	bool bTxBuff0EmptyIrq; /* Tx Buffer 0 Empty Irq */
	bool bTxBuff1EmptyIrq; /* Tx Buffer 1 Empty Irq */
	bool bLutTransmittedIrq; /* LUT Transmitted Irq */
	bool bTxCommProtocolErrIrq; /* Tx Communication Protocol Error Irq */
	alt_u32 uliLutLengthBytes; /* LUT Length Bytes */
	bool bTransmitLut; /* Transmit LUT */
	bool bLutLastBuffer; /* LUT Last Buffer */
	bool bLutTransmitted; /* LUT Transmitted */
	bool bTxBusy; /* Tx Busy */
	bool bTxBuffEmpty; /* Tx Buffer Empty */
} TFtdiReserved;

/* General Struct for Registers Access */
typedef struct FtdiModule {
	TFtdiFtdiIrqControl xFtdiFtdiIrqControl;
	TFtdiRxIrqControl xFtdiRxIrqControl;
	TFtdiRxIrqFlag xFtdiRxIrqFlag;
	TFtdiRxIrqFlagClr xFtdiRxIrqFlagClr;
	TFtdiFtdiModuleControl xFtdiFtdiModuleControl;
	TFtdiHalfCcdReqControl xFtdiHalfCcdReqControl;
	TFtdiHalfCcdReplyStatus xFtdiHalfCcdReplyStatus;
	TFtdiRxBufferStatus xFtdiRxBufferStatus;
	TFtdiTxBufferStatus xFtdiTxBufferStatus;
	TFtdiRxCommError xFtdiRxCommError;
	TFtdiReserved xFtdiReserved;
} TFtdiModule;
//! [public module structs definition]

//! [public function prototypes]
void vFTDIStop(void);
void vFTDIStart(void);
void vFTDIClear(void);
void vFTDIAbort(void);
alt_u8 ucFTDIGetError(void);
alt_u32 uliFTDInDataLeftInBuffer(void);
bool bFTDIRequestFullImage(alt_u8 ucFee, alt_u8 ucCCD, alt_u8 ucSide, alt_u16 usiEP, alt_u16 usiHalfWidth, alt_u16 usiHeight);
void vFTDIResetFullImage(void);
void vFTDIRxBufferIRQHandler(void* pvContext);
bool bFTDIIrqRxBuffInit(void);
void vFTDIIrqGlobalEn(bool bEnable);
void vFTDIIrqRxBuff0RdableEn(bool bEnable);
void vFTDIIrqRxBuff1RdableEn(bool bEnable);
void vFTDIIrqRxBuffLastRdableEn(bool bEnable);
void vFTDIIrqRxBuffLastEmptyEn(bool bEnable);
void vFTDIIrqRxCommErrEn(bool bEnable);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DRIVER_FTDI_FTDI_H_ */
