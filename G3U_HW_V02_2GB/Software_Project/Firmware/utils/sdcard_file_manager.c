/*
 * sdcard_file_manager.c
 *
 *  Created on: 23/11/2018
 *      Author: Tiago-Low
 */

#include "sdcard_file_manager.h"


TSDHandle xSdHandle;

bool bSDcardIsPresent( void ){
	return alt_up_sd_card_is_Present();
}

bool bSDcardFAT16Check( void ){
	return alt_up_sd_card_is_FAT16();
}

bool bInitializeSDCard( void ){
	bool bSucess = FALSE;
	xSdHandle.deviceHandle = NULL;

	xSdHandle.deviceHandle = alt_up_sd_card_open_dev(ALTERA_UP_SD_CARD_AVALON_INTERFACE_0_NAME);
	if ( xSdHandle.deviceHandle != NULL ) {

		bSucess = bSDcardIsPresent();
		if ( bSucess ) {
			bSucess = bSDcardFAT16Check();
			if ( bSucess ) {
				xSdHandle.connected = TRUE;
				printf("Conectado");
			} else {
				/* O SDCard não é um FAT 16, enviar mensagem informando. */
				printf("Não é fat 16");
			}
		} else {
			/* Enviar mensagem que precisa inserir um SDCARD */
			printf("Não tem sdcard");
		}

	} else {
		/* Não foi possivel instanciar, problema de comunicação com o SDCard. */
		bSucess = FALSE;
		printf("Não deu nao");
	}

	return bSucess;
}

/*Function with low performance, avoid to use as much as possible*/
char cGetCharbyIndex( short int file_handle, unsigned int positionByte ) {
	short int readCharacter;
	vSetBytePosition(file_handle, positionByte);
	readCharacter = alt_up_sd_card_read(file_handle);
	if ( readCharacter < 0 ) {
		readCharacter = -1;
	}
	return (char)readCharacter;
}

short int siOpenFile( char *filename ) {
	return alt_up_sd_card_fopen(filename, false);
}

char cGetNextChar( short int file_handle ) {
	return (char)alt_up_sd_card_read(file_handle);
}

unsigned int uiGetEOFPointer( short int file_handle ) {
	vSetBytePosition(file_handle,0);
	while ( alt_up_sd_card_read(file_handle) > 0 ) {;}

	return uiGetBytePosition(file_handle);
}

//ReadLine?

//WriteLine?


void vJustAWriteTest( void ) {

	short int sdFile = 0;
	char buffer[SD_BUFFER_SIZE] = "Avenida Tiete 22222 \r\n\0";

	printf(" Verificando sd ");
	if ( xSdHandle.connected ) {
		printf(" Acessando/criando o arquivo de teste\r\n");
		sdFile = alt_up_sd_card_fopen("FI2.TXT", false);

		if ( sdFile >= 0 ) {
			int index = 0;
			while (buffer[index] != '\0')
			{
			  alt_up_sd_card_write(sdFile, buffer[index]);
			  index = index + 1;
			}
			printf(" Teoricamente deu certo ... \r\n");
			 alt_up_sd_card_fclose(sdFile);
		} else {
			printf(" Falhou, culpa do ...  %i\r\n", sdFile);
		}
	}

}
