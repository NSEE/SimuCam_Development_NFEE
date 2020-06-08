/*
 * sdcard_file_manager.h
 *
 *  Created on: 23/11/2018
 *      Author: Tiago-Low
 */

#ifndef SDCARD_FILE_MANAGER_H_
#define SDCARD_FILE_MANAGER_H_


#include "../simucam_definitions.h"



typedef struct SDHandle{
	bool connected;
	alt_up_sd_card_dev *deviceHandle;
}TSDHandle;

extern TSDHandle xSdHandle;


#define SD_BUFFER_SIZE 512

bool bInitializeSDCard( void );
bool bSDcardIsPresent( void );
bool bSDcardFAT16Check( void );
char cGetCharbyIndex( short int file_handle, unsigned int positionByte );
short int siOpenFile( char *filename );
char cGetNextChar( short int file_handle );
unsigned int uiGetEOFPointer( short int file_handle );
bool siCloseFile( short int file_handle );




#endif /* SDCARD_FILE_MANAGER_H_ */
