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