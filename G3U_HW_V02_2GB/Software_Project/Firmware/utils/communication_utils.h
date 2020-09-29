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


#endif /* COMMUNICATION_UTILS_H_ */
