/*
 * configs_simucam.h
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#ifndef CONFIGS_SIMUCAM_H_
#define CONFIGS_SIMUCAM_H_

#include "../simucam_definitions.h"
#include "sdcard_file_manager.h"
#include <stdio.h>

/*Struct that holds the values of the eth connection as port and socket pointer*/
typedef struct ConfCon{
	SSSConn* pxConn;
}TConfCon;

#define ETH_FILE_NAME "DEF/ETH"

typedef struct ConfEth{
	unsigned char ucIP[4];
	unsigned char ucGTW[4];
	unsigned char ucSubNet[4];
	unsigned char ucDNS[4];
	unsigned char ucMAC[6];
	unsigned short int siPortPUS;
	bool bDHCP;
	TConfCon xSocketPUS;
	TConfCon xSocketDebug;
}TConfEth;


extern TConfEth xConfEth;



/*Functions*/
bool vLoadDefaultETHConf( void );
#ifdef DEBUG_ON
	void vShowEthConfig( void );
#endif
#endif /* CONFIGS_SIMUCAM_H_ */
