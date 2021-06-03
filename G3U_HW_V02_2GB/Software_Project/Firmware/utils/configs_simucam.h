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

typedef struct EthInterfaceParams{
	alt_u16 siPortPUS;
	bool bDHCP;
	alt_u8 ucIP[4];
	alt_u8 ucSubNet[4];
	alt_u8 ucGTW[4];
	alt_u8 ucDNS[4];
	alt_u8 ucPID;
	alt_u8 ucPCAT;
}TEthInterfaceParams;

typedef struct Globals{
	bool bSyncReset;
	bool bNormal;			/*Indicates if it is a normal or Fast FEE. Normal=1; Fast=0*/
	volatile bool bPreMaster;		/*Indicates if is the pre-master sync cycle*/
	volatile bool bDTCFinished;		/*Indicates if the DTC finishes to update the memory*/
	volatile bool bJustBeforSync;	/*Indicates if is in the period that is between The Before Sync Signal and the Sync Interrupt Signal*/
	unsigned char ucEP0_3;	/*Indicate which sequence are 0, 1, 2, 3 => 0: Master Sync*/
}TGlobal;

typedef struct GenSimulationParams{
	alt_u16 usiOverScanSerial;
	alt_u16 usiPreScanSerial;
	alt_u16 usiOLN;
	alt_u16 usiCols;
	alt_u16 usiRows;
	alt_u16 usiExposurePeriod;
	bool bBufferOverflowEn;
	alt_u32 ulStartDelay;
	alt_u32 ulSkipDelay;
	alt_u32 ulLineDelay;
	alt_u32 ulADCPixelDelay;
	alt_u8 ucDebugLevel;
	alt_u16 usiGuardFEEDelay;
	alt_u8 ucSyncSource;
}TGenSimulationParams;

typedef struct SpwInterfaceParams{
	bool bSpwLinkStart;
	bool bSpwLinkAutostart;
	alt_u8 ucSpwLinkSpeed;
	bool bTimeCodeTransmissionEn;
	alt_u8 ucLogicalAddr;
	alt_u8 ucRmapKey;
	alt_u8 ucDataProtId;
	alt_u8 ucDpuLogicalAddr;
}TSpwInterfaceParams;

extern TEthInterfaceParams xConfEth;
extern TGenSimulationParams xDefaults;
extern TSpwInterfaceParams xConfSpw[N_OF_NFEE];
extern TGlobal xGlobal;

extern const TEthInterfaceParams cxDefaultsEthInterfaceParams;
extern const TGenSimulationParams cxDefaultsGenSimulationParams;
extern const TSpwInterfaceParams cxDefaultsSpwInterfaceParams;

/*Functions*/
bool bLoadDefaultEthConf( void );
bool bLoadDefaultDebugConf( void );

void vLoadHardcodedEthConf( void );
void vLoadHardcodedDebugConf( void );
bool bLoadHardcodedSpwConf( alt_u8 ucFee );

#if DEBUG_ON
	void vShowEthConfig( void );
	void vShowDebugConfig( void );
	bool bShowSpwConfig( alt_u8 ucFee );
#endif
#endif /* CONFIGS_SIMUCAM_H_ */
