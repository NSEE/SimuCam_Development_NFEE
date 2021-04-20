/*
 * sdcard_file_manager.c
 *
 *  Created on: 23/11/2018
 *      Author: Tiago-Low
 */

#include "sdcard_file_manager.h"


TSDHandle xSdHandle;

bool bSDcardIsPresent( void ){
//	return alt_up_sd_card_is_Present();
	return (FALSE);
}

bool bSDcardFAT16Check( void ){
//	return alt_up_sd_card_is_FAT16();
	return (FALSE);
}

bool bInitializeSDCard( void ){
	bool bSucess = FALSE;
	xSdHandle.deviceHandle = NULL;

//	xSdHandle.deviceHandle = alt_up_sd_card_open_dev(ALTERA_UP_SD_CARD_AVALON_INTERFACE_0_NAME);
	if ( xSdHandle.deviceHandle != NULL ) {

		bSucess = bSDcardIsPresent();
		if ( bSucess ) {
			bSucess = bSDcardFAT16Check();
			if ( bSucess ) {
				xSdHandle.connected = TRUE;
				#if DEBUG_ON
					debug(fp, "SD is up.\r\n");
				#endif

			} else {
				/* SD isn't in FAT16 format*/
				#if DEBUG_ON
					debug(fp, "SD Card should be formated in FAT16.\r\n");
				#endif
			}
		} else {
			/* There's no SDCard in the slot */
			#if DEBUG_ON
				debug(fp, "There is no SD in the slot.\r\n");
			#endif
		}

	} else {
		/* Unable to open the SDCard device. */
		bSucess = FALSE;
		#if DEBUG_ON
			debug(fp, "Unable to open the SDCard device.\r\n");
		#endif
	}

	return bSucess;
}

short int siOpenFile( char *filename ) {
//	return alt_up_sd_card_fopen( filename, FALSE );
	return (FALSE);
}

bool siCloseFile( short int file_handle ) {
//	return alt_up_sd_card_fclose( file_handle );
	return (FALSE);
}

char cGetNextChar( short int file_handle ) {
//	return (char)alt_up_sd_card_read( file_handle );
	return ('\0');
}
