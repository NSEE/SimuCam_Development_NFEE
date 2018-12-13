/*
 * error_handler_simucam.c
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#include "error_handler_simucam.h"


#ifdef DEBUG_ON
    void printErrorTask( INT8U error_code ) {
		char buffer[9] = "";
		
		sprintf(buffer, "Err: %d\n", error_code);
		debug(fp, buffer);
	}
#endif


INT8U vFailTestCriticasParts( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailTestCriticasParts");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
	return -1;
}


INT8U vFailGetMacRTC( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailGetMacRTC");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
	return -1;
}


INT8U vFailInitialization( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailInitialization");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
	return -1;
}


INT8U vFailReceiverCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailReceiverCreate");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
	return -1;
}


INT8U vFailSenderCreate( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailSenderCreate");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
	return -1;
}


INT8U vFailDeleteInitialization( void )
{
	#ifdef DEBUG_ON
		debug(fp,"vFailDeleteInitialization");
	#endif
	/*
	 * Implementa��o de indica��o de falha antes de finalizar a execu��o
	 * Indicar falha com LEDs pois � o unico HW inicializada at� o momento
	 */
	return -1;
}