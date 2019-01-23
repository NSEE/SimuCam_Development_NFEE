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
#include "../utils/fee.h"
#include "../utils/meb.h"

void vFeeTask(void *task_data);

#ifdef DEBUG_ON
	void vPrintUARTNFee( TNFee *pxNFee );
	void vPrintConsoleNFee( TNFee *pxNFee );
#endif


#endif /* FEE_TASK_H_ */
