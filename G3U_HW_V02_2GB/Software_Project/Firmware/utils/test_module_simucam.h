/*
 * test_module_simucam.h
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#ifndef TEST_MODULE_SIMUCAM_H_
#define TEST_MODULE_SIMUCAM_H_

#include "../simucam_definitions.h"
#include "../api_driver/simucam_dma/simucam_dma.h"
#include "../driver/comm/comm_channel.h"
#include "../driver/sync/sync.h"
#include "../driver/ctrl_io_lvds/ctrl_io_lvds.h"
#include "../driver/reset/reset.h"
#include "../driver/memory_filler/memory_filler.h"
#include "../rtos/tasks_configurations.h"

bool bTestSimucamCriticalHW(void);
bool bTestSimucamBasicHW(void);

#endif /* TEST_MODULE_SIMUCAM_H_ */
