/*
 * events_handler.c
 *
 *  Created on: 23/01/2019
 *      Author: Tiago-note
 */


#include "events_handler.h"


void vEvtChangeMebMode( tSimucamStates eOldState, tSimucamStates eNewState ) {

	#ifdef DEBUG_ON
		fprintf(fp, "vEvtChangeMebMode ( sMebConfig = 0, sRun = 1 ) \n");
		fprintf(fp, "Meb State Change: %hu -> %hu \n", eOldState, eNewState );
	#endif

	/*todo: Realizar qualquer acao relacionado ao evento: Sinalizacao com LED ou enviar pacote PUS caso cadastrado etc */
}

