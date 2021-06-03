/*
 * scom.h
 *
 *  Created on: 28/07/2020
 *      Author: rfranca
 */

#ifndef SCOM_H_
#define SCOM_H_

#include "../../simucam_definitions.h"
#include "../../utils/configs_simucam.h"
#include "../comm/rmap/rmap_mem_area.h"
#include "../comm/rmap/rmap.h"

//! [constants definition]

#define SCOM_BASE_ADDR                  SYNCHRONIZATION_COMM_0_BASE
#define SCOM_RMAP_MEM_BASE_ADDR         RMAP_MEM_NFEE_SCOM_0_BASE

//! [constants definition]

//! [public module structs definition]

/* Scom Device Address Register Struct */
typedef struct SScomChannel {
	alt_u32 uliDevBaseAddr; /* Scom Device Base Address */
} TSScomChannel;

/* SpaceWire Device Address Register Struct */
typedef struct SSpwcDevAddr {
	alt_u32 uliSpwcBaseAddr; /* SpaceWire Device Base Address */
} TSSpwcDevAddr;

/* SpaceWire Link Config Register Struct */
typedef struct SSpwcLinkConfig {
	bool bDisconnect; /* SpaceWire Link Config Disconnect */
	bool bLinkStart; /* SpaceWire Link Config Linkstart */
	bool bAutostart; /* SpaceWire Link Config Autostart */
	alt_u32 ucTxDivCnt; /* SpaceWire Link Config TxDivCnt */
} TSSpwcLinkConfig;

/* SpaceWire Link Status Register Struct */
typedef struct SSpwcLinkStatus {
	bool bRunning; /* SpaceWire Link Running */
	bool bConnecting; /* SpaceWire Link Connecting */
	bool bStarted; /* SpaceWire Link Started */
} TSSpwcLinkStatus;

/* SpaceWire Link Status Register Struct */
typedef struct SSpwcLinkError {
	bool bDisconnect; /* SpaceWire Error Disconnect */
	bool bParity; /* SpaceWire Error Parity */
	bool bEscape; /* SpaceWire Error Escape */
	bool bCredit; /* SpaceWire Error Credit */
} TSSpwcLinkError;

/* SpaceWire Timecode Config Register Struct */
typedef struct SSpwcTimecodeConfig {
	bool bClear; /* SpaceWire Timecode Clear */
	bool bEnable; /* SpaceWire Timecode Enable */
} TSSpwcTimecodeConfig;

/* SpaceWire Timecode Status Register Struct */
typedef struct SSpwcTimecodeStatus {
	alt_u32 ucTime; /* SpaceWire Timecode Time */
	alt_u32 ucControl; /* SpaceWire Timecode Control */
} TSSpwcTimecodeStatus;

/* RMAP Device Address Register Struct */
typedef struct SRmapDevAddr {
	alt_u32 uliRmapBaseAddr; /* RMAP Device Base Address */
} TSRmapDevAddr;

/* RMAP Codec Config Register Struct */
typedef struct SRmapCodecConfig {
	alt_u32 ucLogicalAddress; /* RMAP Target Logical Address */
	alt_u32 ucKey; /* RMAP Target Key */
} TSRmapCodecConfig;

/* RMAP Codec Status Register Struct */
typedef struct SRmapCodecStatus {
	bool bCommandReceived; /* RMAP Status Command Received */
	bool bWriteRequested; /* RMAP Status Write Requested */
	bool bWriteAuthorized; /* RMAP Status Write Authorized */
	bool bReadRequested; /* RMAP Status Read Requested */
	bool bReadAuthorized; /* RMAP Status Read Authorized */
	bool bReplySended; /* RMAP Status Reply Sended */
	bool bDiscardedPackage; /* RMAP Status Discarded Package */
} TSRmapCodecStatus;

/* RMAP Codec Status Register Struct */
typedef struct SRmapCodecError {
	bool bEarlyEop; /* RMAP Error Early EOP */
	bool bEep; /* RMAP Error EEP */
	bool bHeaderCRC; /* RMAP Error Header CRC */
	bool bUnusedPacketType; /* RMAP Error Unused Packet Type */
	bool bInvalidCommandCode; /* RMAP Error Invalid Command Code */
	bool bTooMuchData; /* RMAP Error Too Much Data */
	bool bInvalidDataCrc; /* RMAP Error Invalid Data CRC */
} TSRmapCodecError;

/* RMAP Memory Status Register Struct */
typedef struct SRmapMemStatus {
	alt_u32 uliLastWriteAddress; /* RMAP Last Write Address */
	alt_u32 uliLastWriteLengthBytes; /* RMAP Last Write Length [Bytes] */
	alt_u32 uliLastReadAddress; /* RMAP Last Read Address */
	alt_u32 uliLastReadLengthBytes; /* RMAP Last Read Length [Bytes] */
} TSRmapMemStatus;

/* RMAP Memory Config Register Struct */
typedef struct SRmapMemConfig {
	alt_u32 uliWinAreaOffHighDword; /* RMAP Windowing Area Offset (High Dword) */
	alt_u32 uliWinAreaOffLowDword; /* RMAP Windowing Area Offset (Low Dword) */
} TSRmapMemConfig;

/* RMAP Memory Area Pointer Register Struct */
typedef struct SRmapMemAreaPrt {
	TRmapMemArea *puliRmapAreaPrt; /* RMAP Memory Area Pointer */
} TSRmapMemAreaPrt;

/* FEE Machine Config Register Struct */
typedef struct SMachineControl {
	bool bClear; /* FEE Machine Clear */
	bool bStop; /* FEE Machine Stop */
	bool bStart; /* FEE Machine Start */
} TSMachineControl;

/* Data Packet Config Register Struct */
typedef struct SDataPacketConfig {
	alt_u32 usiPacketLength; /* Data Packet Packet Length */
	alt_u32 ucFeeMode; /* Data Packet FEE Mode */
	alt_u32 ucCcdNumber; /* Data Packet CCD Number */
	alt_u32 ucProtocolId; /* Data Packet Protocol ID */
	alt_u32 ucLogicalAddr; /* Data Packet Logical Address */
} TSDataPacketConfig;

/* General Struct for Registers Access */
typedef struct ScomChannel {
	TSScomChannel xSScomChannel;
	TSSpwcDevAddr xSSpwcDevAddr;
	TSSpwcLinkConfig xSSpwcLinkConfig;
	TSSpwcLinkStatus xSSpwcLinkStatus;
	TSSpwcLinkError xSSpwcLinkError;
	TSSpwcTimecodeConfig xSSpwcTimecodeConfig;
	TSSpwcTimecodeStatus xSSpwcTimecodeStatus;
	TSRmapDevAddr xSRmapDevAddr;
	TSRmapCodecConfig xSRmapCodecConfig;
	TSRmapCodecStatus xSRmapCodecStatus;
	TSRmapCodecError xSRmapCodecError;
	TSRmapMemStatus xSRmapMemStatus;
	TSRmapMemConfig xSRmapMemConfig;
	TSRmapMemAreaPrt xSRmapMemAreaPrt;
	TSMachineControl xSMachineControl;
	TSDataPacketConfig xSDataPacketConfig;
} TScomChannel;

//! [public module structs definition]

//! [public function prototypes]

void vScomClearTimecode(void);

void vScomSoftRstMemAreaConfig(void);
void vScomSoftRstMemAreaHk(void);

void vScomInit(void);

//! [public function prototypes]

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* SCOM_H_ */
