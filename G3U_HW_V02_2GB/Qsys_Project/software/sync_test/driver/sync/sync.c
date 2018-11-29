  /**
  * @file   sync.c
  * @Author Cassio Berni (ccberni@hotmail.com)
  * @date   Novembro, 2018
  * @brief  Source File para controle sync ip via Nios-Avalon
  *
  */

#include "sync.h"

//! [private function prototypes]
PRIVATE bool write_reg(alt_u32 offset, alt_u32 data);
PRIVATE alt_u32 read_reg(alt_u32 offset);
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
// Status reg
PUBLIC bool sync_status_le_int_extn(void)
{
	alt_u32 aux;
	bool result;

	aux = read_reg(SYNC_STATUS_REG_OFFSET);

	if (aux & STATUS_INT_EXTN_MASK) {
		result = TRUE;
	}
	else {
		result = FALSE;
	}
	return result;
}

PUBLIC alt_u8 sync_status_le_state(void)
{
	alt_u32 aux;
	alt_u8 result;

	aux = read_reg(SYNC_STATUS_REG_OFFSET);
	result = (alt_u8) ((aux & STATUS_STATE_MASK) >> 16);
	return result;
}

PUBLIC alt_u8 sync_status_le_error_code(void)
{
	alt_u32 aux;
	alt_u8 result;

	aux = read_reg(SYNC_STATUS_REG_OFFSET);
	result = (alt_u8) ((aux & STATUS_ERROR_CODE_MASK) >> 8);
	return result;
}

PUBLIC alt_u8 sync_status_le_cycle_number(void)
{
	alt_u32 aux;
	alt_u8 result;

	aux = read_reg(SYNC_STATUS_REG_OFFSET);
	result = (alt_u8) ((aux & STATUS_CYCLE_NUMBER_MASK) >> 0);
	return result;
}

// Config regs
PUBLIC bool sync_config_mbt(alt_u32 value)
{
	write_reg(SYNC_CONFIG_MBT_REG_OFFSET, value);
 	return  TRUE;
}

PUBLIC bool sync_config_bt(alt_u32 value)
{
	write_reg(SYNC_CONFIG_BT_REG_OFFSET, value);
 	return  TRUE;
}

PUBLIC bool sync_config_per(alt_u32 value)
{
	write_reg(SYNC_CONFIG_PER_REG_OFFSET, value);
 	return  TRUE;
}

PUBLIC bool sync_config_ost(alt_u32 value)
{
	write_reg(SYNC_CONFIG_OST_REG_OFFSET, value);
 	return  TRUE;
}

PUBLIC bool sync_config_polarity(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CONFIG_GENERAL_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CONFIG_GENERAL_POLARITY_MASK;
	}
	else {
	aux |= CONFIG_GENERAL_POLARITY_MASK;
	}

	write_reg(SYNC_CONFIG_GENERAL_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_config_n_cyles(alt_u8 value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CONFIG_GENERAL_REG_OFFSET);
	aux &= ~CONFIG_GENERAL_N_CYCLES_MASK;
	aux |= (alt_u32) value;

	write_reg(SYNC_CONFIG_GENERAL_REG_OFFSET, aux);
 	return  TRUE;
}

// Error injection reg
PUBLIC bool sync_err_inj(alt_u32 value)
{
	write_reg(SYNC_ERR_INJ_REG_OFFSET, value);
 	return  TRUE;
}

// Control reg
PUBLIC bool sync_ctr_int_extn(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_INT_EXTN_MASK;
	}
	else {
	aux |= CTR_INT_EXTN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_start(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	aux |= CTR_START_MASK;

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_reset(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	aux |= CTR_RESET_MASK;

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_one_shot(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	aux |= CTR_ONE_SHOT_MASK;

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_err_inj(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	aux |= CTR_ERR_INJ_MASK;

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_sync_out_enable(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_SYNC_OUT_EN_MASK;
	}
	else {
	aux |= CTR_SYNC_OUT_EN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_cha_out_enable(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_CHA_EN_MASK;
	}
	else {
	aux |= CTR_CHA_EN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_chb_out_enable(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_CHB_EN_MASK;
	}
	else {
	aux |= CTR_CHB_EN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_chc_out_enable(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_CHC_EN_MASK;
	}
	else {
	aux |= CTR_CHC_EN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_chd_out_enable(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_CHD_EN_MASK;
	}
	else {
	aux |= CTR_CHD_EN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_che_out_enable(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_CHE_EN_MASK;
	}
	else {
	aux |= CTR_CHE_EN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_chf_out_enable(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_CHF_EN_MASK;
	}
	else {
	aux |= CTR_CHF_EN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_chg_out_enable(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_CHG_EN_MASK;
	}
	else {
	aux |= CTR_CHG_EN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

PUBLIC bool sync_ctr_chh_out_enable(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_CHH_EN_MASK;
	}
	else {
	aux |= CTR_CHH_EN_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}
//! [public functions]

//! [private functions]
/**
 * @name    write_reg
 * @brief
 * @ingroup sync
 *
 * Write 32 bits value in a reg
 *
 * @param [in] alt_u32 offset
 * @param [in] alt_u32 value
 *
 * @retval TRUE -> sucesso
 */
PRIVATE bool write_reg(alt_u32 offset, alt_u32 value)
{
	alt_u32 *p_addr = (alt_u32 *) SYNC_BASE_ADDR;
	*(p_addr + offset) = (alt_u32) value;
	return  TRUE;
}

/**
 * @name    read_reg
 * @brief
 * @ingroup sync
 *
 * Read 32 bits reg
 *
 * @param [in] alt_u32 offset
  *
 * @retval alt_u32 value -> reg
 */
PRIVATE alt_u32 read_reg(alt_u32 offset)
{
	alt_u32 value;

    alt_u32 *p_addr = (alt_u32 *) SYNC_BASE_ADDR;
 	value = *(p_addr + (alt_u32)offset);
	return value;
}
//! [private functions]

