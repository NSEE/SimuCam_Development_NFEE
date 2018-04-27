/*
 * eth.h
 *
 *  Created on: 24/04/2018
 *      Author: rfranca
 */

#ifndef ETH_H_
#define ETH_H_

	#include "system.h"
	#include "alt_types.h"

	#define ETH_RST_BASE PIO_RST_ETH_BASE

	void v_Eth_Hold_Reset(void);
	void v_Eth_Release_Reset(void);

#endif /* ETH_H_ */
