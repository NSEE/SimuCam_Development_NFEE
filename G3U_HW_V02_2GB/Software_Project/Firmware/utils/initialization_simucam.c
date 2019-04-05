/*
 * initialization_simucam.c
 *
 *  Created on: 20/10/2018
 *      Author: TiagoLow
 */

#include "initialization_simucam.h"


void vInitSimucamBasicHW(void)
{

	/* Turn Off all LEDs */
	bSetBoardLeds(LEDS_OFF, LEDS_BOARD_ALL_MASK);
	bSetPainelLeds(LEDS_OFF, LEDS_PAINEL_ALL_MASK);

	/* Turn On Power LED */
	bSetPainelLeds(LEDS_ON, LEDS_POWER_MASK);

	/* Configure Seven Segments Display */
	bSSDisplayConfig(SSDP_NORMAL_MODE);
	bSSDisplayUpdate(0);

	vRstcHoldDeviceReset(RSTC_DEV_RS232_RST_CTRL_MSK);
	vRstcReleaseDeviceReset(RSTC_DEV_RS232_RST_CTRL_MSK);

	bDisableIsoDrivers();
	bDisableLvdsBoard();

	/* Turn on all Panel Leds */
	bSetPainelLeds( LEDS_ON, LEDS_PAINEL_ALL_MASK );
	//usleep(5000000);
	/* initial values for the Leds */
	bSetPainelLeds( LEDS_OFF, LEDS_PAINEL_ALL_MASK );

	bSetPainelLeds( LEDS_ON, LEDS_R_ALL_MASK | LEDS_POWER_MASK );

}
