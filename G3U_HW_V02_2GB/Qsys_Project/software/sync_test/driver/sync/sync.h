  /**
  * @file   sync.h
  * @Author Cassio Berni (ccberni@hotmail.com)
  * @date   Novembro, 2018
  * @brief  Header File para controle do sync ip via Nios-Avalon
  */
 
#ifndef SYNC_H_
#define SYNC_H_

#include "../../utils/meb_includes.h"
#include "system.h"
#include <altera_avalon_pio_regs.h>
#include <sys/alt_irq.h>

//! [constants definition]
// address
#define SYNC_BASE_ADDR					SYNC_BASE
#define SYNC_STATUS_REG_OFFSET			0
#define SYNC_INT_ENABLE_REG_OFFSET		1
#define SYNC_INT_FLAG_CLEAR_REG_OFFSET	2
#define SYNC_INT_FLAG_REG_OFFSET 		3
#define SYNC_CONFIG_MBT_REG_OFFSET 		4
#define SYNC_CONFIG_BT_REG_OFFSET		5
#define SYNC_CONFIG_PER_REG_OFFSET		6
#define SYNC_CONFIG_OST_REG_OFFSET 		7
#define SYNC_CONFIG_GENERAL_REG_OFFSET 	8
#define SYNC_ERR_INJ_REG_OFFSET 		9
#define SYNC_CTR_REG_OFFSET 			10

// bit states
#define BIT_ON   						TRUE
#define BIT_OFF  						FALSE

// bit masks
#define STATUS_EXTN_INT_MASK			0x80000000
#define STATUS_STATE_MASK				0x00FF0000
#define STATUS_ERROR_CODE_MASK			0x0000FF00
#define STATUS_CYCLE_NUMBER_MASK		0x000000FF

#define INT_ENABLE_ERROR_MASK			0x00000002
#define INT_ENABLE_BLANK_MASK			0x00000001

#define INT_FLAG_CLEAR_ERROR_MASK		0x00000002
#define INT_FLAG_CLEAR_BLANK_MASK		0x00000001

#define INT_FLAG_ERROR_MASK				0x00000002
#define INT_FLAG_BLANK_MASK				0x00000001

#define CONFIG_GENERAL_POLARITY_MASK	0x00000100
#define CONFIG_GENERAL_N_CYCLES_MASK	0x000000FF

#define CTR_EXTN_INT_MASK				0x80000000
#define CTR_START_MASK					0x00080000
#define CTR_RESET_MASK					0x00040000
#define CTR_ONE_SHOT_MASK				0x00020000
#define CTR_ERR_INJ_MASK				0x00010000
#define CTR_SYNC_OUT_EN_MASK			0x00000100
#define CTR_CHH_EN_MASK					0x00000080
#define CTR_CHG_EN_MASK					0x00000040
#define CTR_CHF_EN_MASK					0x00000020
#define CTR_CHE_EN_MASK					0x00000010
#define CTR_CHD_EN_MASK					0x00000008
#define CTR_CHC_EN_MASK					0x00000004
#define CTR_CHB_EN_MASK					0x00000002
#define CTR_CHA_EN_MASK					0x00000001
//! [constants definition]

//! [public module structs definition]
typedef struct general_config_t {
	bool 	polarity;
	alt_u8	n_cycles;
} general_config;

typedef struct ctr_reg_t {
	bool	extn_int;
	bool	start;
	bool	reset;
	bool	one_shot;
	bool	err_inj;
	bool	sync_out_en;
	bool	sync_cha_en;
	bool	sync_chb_en;
	bool	sync_chc_en;
	bool	sync_chd_en;
	bool	sync_che_en;
	bool	sync_chf_en;
	bool	sync_chg_en;
	bool	sync_chh_en;
} ctr_reg;
//! [public module structs definition]

//! [public function prototypes]
PUBLIC void init_interrupt(void);
PUBLIC void handle_irq(void* context, alt_u32 id);

PUBLIC bool sync_status_extn_int(void);
PUBLIC alt_u8 sync_status_state(void);
PUBLIC alt_u8 sync_status_error_code(void);
PUBLIC alt_u8 sync_status_cycle_number(void);

PUBLIC alt_u32 sync_read_status(void);

PUBLIC bool sync_int_enable_error(bool value);
PUBLIC bool sync_int_enable_blank(bool value);

PUBLIC bool sync_int_flag_clear_error(bool value);
PUBLIC bool sync_int_flag_clear_blank(bool value);

PUBLIC bool sync_int_flag_error(void);
PUBLIC bool sync_int_flag_blank(void);

PUBLIC bool sync_config_mbt(alt_u32 value);
PUBLIC bool sync_config_bt(alt_u32 value);
PUBLIC bool sync_config_per(alt_u32 value);
PUBLIC bool sync_config_ost(alt_u32 value);
PUBLIC bool sync_config_polarity(bool value);
PUBLIC bool sync_config_n_cycles(alt_u8 value);

PUBLIC alt_u32 sync_read_config_mbt(void);
PUBLIC alt_u32 sync_read_config_bt(void);
PUBLIC alt_u32 sync_read_config_per(void);
PUBLIC alt_u32 sync_read_config_ost(void);
PUBLIC alt_u32 sync_read_config_general(void);

PUBLIC bool sync_err_inj(alt_u32 value);

PUBLIC bool sync_ctr_extn_int(bool value);
PUBLIC bool sync_ctr_start(void);
PUBLIC bool sync_ctr_reset(void);
PUBLIC bool sync_ctr_one_shot(void);
PUBLIC bool sync_ctr_err_inj(void);
PUBLIC bool sync_ctr_sync_out_enable(bool value);
PUBLIC bool sync_ctr_cha_out_enable(bool value);
PUBLIC bool sync_ctr_chb_out_enable(bool value);
PUBLIC bool sync_ctr_chc_out_enable(bool value);
PUBLIC bool sync_ctr_chd_out_enable(bool value);
PUBLIC bool sync_ctr_che_out_enable(bool value);
PUBLIC bool sync_ctr_chf_out_enable(bool value);
PUBLIC bool sync_ctr_chg_out_enable(bool value);
PUBLIC bool sync_ctr_chh_out_enable(bool value);

PUBLIC alt_u32 sync_read_ctr(void);
//! [public function prototypes]

//! [data memory public global variables - use extern]
extern PUBLIC int n;
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* SYNC_H_ */
