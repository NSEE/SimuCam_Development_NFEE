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
#include "fee.h"

void vEvtChangeMebMode( tSimucamStates eOldState, tSimucamStates eNewState );

#endif /* EVENTS_HANDLER_H_ */
