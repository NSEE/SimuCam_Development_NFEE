/*
 * fee_taskV2.h
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */

#ifndef RTOS_FEE_TASKV2_H_
#define RTOS_FEE_TASKV2_H_

#include "../simucam_definitions.h"
#include "tasks_configurations.h"
#include "../utils/ccd.h"
#include "../utils/feeV2.h"
#include "../utils/meb.h"
#include "../driver/comm/spw_controller/spw_controller.h"
#include "../driver/comm/comm_channel.h"
#include "../utils/queue_commands_list.h"
#include "../api_driver/simucam_dma/simucam_dma.h"
#include "../driver/comm/data_packet/data_packet.h"
#include "../driver/comm/rmap/rmap.h"
#include "../driver/leds/leds.h"
#include "../utils/communication_configs.h"
#include "../utils/error_handler_simucam.h"


void vQCmdFEEinWaitingSync( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinOn( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinConfig( TNFee *pxNFeeP, unsigned int cmd );
void vInitialConfig_RMAPCodecConfig( TNFee *pxNFeeP );
void vInitialConfig_DpktPacket( TNFee *pxNFeeP );
void vInitialConfig_RmapMemHKArea( TNFee *pxNFeeP );

#endif /* RTOS_FEE_TASKV2_H_ */
