/*
 * fee_task.h
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */

#ifndef FEE_TASK_H_
#define FEE_TASK_H_

#include "../simucam_definitions.h"
#include "../utils/ccd.h"

typedef enum { sFeeConfig = 0, sFeeOn, sFeeStandBy, sFeeFull, sFeeTestFullPattern, sFeeWin, sFeeTestWinPattern, sFeeTestPartialRedout } tFEEStates;


void vFeeTask(void *task_data);

#endif /* FEE_TASK_H_ */
