/*
 * configs_simucam.c
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */


#include "configs_simucam.h"


/*Configuration related to the eth connection*/
TConfEth xConfEth;


bool vLoadDefaultETHConf( void ){
	short int siFile, sidhcpTemp;
	bool bSuccess = FALSE;
	bool bEOF = FALSE;
	bool close = FALSE;
	unsigned char ucParser;
	char c, *p_inteiro;
	char inteiro[8];


	if ( (xSdHandle.connected == TRUE) && (bSDcardIsPresent()) && (bSDcardFAT16Check()) ){

		siFile = siOpenFile( ETH_FILE_NAME );

		if ( siFile >= 0 ){

			memset( &(inteiro) , 10 , sizeof( inteiro ) );
			p_inteiro = inteiro;

			do {
				c = cGetNextChar(siFile);
				//printf("%c \n", c);
				switch (c) {
					case 39:// single quote '
						c = cGetNextChar(siFile);
						while ( c != 39 ){
							c = cGetNextChar(siFile);
						}
						break;
					case -1: 	//EOF
						bEOF = TRUE;
						break;
					case -2: 	//EOF
						printf("Problem with SDCard");
						bEOF = TRUE;
						break;
					case 0x20: 	//ASCII: 0x20 = space
					case 10: 	//ASCII: 10 = LN
					case 13: 	//ASCII: 13 = CR
						break;
					case 'M':

						ucParser = 0;
						do {
							do {
								c = cGetNextChar(siFile);
								if ( isdigit( c ) ) {
									(*p_inteiro) = c;
									p_inteiro++;
								}
							} while ( (c !=58) && (c !=59) ); //ASCII: 58 = ':' 59 = ';'
							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
							/*Tiago: Proteger com mutex*/
							xConfEth.ucMAC[ucParser] = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'I':

						ucParser = 0;
						do {
							do {
								c = cGetNextChar(siFile);
								if ( isdigit( c ) ) {
									(*p_inteiro) = c;
									p_inteiro++;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'
							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
							/*Tiago: Proteger com mutex*/
							xConfEth.ucIP[min_sim(ucParser,3)] = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'G':

						ucParser = 0;
						do {
							do {
								c = cGetNextChar(siFile);
								if ( isdigit( c ) ) {
									(*p_inteiro) = c;
									p_inteiro++;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'
							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
							/*Tiago: Proteger com mutex*/
							xConfEth.ucGTW[min_sim(ucParser,3)] = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'S':

						ucParser = 0;
						do {
							do {
								c = cGetNextChar(siFile);
								if ( isdigit( c ) ) {
									(*p_inteiro) = c;
									p_inteiro++;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'
							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
							/*Tiago: Proteger com mutex*/
							xConfEth.ucSubNet[min_sim(ucParser,3)] = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'D':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
						/*Tiago: Proteger com mutex*/
						xConfEth.siPortDebug = atoi( inteiro );
						/*Tiago: Proteger com mutex*/
						p_inteiro = inteiro;

						break;
					case 'P':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
						/*Tiago: Proteger com mutex*/
						xConfEth.siPortPUS = atoi( inteiro );
						/*Tiago: Proteger com mutex*/
						p_inteiro = inteiro;

						break;
					case 'H':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
						/*Tiago: Proteger com mutex*/
						sidhcpTemp = atoi( inteiro );
						if (sidhcpTemp == 1)
							xConfEth.bDHCP = TRUE;
						else
							xConfEth.bDHCP = FALSE;
						/*Tiago: Proteger com mutex*/
						p_inteiro = inteiro;

						break;
					case 0x3C: //"<"
						close = siCloseFile(siFile);
						if (close == FALSE)
							printf("Problema em fechar o arquivo\n");

						/* End of Parser File */
						bEOF = TRUE;
						bSuccess = TRUE; //pensar melhor
						break;
					default:
						printf("Algum erro ocorreu na leitura do arquivo! c= %i \n", c);
						break;
				}
			} while ( bEOF == FALSE );
		} else printf("Não achou o arquivo - fopen fail\n");
	} else printf("Sem SDCard\n");

	/* Load the default configuration if not successful in read the SDCard */
	if ( bSuccess == FALSE ) {
		/*Enviar mensagem que e gravar log que não encontrou o arquivo e começara a utilizar o padrao*/
		printf("Atenção: Arquivo de conexão não foi encontrado. Carregando conf padrao\n");
		printf("Não encontrou:'%s'.\n", ETH_FILE_NAME);


		xConfEth.siPortDebug = 17003;
		xConfEth.siPortPUS = 17000;
		/*ucIP[0].ucIP[1].ucIP[2].ucIP[3]
		 *192.168.0.5*/
		xConfEth.ucIP[0] = 192;
		xConfEth.ucIP[1] = 168;
		xConfEth.ucIP[2] = 0;
		xConfEth.ucIP[3] = 5;

		/*ucGTW[0].ucGTW[1].ucGTW[2].ucGTW[3]
		 *192.168.0.1*/
		xConfEth.ucGTW[0] = 192;
		xConfEth.ucGTW[1] = 168;
		xConfEth.ucGTW[2] = 0;
		xConfEth.ucGTW[3] = 1;

		/*ucSubNet[0].ucSubNet[1].ucSubNet[2].ucSubNet[3]
		 *192.168.0.5*/
		xConfEth.ucSubNet[0] = 255;
		xConfEth.ucSubNet[1] = 255;
		xConfEth.ucSubNet[2] = 255;
		xConfEth.ucSubNet[3] = 0;


		/*ucMAC[0]:ucMAC[1]:ucMAC[2]:ucMAC[3]:ucMAC[4]:ucMAC[5]
		 *fc:f7:63:4d:1f:42*/
		xConfEth.ucMAC[0] = 0xFC;
		xConfEth.ucMAC[1] = 0xF7;
		xConfEth.ucMAC[2] = 0x63;
		xConfEth.ucMAC[3] = 0x4D;
		xConfEth.ucMAC[4] = 0x1F;
		xConfEth.ucMAC[5] = 0x42;

		xConfEth.bDHCP = FALSE;

	}

	return bSuccess;
}
