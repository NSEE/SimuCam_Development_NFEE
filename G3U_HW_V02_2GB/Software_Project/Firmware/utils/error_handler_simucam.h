/*
 * error_handler_simucam.h
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#ifndef ERROR_HANDLER_SIMUCAM_H_
#define ERROR_HANDLER_SIMUCAM_H_

#include "../simucam_definitions.h"
#include "configs_simucam.h"
#include "../driver/leds/leds.h"

#if DEBUG_ON
    void printErrorTask( INT8U error_code );
#endif

void vFailFtdiErrorIRQtoDTC ( void );
void vFailSendBufferLastIRQtoLUT ( void );
void vFailFtdiErrorIRQtoLUT ( void );
void vFailSendBufferEmptyIRQtoDTC ( void );
void vFailSendBufferLastIRQtoDTC ( void );
void vFailFromFEE ( void );
void vFailSendMSGMebTask ( void );
void vFailSendBufferFullIRQtoDTC ( void );
void vFailFTDIDMASchedule( void );
void vCommunicationErrorUSB3DTController( void );
void vCriticalFailUpdateMemoreDTController( void );
void vFailSendRequestDTController( void );
void vFailInitRTOSResources( void );
void vFailTestCriticasParts( void );
void vFailGetMacRTC( void );
void vFailInitialization( void );
void vFailReceiverCreate( void );
void vFailSenderCreate( void );
void vFailDeleteInitialization( void );
void vFailCreateMutexDMA( void );
void vFailReadETHConf( void );
void vFailCreateMutexSResources( INT8U error_code );
void vFailCreateSemaphoreResources( void );
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
void vFailSetCountSemaphorexBuffer512( void );
void vFailFoundBufferRetransmission( void );
void vFailGetCountSemaphorePreParsedBuffer( void );
void vFailGetCountSemaphoreSenderBuffer( void );
void vFailGetxMutexPreParsedParserRxTask( void );
void vFailGetxMutexSenderBuffer128( void );
void vNoContentInPreParsedBuffer( void );
void vNoContentInSenderBuffer( void );
void vCouldNotSendEthConfUART( void );
void vFailSendNack( void );
void vFailSetPreAckSenderBuffer( void );
void vFailSetPreParsedBuffer( void );
void vFailSetPreAckReceiverBuffer( void );
void vFailParserCommTaskCreate( void );
void vFailInAckHandlerTaskCreate( void );
void vFailOutAckHandlerTaskCreate( void );
void vFailCreateTimerRetransmisison( void );
void vCouldNotCheckBufferTimeOutFunction( void );
void vFailTimeoutCheckerTaskCreate( void );
void vFailGetBlockingSemTimeoutTask( void );
void vFailPostBlockingSemTimeoutTask( void );
void vCouldNotRetransmitB32TimeoutTask( void );
void vCouldNotRetransmitB64TimeoutTask( void );
void vCouldNotRetransmitB128TimeoutTask( void );
void vFailStartTimerRetransmission( void );
void vFailCouldNotRetransmitTimeoutTask( void );
void vCouldNotSendTurnOff( void );
void vCouldNotSendGenericMessageInternalCMD( void );
void vCouldNotSendReset( void );
void vCouldNotSendLog( void );
void vCouldNotSendTMPusCommand( const char *cData );
void vWarnCouldNotgetMutexRetrans128( void );
void vFailGetCountSemaphorexBuffer128( void );
void vFailGetCountSemaphorexBuffer512( void );
void vFailGetCountSemaphorexBuffer64( void );
void vFailGetCountSemaphorexBuffer32( void );
void vFailCreateScheduleQueue( void );
void vFailCreateNFEEQueue( unsigned char ucID );
void vCoudlNotCreateNFee0Task( void );
void vCoudlNotCreateNFee1Task( void );
void vCoudlNotCreateNFee2Task( void );
void vCoudlNotCreateNFee3Task( void );
void vCoudlNotCreateNFee4Task( void );
void vCoudlNotCreateNFee5Task( void );
void vCoudlNotCreateNFeeControllerTask( void );
void vCoudlNotCreateDataControllerTask( void );
void vCoudlNotCreateMebTask( void );
void vFailCreateMutexSPUSQueueMeb( INT8U error_code );
void vFailSendPUStoMebTask( void );
void vCouldNotGetCmdQueueMeb( void );
void vCouldNotGetMutexMebPus( void );
void vCouldNotCreateQueueMaskNfeeCtrl( void );
void vCouldNotCreateQueueMaskDataCtrl( void );
void vCouldNotGetQueueMaskNfeeCtrl( void );
void vCouldNotGetQueueMaskDataCtrl( void );
void vFailSendMsgAccessDMA( unsigned char ucTemp);
void vFailRequestDMA( unsigned char ucTemp);
void vFailSendMsgFeeCTRL( void );
void vFailSendMsgDataCTRL( void );
void vFailFlushQueue( void );
void vFailFlushMEBQueue( void );
void vFailFlushQueueData( void );
void vFailFlushNFEEQueue( void );
void vFailCreateLUTQueue( void );
void vFailCreateMebQueue( void );
void vFailCreateNFEESyncQueue( unsigned char ucID );
void vFailSendMsgSync( unsigned char ucTemp);
void vFailSendMsgMasterSyncDTC( void );
void vFailSendMsgMasterSyncLut( void );
void vFailSendMsgMasterSyncMeb( void );
void vFailRequestDMAFromIRQ( unsigned char ucTemp);
void vFailSendRMAPFromIRQ( unsigned char ucTemp);
void vFailSendMsgSyncRMAPTRIGGER( unsigned char ucTemp);
void vFailSDCard( void );
void vCriticalErrorLedPanel( void );
void vFailSendSemaphoreFromDTC( void );
void vFailSyncResetCreate( void ); /* [bndky] */

#endif /* ERROR_HANDLER_SIMUCAM_H_ */
