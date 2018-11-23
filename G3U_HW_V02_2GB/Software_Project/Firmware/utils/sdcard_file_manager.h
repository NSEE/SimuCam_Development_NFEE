/*
 * sdcard_file_manager.h
 *
 *  Created on: 23/11/2018
 *      Author: Tiago-Low
 */

#ifndef SDCARD_FILE_MANAGER_H_
#define SDCARD_FILE_MANAGER_H_

#include "meb_includes.h"
#include <altera_up_sd_card_avalon_interface.h>


typedef struct SDHandle{
	unsigned int connected;
	alt_up_sd_card_dev *deviceHandle;
}TSDHandle;

bool bInitializeSDCard( void );
void vJustAWriteTest( void );

#endif /* SDCARD_FILE_MANAGER_H_ */
