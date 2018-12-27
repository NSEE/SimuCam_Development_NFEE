/*
 * error_handler_simucam.c
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#include "error_handler_simucam.h"


#ifdef DEBUG_ON
    void printErrorTask( INT8U error_code ) {
		char buffer[16] = "";
		
		sprintf(buffer, "Err: %d\n", error_code);
		debug(fp, buffer);
	}
#endif

void vFailCreateRTOSResources( INT8U error_code )
{
	#ifdef DEBUG_ON
		printErrorTask(error_code);
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailTestCriticasParts( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailTestCriticasParts. (exit)");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailSendxSemCommInit( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendxSemCommInit. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send the vParserRXTask. (exit)");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendPreParsedSemaphore( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendPreParsedSemaphore. (exit)");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendPreAckReceiverSemaphore( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendPreAckReceiverSemaphore. (exit)");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailSendPreAckSenderSemaphore( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendPreAckSenderSemaphore. (exit)");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailGetCountSemaphoreSenderTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetCountSemaphoreSenderTask. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get the semaphore and some error happens.(vSenderAckTask)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailGetMutexSenderTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetMutexSenderTask. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get mutex that protects the xSenderACK.(vSenderAckTask)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailGetCountSemaphoreReceiverTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetCountSemaphoreReceiverTask. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get the semaphore and some error happens.(vReceiverAckTask)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailGetMutexReceiverTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetMutexReceiverTask. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get mutex that protects the xSenderACK.(vReceiverAckTask)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailGetMutexTxUARTSenderTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetMutexTxUARTSenderTask. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get mutex that protects the tx buffer.(vSenderAckTask)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailGetMacRTC( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetMacRTC");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailInitialization( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailInitialization");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailReceiverCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailReceiverCreate");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailSenderCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSenderCreate");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailDeleteInitialization( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailDeleteInitialization");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailSetCountSemaphorexBuffer32( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSetCountSemaphorexBuffer32. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not post to the semaphore.()\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSetCountSemaphorexBuffer64( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSetCountSemaphorexBuffer64. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not post to the semaphore.()\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSetCountSemaphorexBuffer128( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSetCountSemaphorexBuffer128. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not post to the semaphore.()\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailFoundBufferRetransmission( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailFoundBufferRetransmission. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not found the id in the (re)transmission buffers.(vReceiverAckTask)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailGetCountSemaphorePreParsedBuffer( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetCountSemaphorePreParsedBuffer. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get the semaphore and some error happens.(vParserRXTask)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailGetxMutexPreParsedParserRxTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetxMutexPreParsedParserRxTask. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get the mutex and some error happens.(vParserRXTask)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vNoContentInPreParsedBuffer( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vNoContentInPreParsedBuffer. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Semaphore was post by some task but has no message in the PreParsedBuffer.(vParserRXTask)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vCouldNotSendEthConfUART( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotSendEthConfUART. (exit)");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send or not write ETH conf of the NUC in the (re)transmission buffer.(vSendEthConf)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}