/*
 * eth.c
 *
 *  Created on: 24/04/2018
 *      Author: rfranca
 */

	#include "eth.h"

	void v_Eth_Hold_Reset(void){

		alt_u32 *pEthAddr = (alt_u32 *)ETH_RST_BASE;
		*pEthAddr = (alt_u32) 0x00000000;

	}

	void v_Eth_Release_Reset(void){

		alt_u32 *pEthAddr = (alt_u32 *)ETH_RST_BASE;
		*pEthAddr = (alt_u32) 0x00000001;

	}
