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
#include <OS_CPU.H>


#define ETH_FILE_NAME "LDEF/ETH"
#define DEBUG_FILE_NAME "LDEF/DEBUG"

typedef struct ConfEth{
	unsigned char ucIP[4];
	unsigned char ucGTW[4];
	unsigned char ucSubNet[4];
	unsigned char ucDNS[4];
//	unsigned char ucMAC[6];
	unsigned short int siPortPUS;
	bool bDHCP;
	unsigned char ucPID;
}TConfEth;

typedef struct Globals{
	bool bSyncReset;
	bool bNormal;			/*Indicates if it is a normal or Fast FEE. Normal=1; Fast=0*/
	volatile bool bPreMaster;		/*Indicates if is the pre-master sync cycle*/
	volatile bool bDTCFinished;		/*Indicates if the DTC finishes to update the memory*/
	volatile bool bJustBeforSync;	/*Indicates if is in the period that is between The Before Sync Signal and the Sync Interrupt Signal*/
	unsigned char ucEP0_3;	/*Indicate which sequence are 0, 1, 2, 3 => 0: Master Sync*/
}TGlobal;


typedef struct Defaults{
	unsigned char ucReadOutOrder[4];
	unsigned short int usiOverScanSerial;
	unsigned short int usiPreScanSerial;
	unsigned short int usiOLN;
	unsigned short int usiCols;
	unsigned short int usiRows;
	unsigned short int usiSyncPeriod;
	unsigned short int usiPreBtSync;
	bool bBufferOverflowEn;
	unsigned long ulStartDelay;
	unsigned long ulSkipDelay;
	unsigned long ulLineDelay;
	unsigned long ulADCPixelDelay;
	unsigned short int ucRmapKey;
	unsigned short int ucLogicalAddr;
	bool bSpwLinkStart;
	unsigned short int usiLinkNFEE0;
	unsigned short int usiDebugLevel;
	unsigned short int usiPatternType;
	unsigned short int usiGuardNFEEDelay;
	unsigned short int usiDataProtId;
	unsigned short int usiDpuLogicalAddr;
	unsigned short int usiSpwPLength;
}TDefaults;

typedef struct SpacewireErrInj{
	bool bDestinationErrorEn;
	alt_u8 ucOriginalDestAddr;
}TSpacewireErrInj;

typedef struct TimeCodeErrInj{
	bool  				bFEE_NUMBER[8];
	alt_u16				usiMissCount[8];
	bool				bMissTC;
	bool				bFEE_WRONG_NUMBER[8];
	alt_u16				usiWrongCount[8];
	alt_u16				usiWrongOffSet[8];
	bool				bWrongTC;
	alt_u16				usiUxpCount[8];
	alt_u16				usiJitterCount[8];
	bool				bFEEUxp[8];
	bool				bFEEJitter[8];
	bool				bUxp;
	bool				bJitter;
}TTimeCodeErrInj;

extern TTimeCodeErrInj xTimeCodeErrInj;
extern TSpacewireErrInj xSpacewireErrInj[N_OF_NFEE];

extern bool bEventReport;
extern bool bLogReport;

extern TConfEth xConfEth;
extern TDefaults xDefaults;
extern TGlobal	xGlobal;

/*Functions*/
bool bLoadDefaultEthConf( void );
bool bLoadDefaultDebugConf( void );

void vLoadHardcodedEthConf( void );
void vLoadHardcodedDebugConf( void );

#if DEBUG_ON
	void vShowEthConfig( void );
	void vShowDebugConfig( void );
#endif
#endif /* CONFIGS_SIMUCAM_H_ */
