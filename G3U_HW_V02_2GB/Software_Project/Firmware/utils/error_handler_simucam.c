/*
 * error_handler_simucam.c
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#include "error_handler_simucam.h"


#if DEBUG_ON
    void printErrorTask( INT8U error_code ) {
		char buffer[16] = "";
		
		sprintf(buffer, "Err: %d\n", error_code);
		debug(fp, buffer);
	}
#endif

/* If some critical error ocours all LEDs in the panel will turn on */
void vCriticalErrorLedPanel( void ) {

	bSetPainelLeds( LEDS_ON, LEDS_PAINEL_ALL_MASK );
}

void vFailSendSemaphoreFromDTC( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSendSemaphoreFromDTC. (exit)\n");
	}
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailInitRTOSResources( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailInitRTOSResources. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCriticalFailUpdateMemoreDTController( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCriticalFailUpdateMemoreDTController. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCommunicationErrorUSB3DTController( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCommunicationErrorUSB3DTController. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendRequestDTController( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"bFTDIRequestFullImage returned FALSE. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailFTDIDMASchedule( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailFTDIDMASchedule. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailCreateMutexSResources( INT8U error_code )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCreateMutexSResources. (exit)\n");
		printErrorTask(error_code);
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailCreateMutexDMA( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp," CRITICAL: vFailCreateMutexDMA. (exit)\n");
	}
	#endif

	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailReadETHConf( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailReadETHConf. (exit)\n");
	}
	#endif

	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailCreateSemaphoreResources( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCreateSemaphoreResources. (exit)\n");
	}
	#endif

	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailTestCriticasParts( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailTestCriticasParts. (exit)\n");
	}
	#endif

	vCriticalErrorLedPanel();
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSDCard( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailTestCriticasParts. (exit)\n");
	}
	#endif

	vCriticalErrorLedPanel();
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendxSemCommInit( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSendxSemCommInit. (exit)");
		debug(fp,"Could not send the vParserRXTask. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendPreParsedSemaphore( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSendPreParsedSemaphore. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendPreAckReceiverSemaphore( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSendPreAckReceiverSemaphore. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailSendPreAckSenderSemaphore( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSendPreAckSenderSemaphore. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailGetCountSemaphoreSenderTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetCountSemaphoreSenderTask. (exit)\n");
		debug(fp,"Could not get the semaphore and some error happens.(vSenderAckTask)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailGetMutexSenderTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetMutexSenderTask. (exit)\n");
		debug(fp,"Could not get mutex that protects the xSenderACK.(vSenderAckTask)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailGetCountSemaphoreReceiverTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetCountSemaphoreReceiverTask. (exit)\n");
		debug(fp,"Could not get the semaphore and some error happens.(vReceiverAckTask)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailGetMutexReceiverTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetMutexReceiverTask. (exit)\n");
		debug(fp,"Could not get mutex that protects the xSenderACK.(vReceiverAckTask)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailGetMutexTxUARTSenderTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetMutexTxUARTSenderTask. (exit)\n");
		debug(fp,"Could not get mutex that protects the tx buffer.(vSenderAckTask)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailGetMacRTC( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetMacRTC\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailInitialization( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailInitialization\n");
	}
	#endif

	vCriticalErrorLedPanel();
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailReceiverCreate( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vReceiverUartTask\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailSenderCreate( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSenderCreate\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailDeleteInitialization( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailDeleteInitialization\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailSetCountSemaphorexBuffer32( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSetCountSemaphorexBuffer32. (exit)\n");
		debug(fp,"Could not post to the semaphore.()\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSetCountSemaphorexBuffer64( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSetCountSemaphorexBuffer64. (exit)\n");
		debug(fp,"Could not post to the semaphore.()\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

/*CRITICAL*/
void vFailSetCountSemaphorexBuffer512( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSetCountSemaphorexBuffer512. (exit)\n");
		debug(fp,"Could not post to the semaphore.()\n");
	}
	#endif

}

/*CRITICAL*/
void vFailSetCountSemaphorexBuffer128( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSetCountSemaphorexBuffer128. (exit)\n");
		debug(fp,"Could not post to the semaphore.()\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailGetCountSemaphorexBuffer512( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetCountSemaphorexBuffer512. (exit)\n");
		debug(fp,"Could not get to the semaphore.()\n");
	}
	#endif
}

void vFailGetCountSemaphorexBuffer128( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetCountSemaphorexBuffer128. (exit)\n");
		debug(fp,"Could not get to the semaphore.()\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailGetCountSemaphorexBuffer64( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetCountSemaphorexBuffer64. (exit)\n");
		debug(fp,"Could not get to the semaphore.()\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailGetCountSemaphorexBuffer32( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetCountSemaphorexBuffer32. (exit)\n");
		debug(fp,"Could not get to the semaphore.()\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailFoundBufferRetransmission( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"Warning: Incomming Ack id doesn't exists.\n");
		debug(fp,"Could not found the id in the (re)transmission buffers.(In Ack Handler)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailGetCountSemaphoreSenderBuffer( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetCountSemaphoreSenderBuffer. (exit)\n");
		debug(fp,"Could not get the semaphore and some error happens.(Sender task)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailGetCountSemaphorePreParsedBuffer( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetCountSemaphorePreParsedBuffer. (exit)\n");
		debug(fp,"Could not get the semaphore and some error happens.(vParserRXTask)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailGetxMutexPreParsedParserRxTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetxMutexPreParsedParserRxTask. (exit)\n");
		debug(fp,"Could not get the mutex and some error happens.(vParserRXTask)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailGetxMutexSenderBuffer128( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetxMutexSenderBuffer128. (exit)\n");
		debug(fp,"Could not get the mutex and some error happens.(vSender)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vNoContentInPreParsedBuffer( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vNoContentInPreParsedBuffer. (exit)\n");
		debug(fp,"Semaphore was post by some task but has no message in the PreParsedBuffer.(vParserRXTask)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vNoContentInSenderBuffer( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vNoContentInSenderBuffer. (exit)\n");
		debug(fp,"Semaphore was post by some task but has no message.(Sender)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCouldNotSendEthConfUART( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotSendEthConfUART. (exit)\n");
		debug(fp,"Could not send or not write ETH conf of the NUC in the (re)transmission buffer.(vSendEthConf)\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendNack( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSendNack. (exit)\n");
		debug(fp,"Send Nack using the PreAckSender buffer. \n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSetPreAckSenderBuffer( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSetPreAckSenderBuffer. (exit)\n");
		debug(fp,"Could not send the message to the task out_ack_handler using the PreAckSender buffer.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSetPreParsedBuffer( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSetPreParsedBuffer. (exit)\n");
		debug(fp,"Could not send the message to the task parser_comm using the PreParsed buffer.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailSetPreAckReceiverBuffer( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSetPreAckReceiverBuffer. (exit)\n");
		debug(fp,"Could not send the message to the task in_out_handler using the PreAckReceiver buffer.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailParserCommTaskCreate( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailParserCommTaskCreate\n");
	}
	#endif
	/*
	 * ImplementaÃ¯Â¿Â½Ã¯Â¿Â½o de indicaÃ¯Â¿Â½Ã¯Â¿Â½o de falha antes de finalizar a execuÃ¯Â¿Â½Ã¯Â¿Â½o
	 * Indicar falha com LEDs pois Ã¯Â¿Â½ o unico HW inicializada atÃ¯Â¿Â½ o momento
	 */
}

void vFailInAckHandlerTaskCreate( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailInAckHandlerTaskCreate\n");
	}
	#endif
	/*
	 * ImplementaÃ¯Â¿Â½Ã¯Â¿Â½o de indicaÃ¯Â¿Â½Ã¯Â¿Â½o de falha antes de finalizar a execuÃ¯Â¿Â½Ã¯Â¿Â½o
	 * Indicar falha com LEDs pois Ã¯Â¿Â½ o unico HW inicializada atÃ¯Â¿Â½ o momento
	 */
}

void vFailOutAckHandlerTaskCreate( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailInAckHandlerTaskCreate\n");
	}
	#endif
	/*
	 * ImplementaÃ¯Â¿Â½Ã¯Â¿Â½o de indicaÃ¯Â¿Â½Ã¯Â¿Â½o de falha antes de finalizar a execuÃ¯Â¿Â½Ã¯Â¿Â½o
	 * Indicar falha com LEDs pois Ã¯Â¿Â½ o unico HW inicializada atÃ¯Â¿Â½ o momento
	 */
}


void vFailCreateTimerRetransmisison( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCreateTimerRetransmisison\n");
	}
	#endif
	/*
	 * ImplementaÃ¯Â¿Â½Ã¯Â¿Â½o de indicaÃ¯Â¿Â½Ã¯Â¿Â½o de falha antes de finalizar a execuÃ¯Â¿Â½Ã¯Â¿Â½o
	 * Indicar falha com LEDs pois Ã¯Â¿Â½ o unico HW inicializada atÃ¯Â¿Â½ o momento
	 */
}


void vCouldNotCheckBufferTimeOutFunction( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotCheckBufferTimeOutFunction\n");
	}
	#endif
	/*
	 * ImplementaÃ¯Â¿Â½Ã¯Â¿Â½o de indicaÃ¯Â¿Â½Ã¯Â¿Â½o de falha antes de finalizar a execuÃ¯Â¿Â½Ã¯Â¿Â½o
	 * Indicar falha com LEDs pois Ã¯Â¿Â½ o unico HW inicializada atÃ¯Â¿Â½ o momento
	 */
}

/* Critico */
void vFailTimeoutCheckerTaskCreate( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailTimeoutCheckerTaskCreate (Critico)\n");
	}
	#endif
	/*
	 * ImplementaÃ¯Â¿Â½Ã¯Â¿Â½o de indicaÃ¯Â¿Â½Ã¯Â¿Â½o de falha antes de finalizar a execuÃ¯Â¿Â½Ã¯Â¿Â½o
	 * Indicar falha com LEDs pois Ã¯Â¿Â½ o unico HW inicializada atÃ¯Â¿Â½ o momento
	 */
}


void vFailGetBlockingSemTimeoutTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailGetBlockingSemTimeoutTask. (exit)\n");
		debug(fp,"Retrun from a blocking (0) OSSemPend with a error.\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailPostBlockingSemTimeoutTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailPostBlockingSemTimeoutTask. (exit)\n");
		debug(fp,"Could not Post the semaphore for the TimeoutTask.\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailCouldNotRetransmitTimeoutTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCouldNotRetransmitTimeoutTask. (exit)\n");
		debug(fp,"After sleep for 50 ticks, could not get access to the tx uart. No retransmission occurs.\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCouldNotRetransmitB32TimeoutTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotRetransmitB32TimeoutTask. (exit)\n");
		debug(fp,"There's something to retransmit but could not get the mutex for the buffer (32).\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotRetransmitB64TimeoutTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotRetransmitB64TimeoutTask. (exit)\n");
		debug(fp,"There's something to retransmit but could not get the mutex for the buffer (64).\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotRetransmitB128TimeoutTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotRetransmitB128TimeoutTask. (exit)\n");
		debug(fp,"There's something to retransmit but could not get the mutex for the buffer (128).\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailStartTimerRetransmission( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailStartTimerRetransmission. (exit)\n");
		debug(fp,"Fail trying to start the timer xTimerRetransmission.\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCouldNotSendTurnOff( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotSendTurnOff. (exit)\n");
		debug(fp,"Could not send the turn off command. \n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotSendGenericMessageInternalCMD( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotSendGenericMessageInternalCMD. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotSendReset( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotSendReset. (exit)\n");
		debug(fp,"Could not send the reset command. \n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotSendLog( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotSendLog. (exit)\n");
		debug(fp,"Could not send log packet to NUC. \n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCouldNotSendTMPusCommand( const char *cData )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotSendTMPusCommand. (exit)\n");
		debug(fp,"Could not send the TM PUS command to NUC. \n");
		debug(fp,"cData");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

/* Not send message is bad but the Simucam will continue to work. */
void vWarnCouldNotgetMutexRetrans128( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vWarnCouldNotgetMutexRetrans128. (exit)\n");
		debug(fp,"Warning: Could not get the mutex for the retransmission. The message will be lost.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


/* CRITICAL. */
void vFailCreateScheduleQueue( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCreateScheduleQueue. (exit)\n");
		debug(fp,"CRITICAL: Could not create the Queue to shcedule the access to the DMA.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

/* CRITICAL. */
void vFailCreateNFEEQueue( unsigned char ucID )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCreateNFEEQueue. (exit)\n");
		fprintf(fp,"CRITICAL: Could not create the Queue to the NSEE %hhu.\n",ucID);
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

/* CRITICAL. */
void vFailCreateMebQueue( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCreateMebQueue. (exit)\n");
		fprintf(fp,"CRITICAL: Could not create the Queue to the NSEE.\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

/* CRITICAL. */
void vFailCreateLUTQueue( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCreateLUTQueue. (exit)\n");
		fprintf(fp,"CRITICAL: Could not create the Queue to the NSEE.\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

/* CRITICAL. */
void vFailCreateNFEESyncQueue( unsigned char ucID )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCreateNFEESyncQueue. (exit)\n");
		fprintf(fp,"CRITICAL: Could not create the Queue to the NFEE %hhu.\n",ucID);
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCoudlNotCreateNFee0Task( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCoudlNotCreateNFee0Task. (exit)\n");
		debug(fp,"Could not create NFEE 0 Task.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCoudlNotCreateNFee1Task( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCoudlNotCreateNFee1Task. (exit)\n");
		debug(fp,"Could not create NFEE 1 Task.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCoudlNotCreateNFee2Task( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCoudlNotCreateNFee2Task. (exit)\n");
		debug(fp,"Could not create NFEE 2 Task.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCoudlNotCreateNFee3Task( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCoudlNotCreateNFee3Task. (exit)\n");
		debug(fp,"Could not create NFEE 3 Task.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCoudlNotCreateNFee4Task( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCoudlNotCreateNFee4Task. (exit)\n");
		debug(fp,"Could not create NFEE 4 Task.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCoudlNotCreateNFee5Task( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCoudlNotCreateNFee5Task. (exit)\n");
		debug(fp,"Could not create NFEE 5 Task.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCoudlNotCreateNFeeControllerTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCoudlNotCreateNFeeControllerTask. (exit)\n");
		debug(fp,"Could not create NFEE Controller Task.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCoudlNotCreateDataControllerTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCoudlNotCreateDataControllerTask. (exit)\n");
		debug(fp,"Could not create Data Controller Task.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCoudlNotCreateMebTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCoudlNotCreateMebTask. (exit)\n");
		debug(fp,"Could not create Meb Task.\n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailCreateMutexSPUSQueueMeb( INT8U error_code )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailCreateMutexSPUSQueueMeb. (exit)\n");
		printErrorTask(error_code);
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendPUStoMebTask( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSendPUStoMebTask. (exit)\n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotGetCmdQueueMeb( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"CRITICAL: vCouldNotGetCmdQueueMeb. (exit)\n");
		debug(fp,"Could not get COmmand from Queue in the Meb Task. \n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCouldNotGetMutexMebPus( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotGetMutexMebPus. (exit)\n");
	}
	#endif
	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotCreateQueueMaskNfeeCtrl( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotCreateQueueMaskNfeeCtrl. (exit)\n");
		debug(fp,"Could not Create Queue Mask for NFEE Controller. \n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotCreateQueueMaskDataCtrl( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotCreateQueueMaskDataCtrl. (exit)\n");
		debug(fp,"Could not Create Queue Mask for Data Controller. \n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotGetQueueMaskNfeeCtrl( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotGetQueueMaskNfeeCtrl. (exit)\n");
		debug(fp,"Could not get Queue Mask for NFEE Controller. \n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vCouldNotGetQueueMaskDataCtrl( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vCouldNotGetQueueMaskDataCtrl. (exit)\n");
		debug(fp,"Could not get Queue Mask for Data Controller. \n");
	}
	#endif	
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailSendMsgAccessDMA( unsigned char ucTemp)
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendMsgAccessDMA. FEE n:%hhu \n", ucTemp);
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailRequestDMA( unsigned char ucTemp)
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailRequestDMA. FEE n:%hhu \n", ucTemp);
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailFromFEE ( void ) {
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendMSGMebTaskfromFEE \n");
	}
	#endif
}

void vFailSendMSGMebTask ( void ) {
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendMSGMebTask \n");
	}
	#endif
}

void vFailSendBufferFullIRQtoDTC ( void ) {
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendBufferFullIRQtoDTC \n");
	}
	#endif
}

void vFailSendBufferLastIRQtoLUT ( void ) {
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendBufferLastIRQtoLUT \n");
	}
	#endif
}

void vFailFtdiErrorIRQtoLUT ( void ) {
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailFtdiErrorIRQtoLUT \n");
	}
	#endif
}

void vFailSendBufferLastIRQtoDTC ( void ) {
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendBufferFullIRQtoDTC \n");
	}
	#endif
}

void vFailFtdiErrorIRQtoDTC ( void ) {
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendBufferFullIRQtoDTC \n");
	}
	#endif
}

void vFailSendBufferEmptyIRQtoDTC ( void ) {
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendBufferFullIRQtoDTC \n");
	}
	#endif
}


void vFailRequestDMAFromIRQ( unsigned char ucTemp)
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailRequestDMA. FEE n:%hhu \n", ucTemp);
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailSendRMAPFromIRQ( unsigned char ucTemp)
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendRMAPFromIRQ. FEE n:%hhu \n", ucTemp);
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailSendMsgSync( unsigned char ucTemp)
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendMsgSync. FEE n:%hhu \n", ucTemp);
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendMsgSyncRMAPTRIGGER( unsigned char ucTemp)
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendMsgSyncRMAPTRIGGER (FORCED MODE). FEE n:%hhu \n", ucTemp);
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailSendMsgMasterSyncDTC( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendMsgMasterSyncDTC \n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendMsgMasterSyncLut( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendMsgMasterSyncLut \n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendMsgMasterSyncMeb( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp,"vFailSendMsgMasterSyncMeb \n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendMsgFeeCTRL( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSendMsgFeeCTRL.  \n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailSendMsgDataCTRL( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vFailSendMsgDataCTRL.  \n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailFlushQueue( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"CRITICAL: vFailFlushQueue.  \n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailFlushQueueData( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"CRITICAL: vFailFlushQueueData.  \n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailFlushMEBQueue( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"CRITICAL: vFailFlushMEBQueue.  \n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailFlushNFEEQueue( void )
{
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"CRITICAL: vFailFlushNFEEQueue.  \n");
	}
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

/* [bndky] */
void vFailSyncResetCreate( void ){
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		debug(fp,"vSyncResetTask\n");
	}
	#endif
	/*
	*	TODO:
	*	Implement some other form of advice?
	*/
}
