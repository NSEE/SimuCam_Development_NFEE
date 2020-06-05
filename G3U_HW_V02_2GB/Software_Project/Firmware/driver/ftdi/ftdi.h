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
#define FTDI_RX_BUFFER_IRQ               2
#define FTDI_TX_BUFFER_IRQ               3
#define FTDI_MODULE_BASE_ADDR            FTDI_USB3_0_BASE
#define FTDI_BUFFER_SIZE_TRANSFER        67108864
#define FTDI_WORD_SIZE_BYTES             32
#define FTDI_WIN_AREA_WINDOING_SIZE      512
#define FTDI_WIN_AREA_PAYLOAD_SIZE       8388608

#define FTDI_MAX_HCCD_IMG_WIDTH          2295
#define FTDI_MAX_HCCD_IMG_HEIGHT         4560
//! [constants definition]

//! [public module structs definition]

 /* FTDI Module Control Register Struct */
typedef struct FtdiFtdiModuleControl {
  bool bModuleStart; /* Stop Module Operation */
  bool bModuleStop; /* Start Module Operation */
  bool bModuleClear; /* Clear Module Memories */
  bool bModuleLoopbackEn; /* Enable Module USB Loopback */
} TFtdiFtdiModuleControl;

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

 /* FTDI Tx IRQ Control Register Struct */
typedef struct FtdiTxIrqControl {
  bool bTxLutFinishedIrqEn; /* Tx LUT Finished Transmission IRQ Enable */
  bool bTxLutCommErrIrqEn; /* Tx LUT Communication Error IRQ Enable */
} TFtdiTxIrqControl;

 /* FTDI Tx IRQ Flag Register Struct */
typedef struct FtdiTxIrqFlag {
  bool bTxLutFinishedIrqFlag; /* Tx LUT Finished Transmission IRQ Flag */
  bool bTxLutCommErrIrqFlag; /* Tx LUT Communication Error IRQ Flag */
} TFtdiTxIrqFlag;

 /* FTDI Tx IRQ Flag Clear Register Struct */
typedef struct FtdiTxIrqFlagClr {
  bool bTxLutFinishedIrqFlagClr; /* Tx LUT Finished Transmission IRQ Flag Clear */
  bool bTxLutCommErrIrqFlagClr; /* Tx LUT Communication Error IRQ Flag Clear */
} TFtdiTxIrqFlagClr;

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

 /* FTDI LUT Transmission Control Register Struct */
typedef struct FtdiLutTransControl {
  alt_u8 ucLutFeeNumber; /* LUT FEE Number */
  alt_u8 ucLutCcdNumber; /* LUT CCD Number */
  alt_u8 ucLutCcdSide; /* LUT CCD Side */
  alt_u16 usiLutCcdHeight; /* LUT CCD Height */
  alt_u16 usiLutCcdWidth; /* LUT CCD Width */
  alt_u16 usiLutExpNumber; /* LUT Exposure Number */
  alt_u32 uliLutLengthBytes; /* LUT Length [Bytes] */
  alt_u16 usiLutTransTimeout; /* LUT Request Timeout */
  bool bTransmitLut; /* Transmit LUT */
  bool bAbortLutTrans; /* Abort LUT Transmission */
  bool bRstLutController; /* Reset LUT Controller */
} TFtdiLutTransControl;

 /* FTDI LUT Transmission Status Register Struct */
typedef struct FtdiLutTransStatus {
  bool bLutTransmitted; /* LUT Transmitted */
  bool bLutControllerBusy; /* LUT Controller Busy */
} TFtdiLutTransStatus;

 /* FTDI LUT CCD1 Windowing Configuration Struct */
typedef struct FtdiLutCcd1WindCfg {
  alt_u32 uliCcd1WindowListPrt; /* CCD1 Window List Pointer */
  alt_u32 uliCcd1PacketOrderListPrt; /* CCD1 Packet Order List Pointer */
  alt_u32 uliCcd1WindowListLength; /* CCD1 Window List Length */
  alt_u32 uliCcd1WindowsSizeX; /* CCD1 Windows Size X */
  alt_u32 uliCcd1WindowsSizeY; /* CCD1 Windows Size Y */
  alt_u32 uliCcd1LastEPacket; /* CCD1 Last E Packet */
  alt_u32 uliCcd1LastFPacket; /* CCD1 Last F Packet */
} TFtdiLutCcd1WindCfg;

 /* FTDI LUT CCD2 Windowing Configuration Struct */
typedef struct FtdiLutCcd2WindCfg {
  alt_u32 uliCcd2WindowListPrt; /* CCD2 Window List Pointer */
  alt_u32 uliCcd2PacketOrderListPrt; /* CCD2 Packet Order List Pointer */
  alt_u32 uliCcd2WindowListLength; /* CCD2 Window List Length */
  alt_u32 uliCcd2WindowsSizeX; /* CCD2 Windows Size X */
  alt_u32 uliCcd2WindowsSizeY; /* CCD2 Windows Size Y */
  alt_u32 uliCcd2LastEPacket; /* CCD2 Last E Packet */
  alt_u32 uliCcd2LastFPacket; /* CCD2 Last F Packet */
} TFtdiLutCcd2WindCfg;

 /* FTDI LUT CCD3 Windowing Configuration Struct */
typedef struct FtdiLutCcd3WindCfg {
  alt_u32 uliCcd3WindowListPrt; /* CCD3 Window List Pointer */
  alt_u32 uliCcd3PacketOrderListPrt; /* CCD3 Packet Order List Pointer */
  alt_u32 uliCcd3WindowListLength; /* CCD3 Window List Length */
  alt_u32 uliCcd3WindowsSizeX; /* CCD3 Windows Size X */
  alt_u32 uliCcd3WindowsSizeY; /* CCD3 Windows Size Y */
  alt_u32 uliCcd3LastEPacket; /* CCD3 Last E Packet */
  alt_u32 uliCcd3LastFPacket; /* CCD3 Last F Packet */
} TFtdiLutCcd3WindCfg;

 /* FTDI LUT CCD4 Windowing Configuration Struct */
typedef struct FtdiLutCcd4WindCfg {
  alt_u32 uliCcd4WindowListPrt; /* CCD4 Window List Pointer */
  alt_u32 uliCcd4PacketOrderListPrt; /* CCD4 Packet Order List Pointer */
  alt_u32 uliCcd4WindowListLength; /* CCD4 Window List Length */
  alt_u32 uliCcd4WindowsSizeX; /* CCD4 Windows Size X */
  alt_u32 uliCcd4WindowsSizeY; /* CCD4 Windows Size Y */
  alt_u32 uliCcd4LastEPacket; /* CCD4 Last E Packet */
  alt_u32 uliCcd4LastFPacket; /* CCD4 Last F Packet */
} TFtdiLutCcd4WindCfg;

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

 /* FTDI Tx LUT Communication Error Register Struct */
typedef struct FtdiTxCommError {
  bool bTxLutCommErrState; /* Tx LUT Communication Error State */
  alt_u16 usiTxLutCommErrCode; /* Tx LUT Communication Error Code */
  bool bLutTransmitNackErr; /* LUT Transmit NACK Error */
  bool bLutReplyHeadCrcErr; /* LUT Reply Wrong Header CRC Error */
  bool bLutReplyHeadEohErr; /* LUT Reply End of Header Error */
  bool bLutTransMaxTriesErr; /* LUT Transmission Maximum Tries Error */
  bool bLutPayloadNackErr; /* LUT Payload NACK Error */
  bool bLutTransTimeoutErr; /* LUT Transmission Timeout Error */
} TFtdiTxCommError;

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

 /* General Struct for Registers Access */
typedef struct FtdiModule {
  TFtdiFtdiModuleControl xFtdiFtdiModuleControl;
  TFtdiFtdiIrqControl xFtdiFtdiIrqControl;
  TFtdiRxIrqControl xFtdiRxIrqControl;
  TFtdiRxIrqFlag xFtdiRxIrqFlag;
  TFtdiRxIrqFlagClr xFtdiRxIrqFlagClr;
  TFtdiTxIrqControl xFtdiTxIrqControl;
  TFtdiTxIrqFlag xFtdiTxIrqFlag;
  TFtdiTxIrqFlagClr xFtdiTxIrqFlagClr;
  TFtdiHalfCcdReqControl xFtdiHalfCcdReqControl;
  TFtdiHalfCcdReplyStatus xFtdiHalfCcdReplyStatus;
  TFtdiLutTransControl xFtdiLutTransControl;
  TFtdiLutTransStatus xFtdiLutTransStatus;
  TFtdiLutCcd1WindCfg xFtdiLutCcd1WindCfg;
  TFtdiLutCcd2WindCfg xFtdiLutCcd2WindCfg;
  TFtdiLutCcd3WindCfg xFtdiLutCcd3WindCfg;
  TFtdiLutCcd4WindCfg xFtdiLutCcd4WindCfg;
  TFtdiRxCommError xFtdiRxCommError;
  TFtdiTxCommError xFtdiTxCommError;
  TFtdiRxBufferStatus xFtdiRxBufferStatus;
  TFtdiTxBufferStatus xFtdiTxBufferStatus;
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
bool bFTDITransmitWindowArea(alt_u8 ucFee, alt_u16 usiHalfWidth, alt_u16 usiHeight, alt_u32 uliLutLengthBytes);
void vFTDIResetFullImage(void);
void vFTDIResetWindowArea(void);
void vFTDIRxBufferIRQHandler(void* pvContext);
void vFTDITxBufferIRQHandler(void* pvContext);
bool bFTDIIrqRxBuffInit(void);
bool bFTDIIrqTxBuffInit(void);
void vFTDIIrqGlobalEn(bool bEnable);
void vFTDIIrqRxBuff0RdableEn(bool bEnable);
void vFTDIIrqRxBuff1RdableEn(bool bEnable);
void vFTDIIrqRxBuffLastRdableEn(bool bEnable);
void vFTDIIrqRxBuffLastEmptyEn(bool bEnable);
void vFTDIIrqRxCommErrEn(bool bEnable);
void vFTDIIrqTxFinishedEn(bool bEnable);
void vFTDIIrqTxCommErrEn(bool bEnable);

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
