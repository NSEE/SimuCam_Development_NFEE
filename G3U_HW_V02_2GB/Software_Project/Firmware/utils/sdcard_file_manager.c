/*
 * sdcard_file_manager.c
 *
 *  Created on: 23/11/2018
 *      Author: Tiago-Low
 */

#include "sdcard_file_manager"


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

	bSucess = bSDcardIsPresent();
	if ( bSucess ) {
		bSucess = bSDcardFAT16Check();
		if ( bSucess ) {
			xSdHandle.deviceHandle = alt_up_sd_card_open_dev("ALTERA_UP_SD_CARD_AVALON_INTERFACE_0_NAME");
			if ( xSdHandle.deviceHandle != NULL ) {
				xSdHandle.connected = TRUE;
			} else {
				/* Não foi possivel instanciar, problema de comunicação com o SDCard. */
				bSucess = FALSE;
			}
		} else {
			/* O SDCard não é um FAT 16, enviar mensagem informando. */
			printf("Não é fat 16");
		}
	} else {
		/* Enviar mensagem que precisa inserir um SDCARD */
		printf("Não tem sdcard");
	}

	return bSucess;
}


void vJustAWriteTest( void ) {

	short int sdFile;
	char buffer[SD_BUFFER_SIZE] = "O Class quer o peixe mas está de olho no gato!!\r\n\0";

	printf(" Verificando sd ");
	if ( xSdHandle.connected ) {
		printf(" Acessando/criando o arquivo de teste ");
		sdFile = alt_up_sd_card_fopen("file.txt", TRUE);

		if ( sdFile >= 0 ) {
			short int index = 0;
			while (buffer[index] != '\0')
			{
			  alt_up_sd_card_write(sdFile, buffer[index]);
			  index = index + 1;
			}
			printf(" Teoricamente deu certo ... ");
		} else {
			printf(" Falhou, culpa do ... ");
		}
	}

}
