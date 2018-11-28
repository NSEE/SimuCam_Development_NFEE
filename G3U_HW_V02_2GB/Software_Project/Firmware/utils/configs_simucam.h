/*
 * configs_simucam.h
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#ifndef CONFIGS_SIMUCAM_H_
#define CONFIGS_SIMUCAM_H_

#include "../simucam_defs_vars_structs_includes.h"
#include "sdcard_file_manager.h"

/*Struct that holds the values of the eth connection as port and socket pointer*/
typedef struct ConfCon{
	SSSConn* pxConn;
}TConfCon;

#define ETH_FILE_NAME "DEF/ETH"

typedef struct ConfEth{
	unsigned char ucIP[4];
	unsigned char ucGTW[4];
	unsigned char ucSubNet[4];
	unsigned char ucMAC[6];
	unsigned short int siPortDebug;
	unsigned short int siPortPUS;
	bool bDHCP;
	TConfCon xSocketPUS;
	TConfCon xSocketDebug;
}TConfEth;


extern TConfEth xConfEth;

#define min_sim( x , y ) ((x < y) ? x : y)


/*Functions*/
bool vLoadDefaultETHConf( void );


#endif /* CONFIGS_SIMUCAM_H_ */
