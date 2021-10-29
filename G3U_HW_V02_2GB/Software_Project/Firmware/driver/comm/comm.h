/*
 * comm.h
 *
 *  Created on: 18/12/2018
 *      Author: rfranca
 */

#ifndef COMM_H_
#define COMM_H_

#include "../../simucam_definitions.h"
#include "rmap/rmap_mem_area.h"

//! [constants definition]
// irq numbers
#define COMM_CH_1_RMAP_IRQ              15
#define COMM_CH_1_BUFFERS_IRQ           5
#define COMM_CH_2_RMAP_IRQ              16
#define COMM_CH_2_BUFFERS_IRQ           6
#define COMM_CH_3_RMAP_IRQ              17
#define COMM_CH_3_BUFFERS_IRQ           7
#define COMM_CH_4_RMAP_IRQ              18
#define COMM_CH_4_BUFFERS_IRQ           8
#define COMM_CH_5_RMAP_IRQ              19
#define COMM_CH_5_BUFFERS_IRQ           9
#define COMM_CH_6_RMAP_IRQ              20
#define COMM_CH_6_BUFFERS_IRQ           10

// address
#define COMM_CH_1_BASE_ADDR             COMMUNICATION_MODULE_V2_CH1_BASE
#define COMM_CH_2_BASE_ADDR             COMMUNICATION_MODULE_V2_CH2_BASE
#define COMM_CH_3_BASE_ADDR             COMMUNICATION_MODULE_V2_CH3_BASE
#define COMM_CH_4_BASE_ADDR             COMMUNICATION_MODULE_V2_CH4_BASE
#define COMM_CH_5_BASE_ADDR             COMMUNICATION_MODULE_V2_CH5_BASE
#define COMM_CH_6_BASE_ADDR             COMMUNICATION_MODULE_V2_CH6_BASE
#define COMM_RMAP_MEM_1_BASE_ADDR       RMAP_MEM_NFEE_COMM_1_BASE
#define COMM_RMAP_MEM_2_BASE_ADDR       RMAP_MEM_NFEE_COMM_2_BASE
#define COMM_RMAP_MEM_3_BASE_ADDR       RMAP_MEM_NFEE_COMM_3_BASE
#define COMM_RMAP_MEM_4_BASE_ADDR       RMAP_MEM_NFEE_COMM_4_BASE
#define COMM_RMAP_MEM_5_BASE_ADDR       RMAP_MEM_NFEE_COMM_5_BASE
#define COMM_RMAP_MEM_6_BASE_ADDR       RMAP_MEM_NFEE_COMM_6_BASE

#define COMM_FFEE_QUANTITY              6
// offsets
//! [constants definition]

//! [public module structs definition]
enum CommBufferSide {
	eCommLeftBuffer = 0, eCommRightBuffer = 1
} ECommBufferSide;

enum CommSpwCh {
	eCommSpwCh1 = 0, eCommSpwCh2, eCommSpwCh3, eCommSpwCh4, eCommSpwCh5, eCommSpwCh6,
} ECommSpwCh;

enum CommFFeeId {
	eCommFFee1Id = 0, eCommFFee2Id, eCommFFee3Id, eCommFFee4Id, eCommFFee5Id, eCommFFee6Id
} ECommFFeeId;

/* Comm Device Address Register Struct */
typedef struct CommDevAddr {
	alt_u32 uliDevBaseAddr; /* Comm Device Base Address */
} TCommDevAddr;

/* Comm IRQ Control Register Struct */
typedef struct CommIrqControl {
	bool bGlobalIrqEn; /* Comm Global IRQ Enable */
} TCommIrqControl;

/* SpaceWire Device Address Register Struct */
typedef struct SpwcDevAddr {
	alt_u32 uliSpwcBaseAddr; /* SpaceWire Device Base Address */
} TSpwcDevAddr;

/* SpaceWire Link Config Register Struct */
typedef struct SpwcLinkConfig {
	bool bEnable; /* SpaceWire Link Config Enable */
	bool bDisconnect; /* SpaceWire Link Config Disconnect */
	bool bLinkStart; /* SpaceWire Link Config Linkstart */
	bool bAutostart; /* SpaceWire Link Config Autostart */
	alt_u32 ucTxDivCnt; /* SpaceWire Link Config TxDivCnt */
} TSpwcLinkConfig;

/* SpaceWire Link Status Register Struct */
typedef struct SpwcLinkStatus {
	bool bRunning; /* SpaceWire Link Running */
	bool bConnecting; /* SpaceWire Link Connecting */
	bool bStarted; /* SpaceWire Link Started */
} TSpwcLinkStatus;

/* SpaceWire Link Status Register Struct */
typedef struct SpwcLinkError {
	bool bDisconnect; /* SpaceWire Error Disconnect */
	bool bParity; /* SpaceWire Error Parity */
	bool bEscape; /* SpaceWire Error Escape */
	bool bCredit; /* SpaceWire Error Credit */
} TSpwcLinkError;

/* SpaceWire Timecode Config Register Struct */
typedef struct SpwcTimecodeConfig {
	bool bClear; /* SpaceWire Timecode Clear */
	bool bTransmissionEnable; /* SpaceWire Timecode Transmission Enable */
	bool bSyncTriggerEnable; /* SpaceWire Timecode Sync Trigger Enable */
	alt_u32 ucTimeOffset; /* SpaceWire Timecode Time Offset */
	bool bSyncDelayTriggerEn; /* SpaceWire Timecode Sync Delay Trigger Enable */
	alt_u32 uliSyncDelayValue; /* SpaceWire Timecode Sync Delay Value */
} TSpwcTimecodeConfig;

/* SpaceWire Timecode Status Register Struct */
typedef struct SpwcTimecodeStatus {
	alt_u32 ucTime; /* SpaceWire Timecode Time */
	alt_u32 ucControl; /* SpaceWire Timecode Control */
} TSpwcTimecodeStatus;

/* FEE Buffers Device Address Register Struct */
typedef struct FeebDevAddr {
	alt_u32 uliFeebBaseAddr; /* FEE Buffers Device Base Address */
} TFeebDevAddr;

/* FEE Machine Config Register Struct */
typedef struct FeebMachineControl {
	bool bClear; /* FEE Machine Clear */
	bool bStop; /* FEE Machine Stop */
	bool bStart; /* FEE Machine Start */
	bool bBufferOverflowEn; /* FEE Buffer Overflow Enable */
	alt_u32 uliLeftPxStorageSize; /* FEE Left Pixel Storage Size */
	alt_u32 uliRightPxStorageSize; /* FEE Right Pixel Storage Size */
	bool bDigitaliseEn; /* FEE Digitalise Enable */
	bool bReadoutEn; /* FEE Readout Enable */
	bool bWindowListEn; /* FEE Window List Enable */
	bool bStatisticsClear; /* FEE Statistics Clear */
} TFeebMachineControl;

/* FEE Machine Statistics Register Struct */
typedef struct FeebMachineStatistics {
	alt_u32 uliIncomingPktsCnt; /* FEE Incoming Packets Counter */
	alt_u32 uliIncomingBytesCnt; /* FEE Incoming Bytes Counter */
	alt_u32 uliOutgoingPktsCnt; /* FEE Outgoing Packets Counter */
	alt_u32 uliOutgoingBytesCnt; /* FEE Outgoing Bytes Counter */
	alt_u32 uliSpwLinkEscapeErrCnt; /* FEE SpW Link Escape Errors Counter */
	alt_u32 uliSpwLinkCreditErrCnt; /* FEE SpW Link Credit Errors Counter */
	alt_u32 uliSpwLinkParityErrCnt; /* FEE SpW Link Parity Errors Counter */
	alt_u32 uliSpwLinkDisconnectCnt; /* FEE SpW Link Disconnects Counter */
	alt_u32 uliSpwEepCnt; /* FEE SpaceWire EEPs Counter */
} TFeebMachineStatistics;

/* FEE Buffers Config Register Struct */
typedef struct FeebBufferStatus {
	alt_u32 ucRightBufferSize; /* Windowing Right Buffer Size Config */
	alt_u32 ucLeftBufferSize; /* Windowing Left Buffer Size Config */
	bool bRightBufferEmpty; /* Windowing Right Buffer Empty */
	bool bLeftBufferEmpty; /* Windowing Left Buffer Empty */
	bool bRightFeeBusy; /* FEE Right Machine Busy */
	bool bLeftFeeBusy; /* FEE Left Machine Busy */
} TFeebBufferStatus;

/* FEE Buffers Data Control Register Struct */
typedef struct FeebBufferDataControl {
	alt_u32 uliRightRdInitAddrHighDword; /* Right Initial Read Address [High Dword] */
	alt_u32 uliRightRdInitAddrLowDword; /* Right Initial Read Address [Low Dword] */
	alt_u32 uliRightRdDataLenghtBytes; /* Right Read Data Length [Bytes] */
	bool bRightRdStart; /* Right Data Read Start */
	bool bRightRdReset; /* Right Data Read Reset */
	alt_u32 uliLeftRdInitAddrHighDword; /* Left Initial Read Address [High Dword] */
	alt_u32 uliLeftRdInitAddrLowDword; /* Left Initial Read Address [Low Dword] */
	alt_u32 uliLeftRdDataLenghtBytes; /* Left Read Data Length [Bytes] */
	bool bLeftRdStart; /* Left Data Read Start */
	bool bLeftRdReset; /* Left Data Read Reset */
} TFeebBufferDataControl;

/* FEE Buffers Data Status Register Struct */
typedef struct FeebBufferDataStatus {
	bool bRightRdBusy; /* Right Data Read Busy */
	bool bLeftRdBusy; /* Left Data Read Busy */
} TFeebBufferDataStatus;

/* FEE Buffers IRQ Control Register Struct */
typedef struct FeebIrqControl {
	bool bRightBuffCtrlFinishedEn; /* FEE Right Buffer Empty IRQ Enable */
	bool bLeftBuffCtrlFinishedEn; /* FEE Left Buffer Empty IRQ Enable */
} TFeebIrqControl;

/* FEE Buffers IRQ Flags Register Struct */
typedef struct FeebIrqFlag {
	bool bRightBuffCtrlFinishedFlag; /* FEE Right Buffer 0 Empty IRQ Flag */
	bool bLeftBuffCtrlFinishedFlag; /* FEE Left Buffer 0 Empty IRQ Flag */
} TFeebIrqFlag;

/* FEE Buffers IRQ Flags Clear Register Struct */
typedef struct FeebIrqFlagClr {
	bool bRightBuffCtrlFinishedFlagClr; /* FEE Right Buffer 0 Empty IRQ Flag Clear */
	bool bLeftBuffCtrlFinishedFlagClr; /* FEE Left Buffer 0 Empty IRQ Flag Clear */
} TFeebIrqFlagClr;

/* FEE Buffers IRQ Number Register Struct */
typedef struct FeebIrqNumber {
	alt_u32 uliBuffersEmptyIrqId; /* FEE Buffers IRQ Number/ID */
} TFeebIrqNumber;

/* RMAP Device Address Register Struct */
typedef struct RmapDevAddr {
	alt_u32 uliRmapBaseAddr; /* RMAP Device Base Address */
} TRmapDevAddr;

/* RMAP Echoing Mode Config Register Struct */
typedef struct RmapEchoingModeConfig {
	bool bRmapEchoingModeEn; /* RMAP Echoing Mode Enable */
	bool bRmapEchoingIdEn; /* RMAP Echoing ID Enable */
} TRmapEchoingModeConfig;

/* RMAP Codec Config Register Struct */
typedef struct RmapCodecConfig {
	bool bEnable; /* RMAP Target Enable */
	alt_u32 ucLogicalAddress; /* RMAP Target Logical Address */
	alt_u32 ucKey; /* RMAP Target Key */
} TRmapCodecConfig;

/* RMAP Codec Status Register Struct */
typedef struct RmapCodecStatus {
	bool bCommandReceived; /* RMAP Status Command Received */
	bool bWriteRequested; /* RMAP Status Write Requested */
	bool bWriteAuthorized; /* RMAP Status Write Authorized */
	bool bReadRequested; /* RMAP Status Read Requested */
	bool bReadAuthorized; /* RMAP Status Read Authorized */
	bool bReplySended; /* RMAP Status Reply Sended */
	bool bDiscardedPackage; /* RMAP Status Discarded Package */
} TRmapCodecStatus;

/* RMAP Codec Status Register Struct */
typedef struct RmapCodecError {
	bool bEarlyEop; /* RMAP Error Early EOP */
	bool bEep; /* RMAP Error EEP */
	bool bHeaderCRC; /* RMAP Error Header CRC */
	bool bUnusedPacketType; /* RMAP Error Unused Packet Type */
	bool bInvalidCommandCode; /* RMAP Error Invalid Command Code */
	bool bTooMuchData; /* RMAP Error Too Much Data */
	bool bInvalidDataCrc; /* RMAP Error Invalid Data CRC */
} TRmapCodecError;

/* RMAP Memory Status Register Struct */
typedef struct RmapMemStatus {
	alt_u32 uliLastWriteAddress; /* RMAP Last Write Address */
	alt_u32 uliLastWriteLengthBytes; /* RMAP Last Write Length [Bytes] */
	alt_u32 uliLastReadAddress; /* RMAP Last Read Address */
	alt_u32 uliLastReadLengthBytes; /* RMAP Last Read Length [Bytes] */
} TRmapMemStatus;

/* RMAP Memory Config Register Struct */
typedef struct RmapMemConfig {
	alt_u32 uliWinAreaOffHighDword; /* RMAP Windowing Area Offset (High Dword) */
	alt_u32 uliWinAreaOffLowDword; /* RMAP Windowing Area Offset (Low Dword) */
} TRmapMemConfig;

/* RMAP Memory Area Pointer Register Struct */
typedef struct RmapMemAreaPrt {
	TRmapMemArea *puliRmapAreaPrt; /* RMAP Memory Area Pointer */
} TRmapMemAreaPrt;

/* RMAP IRQ Control Register Struct */
typedef struct RmapIrqControl {
	bool bWriteConfigEn; /* RMAP Write Config IRQ Enable */
	bool bWriteWindowEn; /* RMAP Write Window IRQ Enable */
} TRmapIrqControl;

/* RMAP IRQ Flags Register Struct */
typedef struct RmapIrqFlag {
	bool bWriteConfigFlag; /* RMAP Write Config IRQ Flag */
	bool bWriteWindowFlag; /* RMAP Write Config IRQ Flag */
} TRmapIrqFlag;

/* RMAP IRQ Flags Clear Register Struct */
typedef struct RmapIrqFlagClr {
	bool bWriteConfigFlagClr; /* RMAP Write Config IRQ Flag Clear */
	bool bWriteWindowFlagClr; /* RMAP Write Config IRQ Flag Clear */
} TRmapIrqFlagClr;

/* RMAP IRQ Number Register Struct */
typedef struct RmapIrqNumber {
	alt_u32 uliWriteCmdIrqId; /* RMAP IRQ Number/ID */
} TRmapIrqNumber;

/* Data Packet Device Channel Address Register Struct */
typedef struct DpktDevAddr {
	alt_u32 uliDpktBaseAddr; /* Data Packet Device Base Address */
} TDpktDevAddr;

/* Data Packet Config Register Struct */
typedef struct DpktDataPacketConfig {
	alt_u32 usiCcdXSize; /* Data Packet CCD X Size */
	alt_u32 usiCcdYSize; /* Data Packet CCD Y Size */
	alt_u32 usiDataYSize; /* Data Packet Data Y Size */
	alt_u32 usiOverscanYSize; /* Data Packet Overscan Y Size */
	alt_u32 usiCcdVStart; /* Data Packet CCD V-Start */
	alt_u32 usiCcdVEnd; /* Data Packet CCD V-End */
	alt_u32 usiCcdImgVEnd; /* Data Packet CCD Image V-End */
	alt_u32 usiCcdOvsVEnd; /* Data Packet CCD Overscan V-End */
	alt_u32 usiCcdHStart; /* Data Packet CCD H-Start */
	alt_u32 usiCcdHEnd; /* Data Packet CCD H-End */
	bool bCcdImgEn; /* Data Packet CCD Image Enable */
	bool bCcdOvsEn; /* Data Packet CCD Overscan Enable */
	alt_u32 usiPacketLength; /* Data Packet Packet Length */
	alt_u32 ucLogicalAddr; /* Data Packet Logical Address */
	alt_u32 ucProtocolId; /* Data Packet Protocol ID */
	alt_u32 ucFeeMode; /* Data Packet FEE Mode */
	alt_u32 ucCcdNumber; /* Data Packet CCD Number */
} TDpktDataPacketConfig;

/* Data Packet Errors Register Struct */
typedef struct DpktDataPacketErrors {
	bool bInvalidCcdMode; /* Data Packet Invalid CCD Mode Error */
} TDpktDataPacketErrors;

/* Data Packet Header Register Struct */
typedef struct DpktDataPacketHeader {
	alt_u32 usiLength; /* Data Packet Header Length */
	alt_u32 usiType; /* Data Packet Header Type */
	alt_u32 usiFrameCounter; /* Data Packet Header Frame Counter */
	alt_u32 usiSequenceCounter; /* Data Packet Header Sequence Counter */
} TDpktDataPacketHeader;

/* Data Packet Pixel Delay Register Struct */
typedef struct DpktPixelDelay {
	alt_u32 uliStartDelay; /* Data Packet Start Delay */
	alt_u32 uliSkipDelay; /* Data Packet Skip Delay */
	alt_u32 uliLineDelay; /* Data Packet Line Delay */
	alt_u32 uliAdcDelay; /* Data Packet ADC Delay */
} TDpktPixelDelay;

/* SpaceWire Error Injection Control Register Struct */
typedef struct DpktSpacewireErrInj {
	bool bEepReceivedEn; /* Enable for "EEP Received" SpaceWire Error */
	alt_u32 usiSequenceCnt; /* Sequence Counter of SpaceWire Error */
	alt_u32 usiNRepeat; /* Number of Times the SpaceWire Error Repeats */
} TDpktSpacewireErrInj;

/* SpaceWire Codec Error Injection Control Register Struct */
typedef struct DpktSpwCodecErrInj {
	bool bStartErrInj; /* Start SpaceWire Codec Error Injection */
	bool bResetErrInj; /* Reset SpaceWire Codec Error Injection */
	alt_u32 ucErrInjErrCode; /* SpaceWire Codec Error Injection Error Code */
	bool bErrInjBusy; /* SpaceWire Codec Error Injection is Busy */
	bool bErrInjReady; /* SpaceWire Codec Error Injection is Ready */
} TDpktSpwCodecErrInj;

/* RMAP Error Injection Control Register Struct */
typedef struct DpktRmapErrInj {
	bool bResetErr; /* Reset RMAP Error */
	bool bTriggerErr; /* Trigger RMAP Error */
	alt_u32 ucErrorId; /* Error ID of RMAP Error */
	alt_u32 uliValue; /* Value of RMAP Error */
	alt_u32 usiRepeats; /* Repetitions of RMAP Error */
} TDpktRmapErrInj;

/* Transmission Error Injection Control Register Struct */
typedef struct DpktTransmissionErrInj {
	bool bTxDisabledEn; /* Enable for "Tx Disabled" Transmission Error */
	bool bMissingPktsEn; /* Enable for "Missing Packets" Transmission Error */
	bool bMissingDataEn; /* Enable for "Missing Data" Transmission Error */
	alt_u32 ucFrameNum; /* Frame Number of Transmission Error */
	alt_u32 usiSequenceCnt; /* Sequence Counter of Transmission Error */
	alt_u32 usiDataCnt; /* Data Counter of Transmission Error */
	alt_u32 usiNRepeat; /* Number of Times the Transmission Error Repeats */
} TDpktTransmissionErrInj;

/* Left Content Error Injection Control Register Struct */
typedef struct DpktLeftContentErrInj {
	bool bOpenList; /* Open the Left Content Error List */
	bool bCloseList; /* Close the Left Content Error List */
	bool bClearList; /* Clear Left Content Error List */
	bool bWriteList; /* Write to Left Content Error List */
	bool bStartInj; /* Start Injection of Left Content Errors */
	bool bStopInj; /* Stop Injection of Left Content Errors */
	alt_u32 usiStartFrame; /* Start Frame of Left Content Error */
	alt_u32 usiStopFrame; /* Stop Frame of Left Content Error */
	alt_u32 usiPxColX; /* Pixel Column (x-position) of Left Content Error */
	alt_u32 usiPxRowY; /* Pixel Row (y-position) of Left Content Error */
	alt_u32 usiPxValue; /* Pixel Value of Left Content Error */
	bool bIdle; /* Left Content Error Manager in Idle */
	bool bRecording; /* Left Content Error Manager in Recording */
	bool bInjecting; /* Left Content Error Manager in Injecting */
	alt_u32 ucErrorsCnt; /* Amount of entries in Left Content Error List */
} TDpktLeftContentErrInj;

/* Right Content Error Injection Control Register Struct */
typedef struct DpktRightContentErrInj {
	bool bOpenList; /* Open the Right Content Error List */
	bool bCloseList; /* Close the Right Content Error List */
	bool bClearList; /* Clear Right Content Error List */
	bool bWriteList; /* Write to Right Content Error List */
	bool bStartInj; /* Start Injection of Right Content Errors */
	bool bStopInj; /* Stop Injection of Right Content Errors */
	alt_u32 usiStartFrame; /* Start Frame of Right Content Error */
	alt_u32 usiStopFrame; /* Stop Frame of Right Content Error */
	alt_u32 usiPxColX; /* Pixel Column (x-position) of Right Content Error */
	alt_u32 usiPxRowY; /* Pixel Row (y-position) of Right Content Error */
	alt_u32 usiPxValue; /* Pixel Value of Right Content Error */
	bool bIdle; /* Right Content Error Manager in Idle */
	bool bRecording; /* Right Content Error Manager in Recording */
	bool bInjecting; /* Right Content Error Manager in Injecting */
	alt_u32 ucErrorsCnt; /* Amount of entries in Right Content Error List */
} TDpktRightContentErrInj;

/* Header Error Injection Control Register Struct */
typedef struct DpktHeaderErrInj {
	bool bOpenList; /* Open the Header Error List */
	bool bCloseList; /* Close the Header Error List */
	bool bClearList; /* Clear Header Error List */
	bool bWriteList; /* Write to Header Error List */
	bool bStartInj; /* Start Injection of Header Errors */
	bool bStopInj; /* Stop Injection of Header Errors */
	alt_u32 ucFrameNum; /* Frame Number of Header Error */
	alt_u32 usiSequenceCnt; /* Sequence Counter of Header Error */
	alt_u32 ucFieldId; /* Field ID of Header Error */
	alt_u32 usiValue; /* Value of Header Error */
	bool bIdle; /* Header Error Manager in Idle */
	bool bRecording; /* Header Error Manager in Recording */
	bool bInjecting; /* Header Error Manager in Injecting */
	alt_u32 ucErrorsCnt; /* Amount of entries in Header Error List */
} TDpktHeaderErrInj;

/* Windowing Parameters Register Struct */
typedef struct DpktWindowingParam {
	alt_u32 uliPacketOrderList15; /* Windowing Packet Order List Dword 15 */
	alt_u32 uliPacketOrderList14; /* Windowing Packet Order List Dword 14 */
	alt_u32 uliPacketOrderList13; /* Windowing Packet Order List Dword 13 */
	alt_u32 uliPacketOrderList12; /* Windowing Packet Order List Dword 12 */
	alt_u32 uliPacketOrderList11; /* Windowing Packet Order List Dword 11 */
	alt_u32 uliPacketOrderList10; /* Windowing Packet Order List Dword 10 */
	alt_u32 uliPacketOrderList9; /* Windowing Packet Order List Dword 9 */
	alt_u32 uliPacketOrderList8; /* Windowing Packet Order List Dword 8 */
	alt_u32 uliPacketOrderList7; /* Windowing Packet Order List Dword 7 */
	alt_u32 uliPacketOrderList6; /* Windowing Packet Order List Dword 6 */
	alt_u32 uliPacketOrderList5; /* Windowing Packet Order List Dword 5 */
	alt_u32 uliPacketOrderList4; /* Windowing Packet Order List Dword 4 */
	alt_u32 uliPacketOrderList3; /* Windowing Packet Order List Dword 3 */
	alt_u32 uliPacketOrderList2; /* Windowing Packet Order List Dword 2 */
	alt_u32 uliPacketOrderList1; /* Windowing Packet Order List Dword 1 */
	alt_u32 uliPacketOrderList0; /* Windowing Packet Order List Dword 0 */
	alt_u32 uliLastEPacket; /* Windowing Last E Packet */
	alt_u32 uliLastFPacket; /* Windowing Last F Packet */
	alt_u32 uliXCoordinateError; /* Windowing X-Coordinate Error */
	alt_u32 uliYCoordinateError; /* Windowing Y-Coordinate Error */
} TDpktWindowingParam;

/* General Struct for SpW Channel Registers Access */
typedef struct SpwcChannel {
	TSpwcDevAddr xSpwcDevAddr;
	TSpwcLinkConfig xSpwcLinkConfig;
	TSpwcLinkStatus xSpwcLinkStatus;
	TSpwcLinkError xSpwcLinkError;
	TSpwcTimecodeConfig xSpwcTimecodeConfig;
	TSpwcTimecodeStatus xSpwcTimecodeStatus;
} TSpwcChannel;

/* General Struct for FEE Buffers Registers Access */
typedef struct FeebChannel {
	TFeebDevAddr xFeebDevAddr;
	TFeebMachineControl xFeebMachineControl;
	TFeebMachineStatistics xFeebMachineStatistics;
	TFeebBufferStatus xFeebBufferStatus;
	TFeebBufferDataControl xFeebBufferDataControl;
	TFeebBufferDataStatus xFeebBufferDataStatus;
	TFeebIrqControl xFeebIrqControl;
	TFeebIrqFlag xFeebIrqFlag;
	TFeebIrqFlagClr xFeebIrqFlagClr;
	TFeebIrqNumber xFeebIrqNumber;
} TFeebChannel;

/* General Struct for RMAP Registers Access */
typedef struct RmapChannel {
	TRmapDevAddr xRmapDevAddr;
	TRmapEchoingModeConfig xRmapEchoingModeConfig;
	TRmapCodecConfig xRmapCodecConfig;
	TRmapCodecStatus xRmapCodecStatus;
	TRmapCodecError xRmapCodecError;
	TRmapMemStatus xRmapMemStatus;
	TRmapMemConfig xRmapMemConfig;
	TRmapMemAreaPrt xRmapMemAreaPrt;
	TRmapIrqControl xRmapIrqControl;
	TRmapIrqFlag xRmapIrqFlag;
	TRmapIrqFlagClr xRmapIrqFlagClr;
	TRmapIrqNumber xRmapIrqNumber;
} TRmapChannel;

/* General Struct for Data Packet Registers Access */
typedef struct DpktChannel {
	TDpktDevAddr xDpktDevAddr;
	TDpktDataPacketConfig xDpktDataPacketConfig;
	TDpktDataPacketErrors xDpktDataPacketErrors;
	TDpktDataPacketHeader xDpktDataPacketHeader;
	TDpktPixelDelay xDpktPixelDelay;
	TDpktSpacewireErrInj xDpktSpacewireErrInj;
	TDpktSpwCodecErrInj xDpktSpwCodecErrInj;
	TDpktRmapErrInj xDpktRmapErrInj;
	TDpktTransmissionErrInj xDpktTransmissionErrInj;
	TDpktLeftContentErrInj xDpktLeftContentErrInj;
	TDpktRightContentErrInj xDpktRightContentErrInj;
	TDpktHeaderErrInj xDpktHeaderErrInj;
	TDpktWindowingParam xDpktWindowingParam;
} TDpktChannel;

/* General Struct for Communication Module Registers Access */
typedef struct CommChannel {
	TCommDevAddr xCommDevAddr;
	TCommIrqControl xCommIrqControl;
	TSpwcChannel xSpacewire;
	TFeebChannel xFeeBuffer;
	TRmapChannel xRmap;
	TDpktChannel xDataPacket;
} TCommChannel;

//! [public module structs definition]

//! [public function prototypes]
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* COMM_H_ */
