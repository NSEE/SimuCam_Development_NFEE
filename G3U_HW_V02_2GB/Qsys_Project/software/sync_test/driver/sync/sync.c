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
PUBLIC int n;
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
PRIVATE volatile int hold_context;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

/**
 * @name    handle_irq
 * @brief
 * @ingroup sync
 *
 * Handle interrupt from sync ip
 * The value stored in *context is used to control program flow
 * in the rest of this program's routines
 *
 * @param [in] void* context
 *
 * @retval void
 */
PUBLIC void handle_irq(void* context)
{
    // Cast context to hold_context's type. It is important that this be 
    // declared volatile to avoid unwanted compiler optimization.
    volatile int* hold_context_ptr = (volatile int*) context;
    // Use context value according to your app logic...
    //*hold_context_ptr = ...;
    // if (*hold_context_ptr == '0') {}...
    // App logic sequence...
    n++;
}

/**
 * @name    init_interrupt
 * @brief
 * @ingroup sync
 *
 * Make interrupt initialization
 *
 * @param [in] void
 *
 * @retval void
 */
PUBLIC void init_interrupt(void)
{
    // Recast the hold_context pointer to match the alt_irq_register() function
    // prototype.
    void* hold_context_ptr = (void*) &hold_context;
    // Register the interrupt handler
    alt_irq_register(SYNC_IRQ, hold_context_ptr, handle_irq);
}

// Status reg
/**
 * @name    sync_status_extn_int
 * @brief
 * @ingroup sync
 *
 * Read bit extn_int of status reg (0 -> ext. sync / 1 -> int. sync)
 *
 * @param [in] void
 *
 * @retval bool result
 */
PUBLIC bool sync_status_extn_int(void)
{
	alt_u32 aux;
	bool result;

	aux = read_reg(SYNC_STATUS_REG_OFFSET);

	if (aux & STATUS_EXTN_INT_MASK) {
		result = TRUE;
	}
	else {
		result = FALSE;
	}
	return result;
}

/**
 * @name    sync_status_state
 * @brief
 * @ingroup sync
 *
 * Read state byte of status reg (0 -> idle / 1 -> running / 2 -> one shot / 3 -> err_inj)
 *
 * @param [in] void
 *
 * @retval alt_u8 result
 */
PUBLIC alt_u8 sync_status_state(void)
{
	alt_u32 aux;
	alt_u8 result;

	aux = read_reg(SYNC_STATUS_REG_OFFSET);
	result = (alt_u8) ((aux & STATUS_STATE_MASK) >> 16);
	return result;
}

/**
 * @name    sync_status_error_code
 * @brief
 * @ingroup sync
 *
 * Read error code byte of status reg (0..255 -> TBD)
 *
 * @param [in] void
 *
 * @retval alt_u8 result
 */
PUBLIC alt_u8 sync_status_error_code(void)
{
	alt_u32 aux;
	alt_u8 result;

	aux = read_reg(SYNC_STATUS_REG_OFFSET);
	result = (alt_u8) ((aux & STATUS_ERROR_CODE_MASK) >> 8);
	return result;
}

/**
 * @name    sync_status_cycle_number
 * @brief
 * @ingroup sync
 *
 * Read cycle number byte of status reg (0..255, tipically 0..3 (four cycles) for N-FEE, or 0 (one cycle) for F-FEE)
 *
 * @param [in] void
 *
 * @retval alt_u8 result
 */
PUBLIC alt_u8 sync_status_cycle_number(void)
{
	alt_u32 aux;
	alt_u8 result;

	aux = read_reg(SYNC_STATUS_REG_OFFSET);
	result = (alt_u8) ((aux & STATUS_CYCLE_NUMBER_MASK) >> 0);
	return result;
}

// Config regs
/**
 * @name    sync_config_mbt
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into master blank time register (pulse duration = value * 20 ns)
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_config_mbt(alt_u32 value)
{
	write_reg(SYNC_CONFIG_MBT_REG_OFFSET, value);
 	return  TRUE;
}

/**
 * @name    sync_config_bt
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into blank time register (pulse duration = value * 20 ns)
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_config_bt(alt_u32 value)
{
	write_reg(SYNC_CONFIG_BT_REG_OFFSET, value);
 	return  TRUE;
}

/**
 * @name    sync_config_per
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into period register (period duration =  value * 20 ns)
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_config_per(alt_u32 value)
{
	write_reg(SYNC_CONFIG_PER_REG_OFFSET, value);
 	return  TRUE;
}

/**
 * @name    sync_config_ost
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into one shot time register (pulse duration =  value * 20 ns)
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_config_ost(alt_u32 value)
{
	write_reg(SYNC_CONFIG_OST_REG_OFFSET, value);
 	return  TRUE;
}

/**
 * @name    sync_config_polarity
 * @brief
 * @ingroup sync
 *
 * Write a bool value into polarity bit of general config register (value defines the level of blank pulses)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

/**
 * @name    sync_config_n_cycles
 * @brief
 * @ingroup sync
 *
 * Write an alt_u8 value into n_cycles field of general config register.
 * This field defines the number of cycles of a "major cycle".
 * '0' is allowed, but it´s equivalent to '1'.
 *
 * @param [in] alt_u8 value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_config_n_cycles(alt_u8 value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CONFIG_GENERAL_REG_OFFSET);
	aux &= ~CONFIG_GENERAL_N_CYCLES_MASK;
	aux |= (alt_u32) value;

	write_reg(SYNC_CONFIG_GENERAL_REG_OFFSET, aux);
 	return  TRUE;
}

/**
 * @name    sync_read_config_mbt
 * @brief
 * @ingroup sync
 *
 * Read mbt config register.
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
PUBLIC alt_u32 sync_read_config_mbt(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CONFIG_MBT_REG_OFFSET);
 	return  aux;
}

/**
 * @name    sync_read_config_bt
 * @brief
 * @ingroup sync
 *
 * Read bt config register.
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
PUBLIC alt_u32 sync_read_config_bt(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CONFIG_BT_REG_OFFSET);
 	return  aux;
}

/**
 * @name    sync_read_config_per
 * @brief
 * @ingroup sync
 *
 * Read per config register.
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
PUBLIC alt_u32 sync_read_config_per(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CONFIG_PER_REG_OFFSET);
 	return  aux;
}

/**
 * @name    sync_read_config_ost
 * @brief
 * @ingroup sync
 *
 * Read ost config register.
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
PUBLIC alt_u32 sync_read_config_ost(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CONFIG_OST_REG_OFFSET);
 	return  aux;
}

/**
 * @name    sync_read_config_general
 * @brief
 * @ingroup sync
 *
 * Read general config register.
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
PUBLIC alt_u32 sync_read_config_general(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CONFIG_GENERAL_REG_OFFSET);
 	return  aux;
}

// Error injection reg
/**
 * @name    sync_err_inj
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into error injection register.
 * Utilization: TBD
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_err_inj(alt_u32 value)
{
	write_reg(SYNC_ERR_INJ_REG_OFFSET, value);
 	return  TRUE;
}

// Control reg
/**
 * @name    sync_ctr_extn_int
 * @brief
 * @ingroup sync
 *
 * Write a bool value into extn_int bit of control register (0 -> ext. sync / 1 -> int. sync)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_ctr_extn_int(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~CTR_EXTN_INT_MASK;
	}
	else {
	aux |= CTR_EXTN_INT_MASK;
	}

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

/**
 * @name    sync_ctr_start
 * @brief
 * @ingroup sync
 *
 * Generate a start command by setting start bit of control register (1 -> start, auto return to zero)
 * Sync ip will be taken from idle to running state
 *
 * @param [in] void
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_ctr_start(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	aux |= CTR_START_MASK;

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

/**
 * @name    sync_ctr_reset
 * @brief
 * @ingroup sync
 *
 * Generate a reset command by setting reset bit of control register (1 -> reset, auto return to zero)
 * Sync ip will be taken from any state to idle state
 *
 * @param [in] void
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_ctr_reset(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	aux |= CTR_RESET_MASK;

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

/**
 * @name    sync_ctr_one_shot
 * @brief
 * @ingroup sync
 *
 * Generate a one_shot command by setting one_shot bit of control register (1 -> one_shot, auto return to zero)
 * Sync ip will be taken from idle state to one_shot state
 *
 * @param [in] void
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_ctr_one_shot(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	aux |= CTR_ONE_SHOT_MASK;

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

/**
 * @name    sync_ctr_err_inj
 * @brief
 * @ingroup sync
 *
 * Generate a err_inj command by setting err_inj bit of control register (1 -> err_inj, auto return to zero)
 * Sync ip will be taken from idle state to error injection state
 *
 * @param [in] void
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_ctr_err_inj(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);

	aux |= CTR_ERR_INJ_MASK;

	write_reg(SYNC_CTR_REG_OFFSET, aux);
 	return  TRUE;
}

/**
 * @name    sync_ctr_sync_out_enable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into sync_out enable bit of control register (0 -> sync_out disable / 1 -> sync_out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

/**
 * @name    sync_ctr_cha_out_enable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into cha_out enable bit of control register (0 -> ch A sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

/**
 * @name    sync_ctr_chb_out_enable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chb_out enable bit of control register (0 -> ch B sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

/**
 * @name    sync_ctr_chc_out_enable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chc_out enable bit of control register (0 -> ch C sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

/**
 * @name    sync_ctr_chd_out_enable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chd_out enable bit of control register (0 -> ch D sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

/**
 * @name    sync_ctr_che_out_enable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into che_out enable bit of control register (0 -> ch E sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

/**
 * @name    sync_ctr_chf_out_enable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chf_out enable bit of control register (0 -> ch F sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

/**
 * @name    sync_ctr_chg_out_enable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chg_out enable bit of control register (0 -> ch G sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

/**
 * @name    sync_ctr_chh_out_enable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chh_out enable bit of control register (0 -> ch H sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
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

// Int enable register
/**
 * @name    sync_int_enable_error
 * @brief
 * @ingroup sync
 *
 * Write a bool value into int error enable bit of int enable register (0 -> int error disable / 1 -> int error enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_int_enable_error(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_INT_ENABLE_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~INT_ENABLE_ERROR_MASK;
	}
	else {
	aux |= INT_ENABLE_ERROR_MASK;
	}

	write_reg(SYNC_INT_ENABLE_REG_OFFSET, aux);
 	return  TRUE;
}

/**
 * @name    sync_int_enable_blank
 * @brief
 * @ingroup sync
 *
 * Write a bool value into int blank enable bit of int enable register (0 -> int blank disable / 1 -> int blank enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_int_enable_blank(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_INT_ENABLE_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~INT_ENABLE_BLANK_MASK;
	}
	else {
	aux |= INT_ENABLE_BLANK_MASK;
	}

	write_reg(SYNC_INT_ENABLE_REG_OFFSET, aux);
 	return  TRUE;
}

// Int flag clear register
/**
 * @name    sync_int_flag_clear_error
 * @brief
 * @ingroup sync
 *
 * Write a bool value into error bit of int flag clear register (0 -> keep int error flag unchanged / 1 -> clear int error flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_int_flag_clear_error(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_INT_FLAG_CLEAR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~INT_FLAG_CLEAR_ERROR_MASK;
	}
	else {
	aux |= INT_FLAG_CLEAR_ERROR_MASK;
	}

	write_reg(SYNC_INT_FLAG_CLEAR_REG_OFFSET, aux);
 	return  TRUE;
}

/**
 * @name    sync_int_flag_clear_blank
 * @brief
 * @ingroup sync
 *
 * Write a bool value into blank bit of int flag clear register (0 -> keep int blank flag unchanged / 1 -> clear int blank flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
PUBLIC bool sync_int_flag_clear_blank(bool value)
{
	alt_u32 aux;

	aux = read_reg(SYNC_INT_FLAG_CLEAR_REG_OFFSET);

	if (value == BIT_OFF) {
	aux &= ~INT_FLAG_CLEAR_BLANK_MASK;
	}
	else {
	aux |= INT_FLAG_CLEAR_BLANK_MASK;
	}

	write_reg(SYNC_INT_FLAG_CLEAR_REG_OFFSET, aux);
 	return  TRUE;
}

// Int flag reg
/**
 * @name    sync_int_flag_error
 * @brief
 * @ingroup sync
 *
 * Read int error flag bit of int flag reg (0 -> no error int. occured / 1 -> error int. occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
PUBLIC bool sync_int_flag_error(void)
{
	alt_u32 aux;
	bool result;

	aux = read_reg(SYNC_INT_FLAG_REG_OFFSET);

	if (aux & INT_FLAG_ERROR_MASK) {
		result = TRUE;
	}
	else {
		result = FALSE;
	}
	return result;
}

/**
 * @name    sync_int_flag_blank
 * @brief
 * @ingroup sync
 *
 * Read int blank flag bit of int flag reg (0 -> no int blank occured / 1 -> int error occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
PUBLIC bool sync_int_flag_blank(void)
{
	alt_u32 aux;
	bool result;

	aux = read_reg(SYNC_INT_FLAG_REG_OFFSET);

	if (aux & INT_FLAG_BLANK_MASK) {
		result = TRUE;
	}
	else {
		result = FALSE;
	}
	return result;
}

/**
 * @name    sync_read_ctr
 * @brief
 * @ingroup sync
 *
 * Read control reg
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
PUBLIC alt_u32 sync_read_ctr(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_CTR_REG_OFFSET);
	return aux;
}

/**
 * @name    sync_read_status
 * @brief
 * @ingroup sync
 *
 * Read status reg
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
PUBLIC alt_u32 sync_read_status(void)
{
	alt_u32 aux;

	aux = read_reg(SYNC_STATUS_REG_OFFSET);
	return aux;
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
 * @retval TRUE -> success
 */
PRIVATE bool write_reg(alt_u32 offset, alt_u32 value)
{
	alt_u32 *p_addr = (alt_u32 *) SYNC_BASE_ADDR;
	*(p_addr + offset) = value;
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
 	value = *(p_addr + offset);
	return value;
}
//! [private functions]

