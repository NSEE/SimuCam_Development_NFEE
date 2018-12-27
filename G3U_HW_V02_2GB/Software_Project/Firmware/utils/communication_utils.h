/*
 * communication_utils.h
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#ifndef COMMUNICATION_UTILS_H_
#define COMMUNICATION_UTILS_H_


#include "communication_configs.h"



bool bSendUART128 ( char *cBuffer, short int siIdMessage );
void vSendEthConf ( void );
unsigned short int usiGetIdCMD ( void );


#endif /* COMMUNICATION_UTILS_H_ */
