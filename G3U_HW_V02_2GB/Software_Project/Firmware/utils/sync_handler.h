/*
 * sync_handler.h
 *
 *  Created on: 25/01/2019
 *      Author: Tiago-note
 */

#ifndef SYNC_HANDLER_H_
#define SYNC_HANDLER_H_


#include "../simucam_definitions.h"
#include "../driver/sync/sync.h"

bool bInitSync( void );
bool bStartSync(void);
bool bStopSync(void);
bool bClearSync(void);
void bClearCounterSync(void);

#endif /* SYNC_HANDLER_H_ */
