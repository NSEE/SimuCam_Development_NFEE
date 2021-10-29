/**
 * @file   ctrl_io_lvds.c
 * @Author Cassio Berni (ccberni@hotmail.com)
 * @date   Outubro, 2018
 * @brief  Source File para controle dos i/o큦 lvds (placa drivers_lvds e iso_simucam) via Avalon
 *
 */

#include "ctrl_io_lvds.h"

//! [private function prototypes]
static bool bCtrlIoLvdsDrive(bool bOnOff, alt_u8 ucMask);
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
static alt_u8 ucIoValue = 0x04;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bEnableIsoDrivers(void) {
	bCtrlIoLvdsDrive(LVDS_IO_ON, LVDS_EN_ISO_DRIVERS_MSK);
	return TRUE;
}

bool bDisableIsoDrivers(void) {
	bCtrlIoLvdsDrive(LVDS_IO_OFF, LVDS_EN_ISO_DRIVERS_MSK);
	return TRUE;
}

bool bEnableLvdsBoard(void) {
	bCtrlIoLvdsDrive(LVDS_IO_ON, LVDS_PWDN_MSK);
	return TRUE;
}

bool bDisableLvdsBoard(void) {
	bCtrlIoLvdsDrive(LVDS_IO_OFF, LVDS_PWDN_MSK);
	return TRUE;
}

bool bSetPreEmphasys(alt_u8 ucPemLevel) {
	switch (ucPemLevel) {
	case LVDS_PEM_OFF:
		bCtrlIoLvdsDrive(LVDS_IO_OFF, LVDS_PEM1_MSK | LVDS_PEM0_MSK);
		break;
	case LVDS_PEM_LO:
		bCtrlIoLvdsDrive(LVDS_IO_OFF, LVDS_PEM1_MSK);
		bCtrlIoLvdsDrive(LVDS_IO_ON, LVDS_PEM0_MSK);
		break;
	case LVDS_PEM_MID:
		bCtrlIoLvdsDrive(LVDS_IO_OFF, LVDS_PEM0_MSK);
		bCtrlIoLvdsDrive(LVDS_IO_ON, LVDS_PEM1_MSK);
		break;
	case LVDS_PEM_HI:
		bCtrlIoLvdsDrive(LVDS_IO_ON, LVDS_PEM1_MSK | LVDS_PEM0_MSK);
		break;
	default:
		break;
	}
	return TRUE;
}

bool bEnableIsoLogic(void) {
	bool bStatus = FALSE;

	IOWR_ALTERA_AVALON_PIO_DATA(PIO_ISO_LOGIC_SIGNAL_ENABLE_BASE, 0x00000001);

	return (bStatus);
}

bool bDisableIsoLogic(void) {
	bool bStatus = FALSE;

	IOWR_ALTERA_AVALON_PIO_DATA(PIO_ISO_LOGIC_SIGNAL_ENABLE_BASE, 0x00000000);

	return (bStatus);
}
//! [public functions]

//! [private functions]
/**
 * @name    bCtrlIoLvdsDrive
 * @brief
 * @ingroup ctrl_io_lvds
 *
 * Ativa ('1') ou desativa ('0') os i/o큦 de controle lvds
 *
 * @param [in] on_off -> 0 = io큦 off / 1 = i/o큦 on
 * @param [in] ulliMask   -> mascara de i/o큦 a serem alterados
 *
 * @retval TRUE -> sucesso
 */
static bool bCtrlIoLvdsDrive(bool bOnOff, alt_u8 ucMask) {
	if (bOnOff == LVDS_IO_OFF) {
		ucIoValue &= (~ucMask);
	} else {
		ucIoValue |= ucMask;
	}
	IOWR_ALTERA_AVALON_PIO_DATA(LVDS_CTRL_IO_LVDS_ADDR_BASE, ucIoValue);
	return TRUE;
}
//! [private functions]
