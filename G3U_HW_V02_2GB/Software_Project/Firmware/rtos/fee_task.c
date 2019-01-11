/*
 * fee_task.c
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */


#include "fee_task.h"



void vFeeTask(void *task_data) {
	tFEEStates eFeeState;
	bool bSuccess = FALSE;
	INT8U error_code;


	// Load default configurations CCD e FEE
	// carregar valores baseado no *task_data



	// IMplementar maquina de estados para o NFEE

	// LOOP
		// assim que tiver disponivel, agendar dma para buffer (transmissão)

		// Verificar se existe comando pus e realizar alterações

		// verificar se existe comando vindo do SPW

		// precisa mudar de estado?
			// em modo de emergencia ou apenas no sync?

		// Check sync ?
			// mudar de estado se isso estiver agendado




}
