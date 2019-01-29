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
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <sys/alt_stdio.h>


#define ETH_FILE_NAME "DEF/ETH"
#define DEBUG_FILE_NAME "DEF/DEBUG"

typedef struct ConfEth{
	unsigned char ucIP[4];
	unsigned char ucGTW[4];
	unsigned char ucSubNet[4];
	unsigned char ucDNS[4];
	unsigned char ucMAC[6];
	unsigned short int siPortPUS;
	bool bDHCP;
}TConfEth;


typedef struct Defaults{
	unsigned char HK[16];
	unsigned short int usiOverScanSerial;
	unsigned short int usiPreScanSerial;
	unsigned short int usiOLN;
	unsigned short int usiCols;
	unsigned short int usiRows;
	unsigned short int usiSyncPeriod;
	unsigned short int usiDelay;
	bool bDataPacket;
	unsigned long ulLineDelay;
	unsigned long ulColDelay;
	unsigned long ulADCPixelDelay;
}TDefaults;


extern TConfEth xConfEth;
extern TDefaults xDefaults;



/*Functions*/
bool vLoadDefaultETHConf( void );
bool vLoadDebugConfs( void );

#ifdef DEBUG_ON
	void vShowEthConfig( void );
#endif
#endif /* CONFIGS_SIMUCAM_H_ */
