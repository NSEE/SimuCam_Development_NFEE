/*
 * events_handler.c
 *
 *  Created on: 23/01/2019
 *      Author: Tiago-note
 */


#include "events_handler.h"


void vEvtChangeMebMode( tSimucamStates eOldState, tSimucamStates eNewState ) {

	#ifdef DEBUG_ON
		fprintf(fp, "\nvEvtChangeMebMode ( sMebConfig = 0, sRun = 1 ) \n");
		fprintf(fp, "Meb State Change: %hu -> %hu \n\n", eOldState, eNewState );
	#endif

	/*todo: Realizar qualquer acao relacionado ao evento: Sinalizacao com LED ou enviar pacote PUS caso cadastrado etc */
}


void vEvtChangeFeeControllerMode( tSimucamStates eOldState, tSimucamStates eNewState ) {

	#ifdef DEBUG_ON
		fprintf(fp, "\vEvtChangeFeeControllerMode ( sMebConfig = 0, sRun = 1 ) \n");
		fprintf(fp, "NFEE Controller State Change: %hu -> %hu \n\n", eOldState, eNewState );
	#endif

	/*todo: Realizar qualquer acao relacionado ao evento: Sinalizacao com LED ou enviar pacote PUS caso cadastrado etc */
}


void vEvtChangeDataControllerMode( tSimucamStates eOldState, tSimucamStates eNewState ) {

	#ifdef DEBUG_ON
		fprintf(fp, "\vEvtChangeDataControllerMode ( sMebConfig = 0, sRun = 1 ) \n");
		fprintf(fp, "Data Controller State Change: %hu -> %hu \n\n", eOldState, eNewState );
	#endif

	/*todo: Realizar qualquer acao relacionado ao evento: Sinalizacao com LED ou enviar pacote PUS caso cadastrado etc */
}