/*
 * error_handler_simucam.h
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#ifndef ERROR_HANDLER_SIMUCAM_H_
#define ERROR_HANDLER_SIMUCAM_H_

#include "../simucam_definitions.h"

#ifdef DEBUG_ON
    void printErrorTask( INT8U error_code );
#endif

void vFailTestCriticasParts( void );
void vFailGetMacRTC( void );
void vFailInitialization( void );
void vFailReceiverCreate( void );
void vFailSenderCreate( void );
void vFailDeleteInitialization( void );
void vFailCreateRTOSResources( INT8U error_code );
void vFailSendxSemCommInit( void );
void vFailSendPreParsedSemaphore( void );
void vFailSendPreAckSenderSemaphore( void );
void vFailSendPreAckReceiverSemaphore( void );
void vFailGetCountSemaphoreSenderTask( void );
void vFailGetMutexSenderTask( void );
void vFailGetMutexTxUARTSenderTask( void );
void vFailGetMutexReceiverTask( void );
void vFailGetCountSemaphoreReceiverTask( void );
void vFailSetCountSemaphorexBuffer32( void );
void vFailSetCountSemaphorexBuffer64( void );
void vFailSetCountSemaphorexBuffer128( void );
void vFailFoundBufferRetransmission( void );
void vFailGetCountSemaphorePreParsedBuffer( void );
void vFailGetxMutexPreParsedParserRxTask( void );
void vNoContentInPreParsedBuffer( void );
void vCouldNotSendEthConfUART( void );

#endif /* ERROR_HANDLER_SIMUCAM_H_ */
