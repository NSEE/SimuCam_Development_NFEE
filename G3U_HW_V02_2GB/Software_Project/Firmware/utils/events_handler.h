/*
 * events_handler.h
 *
 *  Created on: 23/01/2019
 *      Author: Tiago-note
 */

#ifndef EVENTS_HANDLER_H_
#define EVENTS_HANDLER_H_

#include "../simucam_definitions.h"
#include "meb.h"
#include "feeV2.h"


void vEvtChangeMebMode( void );
void vEvtChangeFeeControllerMode( void );
void vEvtChangeDataControllerMode( void );


#endif /* EVENTS_HANDLER_H_ */
