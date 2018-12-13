/*
 * error_handler_simucam.h
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#ifndef ERROR_HANDLER_SIMUCAM_H_
#define ERROR_HANDLER_SIMUCAM_H_

#include "simucam_definitions.h"

#ifdef DEBUG_ON
    void printErrorTask( INT8U error_code );
#endif

INT8U vFailTestCriticasParts( void );
INT8U vFailGetMacRTC( void );
INT8U vFailInitialization( void );
INT8U vFailReceiverCreate( void );
INT8U vFailSenderCreate( void );
INT8U vFailDeleteInitialization( void );


#endif /* ERROR_HANDLER_SIMUCAM_H_ */
