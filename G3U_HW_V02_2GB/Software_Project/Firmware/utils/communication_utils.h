/*
 * communication_utils.h
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#ifndef COMMUNICATION_UTILS_H_
#define COMMUNICATION_UTILS_H_


#include "communication_configs.h"
#include "configs_simucam.h"


#define EVT_MEBFEE_MEB_ID  0
#define EVT_MEBFEE_FEE_OFS 1

enum EventsList {
	eEvtSpwEnable = 0,          /* Event SPW ENABLE */
	eEvtSpwEnableErr,           /* Event SPW ENABLE ERROR */
	eEvtSpwDisable,             /* Event SPW DISABLE */
	eEvtSpwDisableErr,          /* Event SPW DISABLE ERROR */
	eEvtNotIntentDisconnection, /* Event NOT INTENTIONAL DISCONNECTION */
	eEvtNotIntentConnection,    /* Event NOT INTENTIONAL CONNECTION */
	eEvtErrorReceivedFromUsbHw, /* Event ERROR RECEIVED FROM USB HW */
	eEvtMebInConfigMode,        /* Event MEB IN CONFIG MODE */
	eEvtMebInRunMode,           /* Event MEB IN RUN MODE */
	eEvtMebReset,               /* Event MEB RESET */
	eEvtShutdown,               /* Event SHUTDOWN */
	eEvtPowerOn,                /* Event POWER ON */
	eEvtDtcCriticalError,       /* Event DTC CRITICAL ERROR */
	eEvtFeeConfig,              /* Event FEE CONFIG */
	eEvtFeeStandby,             /* Event FEE STANDBY */
	eEvtFeeFullImage,           /* Event FEE FULL IMAGE */
	eEvtFeeFullImagePattern,    /* Event FEE FULL IMAGE PATTERN */
	eEvtFeeWindowing,           /* Event FEE WINDOWING */
	eEvtFeeWindowingPattern,    /* Event FEE WINDOWING PATTERN */
	eEvtFeeOn,                  /* Event FEE ON */
	eEvtParallel1TrapMode,      /* Event PARALLEL 1 TRAP MODE  */
	eEvtParallel2TrapMode,      /* Event PARALLEL 2 TRAP MODE */
	eEvtSerial1TrapMode,        /* Event SERIAL 1 TRAP MODE */
	eEvtSerial2TrapMode,        /* Event SERIAL 2 TRAP MODE */
	eEvtRmapReceived,           /* Event RMAP RECEIVED */
	eEvtImageIdDuplicated,      /* Event IMAGE ID DUPLICATED */
	eEvtSsdNoSpaceLeft,         /* Event SSD NO SPACE LEFT */
	eEvtNoImageDataForFee,      /* Event NO IMAGE DATA FOR FEE */
	eEvtPusClientDoesNotExists, /* Event PUS CLIENT DOES NOT EXISTS */
	eEvtCouldNotStartTcpServer  /* Event COULD NOT START TCP SERVER */
} EEventsList;

extern const alt_u8 cucEvtListData[30][4];

unsigned short int usiGetIdCMD ( void );
short int siPosStr( char *buffer, char cValue);
void vTimeoutCheck (void *p_arg);
void vSendEthConf ( void );
void vSendTurnOff ( void );
void vSendBufferChar128( const char * cDataIn );
void vSendReset ( void );
void vSendLog ( const char * cDataIn );
void vLogSendErrorChars(char layer, char type, char subtype, char severity);
void vSendLogError ( const char * cDataIn );
void vSendFEEStatus ( char cFEENumber, char cConfigMode );
void vSendPusTM64 ( tTMPus xPcktPus );
void vSendPusTM128 ( tTMPus xPcktPus );
void vSendPusTM512 ( tTMPus xPcktPus );
void vTMPusTestConnection( unsigned short int usiPusId, unsigned short int usiPid, unsigned short int usiCat );
bool bSendUART512v2 ( char *cBuffer, short int siIdMessage );
bool bSendUART128v2 ( char *cBuffer, short int siIdMessage );
bool bSendUART64v2 ( char *cBuffer, short int siIdMessage );
bool bSendUART32v2  ( char *cBuffer, short int siIdMessage );
void vSendEventLog (char usiFEE_MEB_Number, char usiLayer, char usiType, char usiSubType, char usiSeverity );
void vSendEventLogArr (alt_u8 ucFeeMebId, const alt_u8 cucEvtData[4]);


#endif /* COMMUNICATION_UTILS_H_ */
