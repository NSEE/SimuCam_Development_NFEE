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


// Master blank time = (MBT * 20 ns) = 400 ms
#define MBT	20E6
// Blank time = (BT * 20 ns) = 200 ms
#define BT	10E6
// Period = (PER * 20 ns) = 6,25 s
#define PER	312500E3
// One shot time = (OST * 20 ns) = 500 ms
#define OST	25E6
// Blank level polarity = '0'
#define POL FALSE
// Number of cycles = 4
#define N_CICLOS 4



bool bInitSync( void );
bool bStartSync(void);
bool bStopSync(void);
void bClearCounterSync(void);

#endif /* SYNC_HANDLER_H_ */
