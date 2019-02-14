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
#define SYNC_STAT_REG_OFFSET            0
#define SYNC_IRQ_ENABLE_REG_OFFSET      1
#define SYNC_IRQ_FLAG_CLR_REG_OFFSET    2
#define SYNC_IRQ_FLAG_REG_OFFSET        3
#define SYNC_CONFIG_MBT_REG_OFFSET      4
#define SYNC_CONFIG_BT_REG_OFFSET       5
#define SYNC_CONFIG_PER_REG_OFFSET      6
#define SYNC_CONFIG_OST_REG_OFFSET      7
#define SYNC_CONFIG_GENERAL_REG_OFFSET  8
#define SYNC_ERR_INJ_REG_OFFSET         9
#define SYNC_CTR_REG_OFFSET             10
#define SYNC_IRQ_FG_CLR_REG_OFFSET      11
#define SYNC_IRQ_FG_REG_OFFSET          12

// bit states
#define SYNC_BIT_ON                     TRUE
#define SYNC_BIT_OFF                    FALSE

// bit masks
#define SYNC_STAT_EXTN_IRQ_MSK          0x80000000
#define SYNC_STAT_STATE_MSK             0x00FF0000
#define SYNC_STAT_ERROR_CODE_MSK        0x0000FF00
#define SYNC_STAT_CYCLE_NUMBER_MSK      0x000000FF

#define SYNC_IRQ_ENABLE_ERROR_MSK       0x00000002
#define SYNC_IRQ_ENABLE_BLANK_MSK       0x00000001

#define SYNC_IRQ_FLAG_CLR_ERROR_MSK     0x00000002
#define SYNC_IRQ_FLAG_CLR_BLANK_MSK     0x00000001

#define SYNC_IRQ_FLAG_ERROR_MSK         0x00000002
#define SYNC_IRQ_FLAG_BLANK_MSK         0x00000001

#define SYNC_CONFIG_GEN_POLARITY_MSK    0x00000100
#define SYNC_CONFIG_GEN_N_CYCLES_MSK    0x000000FF

#define SYNC_CTR_EXTN_INT_MSK           0x80000000
#define SYNC_CTR_START_MSK              0x00080000
#define SYNC_CTR_RESET_MSK              0x00040000
#define SYNC_CTR_ONE_SHOT_MSK           0x00020000
#define SYNC_CTR_ERR_INJ_MSK            0x00010000
#define SYNC_CTR_SYNC_OUT_EN_MSK        0x00000100
#define SYNC_CTR_CHH_EN_MSK             0x00000080
#define SYNC_CTR_CHG_EN_MSK             0x00000040
#define SYNC_CTR_CHF_EN_MSK             0x00000020
#define SYNC_CTR_CHE_EN_MSK             0x00000010
#define SYNC_CTR_CHD_EN_MSK             0x00000008
#define SYNC_CTR_CHC_EN_MSK             0x00000004
#define SYNC_CTR_CHB_EN_MSK             0x00000002
#define SYNC_CTR_CHA_EN_MSK             0x00000001

#define SYNC_IRQ_FG_CLR_MSK             0x00000001

#define SYNC_IRQ_FG_MSK                 0x00000001

//! [constants definition]

//! [public module structs definition]
typedef struct GeneralConfig {
	bool bPolarity;
	alt_u8 ucNCycles;
} TGeneralConfig;

typedef struct CtrReg {
	bool bExtnIrq;
	bool bStart;
	bool bReset;
	bool bOneShot;
	bool bErrInj;
	bool bSyncOutEn;
	bool bSyncCh1En;
	bool bSyncCh2En;
	bool bSyncCh3En;
	bool bSyncCh4En;
	bool bSyncCh5En;
	bool bSyncCh6En;
	bool bSyncCh7En;
	bool bSyncCh8En;
} TCtrReg;
//! [public module structs definition]

//! [public function prototypes]
void vSyncInitIrq(void);
void vSyncHandleIrq(void* pvContext);

void vSyncIrqFlagClrSync(void);
bool bSyncIrqFlagSync(void);

bool bSyncStatusExtnIrq(void);
alt_u8 ucSyncStatusState(void);
alt_u8 ucSyncStatusErrorCode(void);
alt_u8 ucSyncStatusCycleNumber(void);

alt_u32 uliSyncReadStatus(void);

bool bSyncIrqEnableError(bool bValue);
bool bSyncIrqEnableBlank(bool bValue);

bool bSyncIrqFlagClrError(bool bValue);
bool bSyncIrqFlagClrBlank(bool bValue);

bool bSyncIrqFlagError(void);
bool bSyncIrqFlagBlank(void);

bool bSyncSetMbt(alt_u32 uliValue);
bool bSyncSetBt(alt_u32 uliValue);
bool bSyncSetPer(alt_u32 uliValue);
bool bSyncSetOst(alt_u32 uliValue);
bool bSyncSetPolarity(bool bValue);
bool bSyncSetNCycles(alt_u8 ucValue);

alt_u32 uliSyncGetMbt(void);
alt_u32 uliSyncGetBt(void);
alt_u32 uliSyncGetPer(void);
alt_u32 uliSyncGetOst(void);
alt_u32 uliSyncGetGeneral(void);

bool bSyncErrInj(alt_u32 uliValue);

bool bSyncCtrExtnIrq(bool bValue);
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

//! [private function prototypes]
bool bSyncWriteReg(alt_u32 uliOffset, alt_u32 uliValue);
alt_u32 uliSyncReadReg(alt_u32 uliOffset);
alt_u32 uliPerCalcPeriodMs(alt_u16 usiPeriodMs);
//! [private function prototypes]

void vSyncClearCounter(void);

alt_u32 uliSyncGetCtr(void);
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
