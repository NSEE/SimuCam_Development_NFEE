/*
 * configs_simucam.h
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#ifndef CONFIGS_BIND_CHANNEL_H_
#define CONFIGS_BIND_CHANNEL_H_

#include "../simucam_definitions.h"
#include "sdcard_file_manager.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <sys/alt_stdio.h>


#define SPW_FILE_NAME "DEF/FEE"


typedef struct DefaultsCH{
	unsigned char ucChannelToFEE[8];
	unsigned char ucFEEtoChanell[8];
}TDefaultsCH;


extern TDefaultsCH xDefaultsCH;


/*Functions*/
bool vCHConfs( void );

#endif
