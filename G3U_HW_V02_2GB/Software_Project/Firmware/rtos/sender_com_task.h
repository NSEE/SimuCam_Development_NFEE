/*
 * sender_com.h
 *
 *  Created on: 11/12/2018
 *      Author: Tiago-Low
 */

#ifndef SENDER_COM_H_
#define SENDER_COM_H_

#include "../simucam_definitions.h"
#include "configuration_comm.h"


typedef enum { sConfiguringSender = 0, sStartingConnSender, sDummySender , sHandlingErrorSender } tSenderStates;


void vSenderComTask(void *task_data);

#endif /* SENDER_COM_H_ */
