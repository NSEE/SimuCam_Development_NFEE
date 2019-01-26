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

void vFailCreateMutexSResources( INT8U error_code )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailCreateMutexSResources. (exit)\n");
	#endif
	#ifdef DEBUG_ON
		printErrorTask(error_code);
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailCreateSemaphoreResources( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailCreateSemaphoreResources. (exit)\n");
	#endif

	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailTestCriticasParts( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailTestCriticasParts. (exit)\n");
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
		debug(fp,"Could not send the vParserRXTask. (exit)\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendPreParsedSemaphore( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendPreParsedSemaphore. (exit)\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendPreAckReceiverSemaphore( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendPreAckReceiverSemaphore. (exit)\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailSendPreAckSenderSemaphore( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendPreAckSenderSemaphore. (exit)\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailGetCountSemaphoreSenderTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetCountSemaphoreSenderTask. (exit)\n");
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
		debug(fp,"vFailGetMutexSenderTask. (exit)\n");
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
		debug(fp,"vFailGetCountSemaphoreReceiverTask. (exit)\n");
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
		debug(fp,"vFailGetMutexReceiverTask. (exit)\n");
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
		debug(fp,"vFailGetMutexTxUARTSenderTask. (exit)\n");
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
		debug(fp,"vFailGetMacRTC\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailInitialization( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailInitialization\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailReceiverCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vReceiverUartTask\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailSenderCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSenderCreate\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailDeleteInitialization( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailDeleteInitialization\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailSetCountSemaphorexBuffer32( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSetCountSemaphorexBuffer32. (exit)\n");
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
		debug(fp,"vFailSetCountSemaphorexBuffer64. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not post to the semaphore.()\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

/*CRITICAL*/
void vFailSetCountSemaphorexBuffer128( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSetCountSemaphorexBuffer128. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not post to the semaphore.()\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailGetCountSemaphorexBuffer128( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetCountSemaphorexBuffer128. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get to the semaphore.()\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailGetCountSemaphorexBuffer64( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetCountSemaphorexBuffer64. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get to the semaphore.()\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailGetCountSemaphorexBuffer32( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetCountSemaphorexBuffer32. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get to the semaphore.()\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailFoundBufferRetransmission( void )
{
	#ifdef DEBUG_ON
		debug(fp,"Warning: Incomming Ack id doesn't exists.\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not found the id in the (re)transmission buffers.(In Ack Handler)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailGetCountSemaphorePreParsedBuffer( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetCountSemaphorePreParsedBuffer. (exit)\n");
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
		debug(fp,"vFailGetxMutexPreParsedParserRxTask. (exit)\n");
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
		debug(fp,"vNoContentInPreParsedBuffer. (exit)\n");
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
		debug(fp,"vCouldNotSendEthConfUART. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send or not write ETH conf of the NUC in the (re)transmission buffer.(vSendEthConf)\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendNack( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendNack. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Send Nack using the PreAckSender buffer. \n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSetPreAckSenderBuffer( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSetPreAckSenderBuffer. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send the message to the task out_ack_handler using the PreAckSender buffer.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSetPreParsedBuffer( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSetPreParsedBuffer. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send the message to the task parser_comm using the PreParsed buffer.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailSetPreAckReceiverBuffer( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSetPreAckReceiverBuffer. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send the message to the task in_out_handler using the PreAckReceiver buffer.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailParserCommTaskCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailParserCommTaskCreate\n");
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailInAckHandlerTaskCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailInAckHandlerTaskCreate\n");
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

void vFailOutAckHandlerTaskCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailInAckHandlerTaskCreate\n");
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailCreateTimerRetransmisison( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailCreateTimerRetransmisison\n");
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vCouldNotCheckBufferTimeOutFunction( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotCheckBufferTimeOutFunction\n");
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}

/* Critico */
void vFailTimeoutCheckerTaskCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailTimeoutCheckerTaskCreate (Critico)\n");
	#endif
	/*
	 * Implementaï¿½ï¿½o de indicaï¿½ï¿½o de falha antes de finalizar a execuï¿½ï¿½o
	 * Indicar falha com LEDs pois ï¿½ o unico HW inicializada atï¿½ o momento
	 */
}


void vFailGetBlockingSemTimeoutTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetBlockingSemTimeoutTask. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Retrun from a blocking (0) OSSemPend with a error.\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailPostBlockingSemTimeoutTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailPostBlockingSemTimeoutTask. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not Post the semaphore for the TimeoutTask.\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailCouldNotRetransmitTimeoutTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailCouldNotRetransmitTimeoutTask. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"After sleep for 50 ticks, could not get access to the tx uart. No retransmission occurs.\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vCouldNotRetransmitB32TimeoutTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotRetransmitB32TimeoutTask. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"There's something to retransmit but could not get the mutex for the buffer (32).\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCouldNotRetransmitB64TimeoutTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotRetransmitB64TimeoutTask. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"There's something to retransmit but could not get the mutex for the buffer (64).\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCouldNotRetransmitB128TimeoutTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotRetransmitB128TimeoutTask. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"There's something to retransmit but could not get the mutex for the buffer (128).\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailStartTimerRetransmission( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailStartTimerRetransmission. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Fail trying to start the timer xTimerRetransmission.\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vCouldNotSendTurnOff( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotSendTurnOff. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send the turn off command. \n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCouldNotSendReset( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotSendReset. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send the reset command. \n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCouldNotSendLog( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotSendLog. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send log packet to NUC. \n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vCouldNotSendTMPusCommand( const char *cData )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotSendTMPusCommand. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not send the TM PUS command to NUC. \n");
		debug(fp,"cData");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

/* Not send message is bad but the Simucam will continue to work. */
void vWarnCouldNotgetMutexRetrans128( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vWarnCouldNotgetMutexRetrans128. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Warning: Could not get the mutex for the retransmission. The message will be lost.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


/* CRITICAL. */
void vFailCreateScheduleQueue( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailCreateScheduleQueue. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"CRITICAL: Could not create the Queue to shcedule the access to the DMA.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

/* CRITICAL. */
void vFailCreateNFEEQueue( unsigned char ucID )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailCreateNFEEQueue. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		printf(fp,"CRITICAL: Could not create the Queue to the NSEE %hhu.\n",ucID);
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

/* CRITICAL. */
void vFailCreateNFEESyncQueue( unsigned char ucID )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailCreateNFEESyncQueue. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		printf(fp,"CRITICAL: Could not create the Queue to the NFEE %hhu.\n",ucID);
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCoudlNotCreateNFee0Task( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCoudlNotCreateNFee0Task. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not create NFEE 0 Task.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vCoudlNotCreateNFee1Task( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCoudlNotCreateNFee1Task. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not create NFEE 1 Task.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCoudlNotCreateNFee2Task( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCoudlNotCreateNFee2Task. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not create NFEE 2 Task.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCoudlNotCreateNFee3Task( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCoudlNotCreateNFee3Task. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not create NFEE 3 Task.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCoudlNotCreateNFee4Task( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCoudlNotCreateNFee4Task. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not create NFEE 4 Task.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCoudlNotCreateNFee5Task( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCoudlNotCreateNFee5Task. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not create NFEE 5 Task.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vCoudlNotCreateNFeeControllerTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCoudlNotCreateNFeeControllerTask. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not create NFEE Controller Task.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vCoudlNotCreateDataControllerTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCoudlNotCreateDataControllerTask. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not create Data Controller Task.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vCoudlNotCreateMebTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCoudlNotCreateMebTask. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not create Meb Task.\n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailCreateMutexSPUSQueueMeb( INT8U error_code )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailCreateMutexSPUSQueueMeb. (exit)\n");
	#endif
	#ifdef DEBUG_ON
		printErrorTask(error_code);
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendPUStoMebTask( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendPUStoMebTask. (exit)\n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCouldNotGetCmdQueueMeb( void )
{
	#ifdef DEBUG_ON
		debug(fp,"CRITICAL: vCouldNotGetCmdQueueMeb. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get COmmand from Queue in the Meb Task. \n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vCouldNotGetMutexMebPus( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotGetMutexMebPus. (exit)\n");
	#endif
	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCouldNotCreateQueueMaskNfeeCtrl( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotCreateQueueMaskNfeeCtrl. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not Create Queue Mask for NFEE Controller. \n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCouldNotCreateQueueMaskDataCtrl( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotCreateQueueMaskDataCtrl. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not Create Queue Mask for Data Controller. \n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCouldNotGetQueueMaskNfeeCtrl( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotGetQueueMaskNfeeCtrl. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get Queue Mask for NFEE Controller. \n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vCouldNotGetQueueMaskDataCtrl( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vCouldNotGetQueueMaskDataCtrl. (exit)\n");
	#endif

	#ifdef DEBUG_ON
		debug(fp,"Could not get Queue Mask for Data Controller. \n");
	#endif	
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}


void vFailSendMsgAccessDMA( unsigned char ucTemp)
{
	#ifdef DEBUG_ON
		fprintf(fp,"vFailSendMsgAccessDMA. FEE n: \n", ucTemp);
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendMsgSync( unsigned char ucTemp)
{
	#ifdef DEBUG_ON
		fprintf(fp,"vFailSendMsgSync. FEE n: \n", ucTemp);
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendMsgMasterSyncMeb( void )
{
	#ifdef DEBUG_ON
		fprintf(fp,"vFailSendMsgMasterSyncMeb \n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendMsgFeeCTRL( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendMsgFeeCTRL.  \n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailSendMsgDataCTRL( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSendMsgDataCTRL.  \n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailFlushQueue( void )
{
	#ifdef DEBUG_ON
		debug(fp,"CRITICAL: vFailFlushQueue.  \n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailFlushMEBQueue( void )
{
	#ifdef DEBUG_ON
		debug(fp,"CRITICAL: vFailFlushMEBQueue.  \n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}

void vFailFlushNFEEQueue( void )
{
	#ifdef DEBUG_ON
		debug(fp,"CRITICAL: vFailFlushNFEEQueue.  \n");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
}
