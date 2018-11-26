/*
 * configs_simucam.h
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#ifndef CONFIGS_SIMUCAM_H_
#define CONFIGS_SIMUCAM_H_

#include "../simucam_defs_vars_structs_includes.h"

/*Struct that holds the values of the eth connection as port and socket pointer*/
typedef struct ConfCon{
	unsigned int uiPort;
	SSSConn* pxConn;
}TConfCon;


typedef struct ConfEth{
	unsigned char ucIP[4];
	unsigned char ucGTW[4];
	unsigned char ucSubNet[4];
	unsigned char ucMAC[6];
	TConfCon xSocketPUS;
	TConfCon xSocketDebug;
}TConfEth;


#endif /* CONFIGS_SIMUCAM_H_ */
