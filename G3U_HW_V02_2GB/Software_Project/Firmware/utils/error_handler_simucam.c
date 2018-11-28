/*
 * error_handler_simucam.c
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#include "error_handler_simucam.h"

INT8U vFailTestCriticasParts( void )
{
	printf("vFailTestCriticasParts");
	/*
	 * Implementação de indicação de falha antes de finalizar a execução
	 * Indicar falha com LEDs pois é o unico HW inicializada até o momento
	 */
	return -1;
}


INT8U vFailGetMacRTC( void )
{
	printf("vFailGetMacRTC");
	/*
	 * Implementação de indicação de falha antes de finalizar a execução
	 * Indicar falha com LEDs pois é o unico HW inicializada até o momento
	 */
	return -1;
}
