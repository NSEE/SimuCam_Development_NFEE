/**
 * @file   sync.h
 * @Author Cassio Berni (ccberni@hotmail.com)
 * @date   Novembro, 2018
 * @brief  Header File para controle do sync ip via Nios-Avalon
 */

#ifndef SYNC_H_
#define SYNC_H_

#include "../../simucam_definitions.h"
#include "../../utils/fee_controller.h"
#include "../../utils/queue_commands_list.h"
#include "../../utils/meb.h"
#include "../../utils/communication_configs.h"
#include "../../rtos/tasks_configurations.h"

//! [constants definition]
// address
#define SYNC_BASE_ADDR                  SYNC_BASE
#define SYNC_SYNC_IRQ                   11
#define SYNC_PRE_SYNC_IRQ               12

// bit states
#define SYNC_BIT_ON                     TRUE
#define SYNC_BIT_OFF                    FALSE

//! [constants definition]
extern const alt_u16 cusiSyncNFeeMasterBlankTimeMs;
extern const alt_u16 cusiSyncNFeeNormalBlankTimeMs;
extern const alt_u16 cusiSyncNFeeSyncPeriodMs;
extern const alt_u16 cusiSyncNFeeOneShotTimeMs;
extern const bool cbSyncNFeePulsePolarity;
extern const alt_u8 cusiSyncNFeeNumberOfPulses;

//! [public module structs definition]
typedef struct SyncStatus {
	bool   bIntExtN;
	alt_u8 ucState;
	alt_u8 ucErrorCode;
	alt_u8 ucCycleNumber;
} TSyncStatus;

typedef struct SyncIrqEn {
	bool bErrorIrqEn;
	bool bBlankPulseIrqEn;
	bool bMasterPulseIrqEn;
	bool bNormalPulseIrqEn;
	bool bLastPulseIrqEn;
} TSyncIrqEn;

typedef struct SyncIrqFlagClr {
	bool bErrorIrqFlagClr;
	bool bBlankPulseIrqFlagClr;
	bool bMasterPulseIrqFlagClr;
	bool bNormalPulseIrqFlagClr;
	bool bLastPulseIrqFlagClr;
} TSyncIrqFlagClr;

typedef struct SyncIrqFlag {
	bool bErrorIrqFlag;
	bool bBlankPulseIrqFlag;
	bool bMasterPulseIrqFlag;
	bool bNormalPulseIrqFlag;
	bool bLastPulseIrqFlag;
} TSyncIrqFlag;

typedef struct PreSyncIrqEn {
	bool bPreBlankPulseIrqEn;
	bool bPreMasterPulseIrqEn;
	bool bPreNormalPulseIrqEn;
	bool bPreLastPulseIrqEn;
} TPreSyncIrqEn;

typedef struct PreSyncIrqFlagClr {
	bool bPreBlankPulseIrqFlagClr;
	bool bPreMasterPulseIrqFlagClr;
	bool bPreNormalPulseIrqFlagClr;
	bool bPreLastPulseIrqFlagClr;
} TPreSyncIrqFlagClr;

typedef struct PreSyncIrqFlag {
	bool bPreBlankPulseIrqFlag;
	bool bPreMasterPulseIrqFlag;
	bool bPreNormalPulseIrqFlag;
	bool bPreLastPulseIrqFlag;
} TPreSyncIrqFlag;

typedef struct SyncConfig {
	alt_u32 uliMasterBlankTime;
	alt_u32 uliBlankTime;
	alt_u32 uliPreBlankTime;
	alt_u32 uliPeriod;
	alt_u32 uliOneShotTime;
} TSyncConfig;

typedef struct SyncGeneralConfig {
	bool   bSignalPolarity;
	alt_u8 ucNumberOfCycles;
} TSyncGeneralConfig;

typedef struct SyncErrorInjection {
	alt_u32 uliErrorInjection;
} TSyncErrorInjection;

typedef struct SyncControl {
	bool bIntExtN;
	bool bStart;
	bool bReset;
	bool bOneShot;
	bool bErrInj;
	bool bOutEn;
	bool bChannel1En;
	bool bChannel2En;
	bool bChannel3En;
	bool bChannel4En;
	bool bChannel5En;
	bool bChannel6En;
	bool bChannel7En;
	bool bChannel8En;
} TSyncControl;

typedef struct SyncIRQNumber {
	alt_u32 uliSyncIrqNumber;
	alt_u32 uliPreSyncIrqNumber;
} TSyncIRQNumber;

typedef struct SyncModule {
	TSyncStatus         xSyncStatus        ;
	TSyncIrqEn          xSyncIrqEn         ;
	TSyncIrqFlagClr     xSyncIrqFlagClr    ;
	TSyncIrqFlag        xSyncIrqFlag       ;
	TPreSyncIrqEn       xPreSyncIrqEn      ;
	TPreSyncIrqFlagClr  xPreSyncIrqFlagClr ;
	TPreSyncIrqFlag     xPreSyncIrqFlag    ;
	TSyncConfig         xSyncConfig        ;
	TSyncGeneralConfig  xSyncGeneralConfig ;
	TSyncErrorInjection xSyncErrorInjection;
	TSyncControl        xSyncControl       ;
	TSyncIRQNumber      xSyncIRQNumber     ;
} TSyncModule;
//! [public module structs definition]

//! [public function prototypes]
void vSyncInitIrq(void);
void vSyncHandleSyncIrq(void* pvContext);

void vSyncPreInitIrq(void);
void vSyncPreHandleIrq(void* pvContext);

bool bSyncStatusExtnIrq(void);
alt_u8 ucSyncStatusState(void);
alt_u8 ucSyncStatusErrorCode(void);
alt_u8 ucSyncStatusCycleNumber(void);

bool bSyncIrqEnableError(bool bValue);
bool bSyncIrqEnableBlankPulse(bool bValue);
bool bSyncIrqEnableMasterPulse(bool bValue);
bool bSyncIrqEnableNormalPulse(bool bValue);
bool bSyncIrqEnableLastPulse(bool bValue);

bool bSyncIrqFlagClrError(bool bValue);
bool bSyncIrqFlagClrBlankPulse(bool bValue);
bool bSyncIrqFlagClrMasterPulse(bool bValue);
bool bSyncIrqFlagClrNormalPulse(bool bValue);
bool bSyncIrqFlagClrLastPulse(bool bValue);

bool bSyncIrqFlagError(void);
bool bSyncIrqFlagBlankPulse(void);
bool bSyncIrqFlagMasterPulse(void);
bool bSyncIrqFlagNormalPulse(void);
bool bSyncIrqFlagLastPulse(void);

bool bSyncPreIrqEnableBlankPulse(bool bValue);
bool bSyncPreIrqEnableMasterPulse(bool bValue);
bool bSyncPreIrqEnableNormalPulse(bool bValue);
bool bSyncPreIrqEnableLastPulse(bool bValue);

bool bSyncPreIrqFlagClrBlankPulse(bool bValue);
bool bSyncPreIrqFlagClrMasterPulse(bool bValue);
bool bSyncPreIrqFlagClrNormalPulse(bool bValue);
bool bSyncPreIrqFlagClrLastPulse(bool bValue);

bool bSyncPreIrqFlagBlankPulse(void);
bool bSyncPreIrqFlagMasterPulse(void);
bool bSyncPreIrqFlagNormalPulse(void);
bool bSyncPreIrqFlagLastPulse(void);

bool bSyncSetMbt(alt_u32 uliValue);
bool bSyncSetBt(alt_u32 uliValue);
bool bSyncSetPreBt(alt_u32 uliValue);
bool bSyncSetPer(alt_u32 uliValue);
bool bSyncSetOst(alt_u32 uliValue);
bool bSyncSetPolarity(bool bValue);
bool bSyncSetNCycles(alt_u8 ucValue);

alt_u32 uliSyncGetMbt(void);
alt_u32 uliSyncGetBt(void);
alt_u32 uliSyncGetPer(void);
alt_u32 uliSyncGetOst(void);

bool bSyncErrInj(alt_u32 uliValue);

bool bSyncCtrIntern(bool bValue);
bool bSyncCtrStart(void);
bool bSyncCtrReset(void);
bool bSyncCtrOneShot(void);
bool bSyncCtrErrInj(void);
bool bSyncCtrSyncOutEnable(bool bValue);
bool bSyncCtrCh1OutEnable(bool bValue);
bool bSyncCtrCh2OutEnable(bool bValue);
bool bSyncCtrCh3OutEnable(bool bValue);
bool bSyncCtrCh4OutEnable(bool bValue);
bool bSyncCtrCh5OutEnable(bool bValue);
bool bSyncCtrCh6OutEnable(bool bValue);
bool bSyncCtrCh7OutEnable(bool bValue);
bool bSyncCtrCh8OutEnable(bool bValue);

bool bSyncConfigNFeeSyncPeriod(alt_u16 usiSyncPeriodMs);

//! [private function prototypes]
alt_u32 uliPerCalcPeriodMs(alt_u16 usiPeriodMs);
alt_u16 usiRegCalcTimeMs(alt_u32 uliSyncReg);
//! [private function prototypes]

void vSyncClearCounter(void);

//! [public function prototypes]

//! [data memory public global variables - use extern]
extern volatile alt_u8 vucN;
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* SYNC_H_ */
