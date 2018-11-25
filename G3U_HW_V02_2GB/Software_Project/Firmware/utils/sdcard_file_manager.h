/*
 * sdcard_file_manager.h
 *
 *  Created on: 23/11/2018
 *      Author: Tiago-Low
 */

#ifndef SDCARD_FILE_MANAGER_H_
#define SDCARD_FILE_MANAGER_H_

#include <altera_up_sd_card_avalon_interface.h>
#include "meb_includes.h"


typedef struct SDHandle{
	unsigned int connected;
	alt_up_sd_card_dev *deviceHandle;
}TSDHandle;

#define SD_BUFFER_SIZE 512

bool bInitializeSDCard( void );
void vJustAWriteTest( void );

#endif /* SDCARD_FILE_MANAGER_H_ */
