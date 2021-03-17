/*
 * defaults.h
 *
 *  Created on: 29 de set de 2020
 *      Author: rfranca
 */

#ifndef UTILS_DEFAULTS_H_
#define UTILS_DEFAULTS_H_

#include "../simucam_definitions.h"
#include "meb.h"
#include "configs_simucam.h"
#include "../driver/comm/comm.h"

//! [constants definition]
#define DEFT_MEB_DEFS_ID_LOWER_LIM      0
#define DEFT_FEE_DEFS_ID_LOWER_LIM      1000
#define DEFT_NUC_DEFS_ID_LOWER_LIM      10000
#define DEFT_NUC_DEFS_ID_RESERVED       0xFFFF
#define DEFT_RETRANSMISSION_TIMEOUT     5
//! [constants definition]

//! [public module structs definition]

/* MEB defaults */
typedef struct DeftMebDefaults {
	TDefaults xDebug; /* Debug */
	alt_u8 ucSyncSource; /* SyncSource */
	alt_u32 usiExposurePeriod; /* Exposure Period */
	bool bEventReport; /* Event Report */
	bool bLogReport; /* Log Report */
} TDeftMebDefaults;

/* FEE defaults */
typedef struct DeftFeeDefaults {
	TRmapMemArea xRmapMem; /* RMAP Memory */
	TSpwcLinkConfig xSpwLinkConfig; /* SpaceWire Link Config */
	bool bTimecodebTransEn; /* SpaceWire Timecode Transmission Enable */
	alt_u8 ucRmapLogicAddr; /* RMAP Logical Address */
	alt_u8 ucRmapKey; /* RMAP Key */
} TDeftFeeDefaults;

/* NUC defaults */
typedef struct DeftNucDefaults {
	TConfEth xEthernet; /* Ethernet */
} TDeftNucDefaults;
//! [public module structs definition]

//! [public function prototypes]
void vClearMebDefault();
bool bClearFeeDefault(alt_u8 ucFee);
void vClearNucDefault();

bool bSetMebDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue);
bool bSetFeeDefaultValues(alt_u8 ucFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue);
bool bSetNucDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue);

bool bSetDefaultValues(alt_u16 usiMebFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue);
//! [public function prototypes]

//! [data memory public global variables - use extern]
extern volatile bool vbDefaultsReceived;
extern volatile alt_u32 vuliExpectedDefaultsQtd;
extern volatile alt_u32 vuliReceivedDefaultsQtd;
extern volatile TDeftMebDefaults vxDeftMebDefaults;
extern volatile TDeftFeeDefaults vxDeftFeeDefaults[N_OF_NFEE];
extern volatile TDeftNucDefaults vxDeftNucDefaults;
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* UTILS_DEFAULTS_H_ */
