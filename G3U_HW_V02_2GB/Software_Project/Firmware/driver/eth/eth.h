/*
 * eth.h
 *
 *  Created on: 24/04/2018
 *      Author: rfranca
 */

#ifndef ETH_H_
#define ETH_H_

#include "../../simucam_defs_vars_structs_includes.h"

#define ETH_RST_BASE PIO_RST_ETH_BASE

void vEthHoldReset(void);
void vEthReleaseReset(void);

#endif /* ETH_H_ */
