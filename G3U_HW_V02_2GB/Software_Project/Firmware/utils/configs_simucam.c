/*
 * configs_simucam.c
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */


#include "configs_simucam.h"


/*Configuration related to the eth connection*/
TConfEth xConfEth;
TDefaults xDefaults;


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
						#ifdef DEBUG_ON
							debug(fp,"SDCard: Problem with SDCard");
						#endif
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
							xConfEth.ucMAC[min_sim(ucParser,5)] = atoi( inteiro );
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
					case 'H':

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
							xConfEth.ucDNS[min_sim(ucParser,3)] = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;						
					case 0x3C: //"<"
						close = siCloseFile(siFile);
						if (close == FALSE){
							#ifdef DEBUG_ON
								debug(fp,"SDCard: Can't close the file.\n");
							#endif
						}
						/* End of Parser File */
						bEOF = TRUE;
						bSuccess = TRUE; //pensar melhor
						break;
					default:
						#ifdef DEBUG_ON
							fprintf(fp,"SDCard: Problem with the parser.\n");
						#endif
						break;
				}
			} while ( bEOF == FALSE );
		} else {
			#ifdef DEBUG_ON
				fprintf(fp,"SDCard: File not found.\n");
			#endif
		}
	} else {
		#ifdef DEBUG_ON
			fprintf(fp,"SDCard: No SDCard.\n");
		#endif
	}
	/* Load the default configuration if not successful in read the SDCard */
	if ( bSuccess == FALSE ) {
		/*Enviar mensagem que e gravar log que n�o encontrou o arquivo e come�ara a utilizar o padrao*/
		printf("Aten��o: Arquivo de conex�o n�o foi encontrado. Carregando conf padrao\n");
		printf("N�o encontrou:'%s'.\n", ETH_FILE_NAME);


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

#ifdef DEBUG_ON
	void vShowEthConfig( void ) {
		char buffer[40];

		debug(fp, "Ethernet loaded configuration.\n");

		memset(buffer,0,40);
		sprintf(buffer, "MAC: %x : %x : %x : %x : %x : %x \n", xConfEth.ucMAC[0], xConfEth.ucMAC[1], xConfEth.ucMAC[2], xConfEth.ucMAC[3], xConfEth.ucMAC[4], xConfEth.ucMAC[5]);
		debug(fp, buffer );

		memset(buffer,0,40);
		sprintf(buffer, "IP: %i . %i . %i . %i \n",xConfEth.ucIP[0], xConfEth.ucIP[1], xConfEth.ucIP[2], xConfEth.ucIP[3] );
		debug(fp, buffer );

		memset(buffer,0,40);
		sprintf(buffer, "GTW: %i . %i . %i . %i \n",xConfEth.ucGTW[0], xConfEth.ucGTW[1], xConfEth.ucGTW[2], xConfEth.ucGTW[3] );
		debug(fp, buffer );

		memset(buffer,0,40);
		sprintf(buffer, "Sub: %i . %i . %i . %i \n",xConfEth.ucSubNet[0], xConfEth.ucSubNet[1], xConfEth.ucSubNet[2], xConfEth.ucSubNet[3] );
		debug(fp, buffer );

		memset(buffer,0,40);
		sprintf(buffer, "DNS: %i . %i . %i . %i \n",xConfEth.ucDNS[0], xConfEth.ucDNS[1], xConfEth.ucDNS[2], xConfEth.ucDNS[3] );
		debug(fp, buffer );

		memset(buffer,0,40);
		sprintf(buffer, "Porta PUS: %i\n", xConfEth.siPortPUS );
		debug(fp, buffer );

	}
#endif










bool vLoadDebugConfs( void ){
	short int siFile, sidhcpTemp;
	bool bSuccess = FALSE;
	bool bEOF = FALSE;
	bool close = FALSE;
	unsigned char ucParser;
	char c, *p_inteiro;
	char inteiro[8];


	if ( (xSdHandle.connected == TRUE) && (bSDcardIsPresent()) && (bSDcardFAT16Check()) ){

		siFile = siOpenFile( DEBUG_FILE_NAME );

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
						#ifdef DEBUG_ON
							debug(fp,"SDCard: Problem with SDCard");
						#endif
						bEOF = TRUE;
						break;
					case 0x20: 	//ASCII: 0x20 = space
					case 10: 	//ASCII: 10 = LN
					case 13: 	//ASCII: 13 = CR
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
							xDefaults.usiSyncPeriod = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'P':
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
							xDefaults.usiPreScanSerial = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'N':
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
							xDefaults.usiOverScanSerial = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'L':
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
							xDefaults.usiRows = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;

					case 'O':
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
							xDefaults.usiOLN = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'C':
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
							xDefaults.usiCols = atoi( inteiro );
							/*Tiago: Proteger com mutex*/
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'H':

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
							xDefaults.HK[min_sim(ucParser,15)] = atoi( inteiro );
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
						xDefaults.usiDelay = atoi( inteiro );
						/*Tiago: Proteger com mutex*/
						p_inteiro = inteiro;

						break;
					case 'K':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
						/*Tiago: Proteger com mutex*/
						xDefaults.ulColDelay = atoi( inteiro );
						/*Tiago: Proteger com mutex*/
						p_inteiro = inteiro;

						break;
					case 'M':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
						/*Tiago: Proteger com mutex*/
						xDefaults.ulADCPixelDelay = atoi( inteiro );
						/*Tiago: Proteger com mutex*/
						p_inteiro = inteiro;

						break;
					case 'J':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
						/*Tiago: Proteger com mutex*/
						xDefaults.ulLineDelay = atoi( inteiro );
						/*Tiago: Proteger com mutex*/
						p_inteiro = inteiro;

						break;
					case 'T':

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
							xDefaults.bDataPacket = TRUE;
						else
							xDefaults.bDataPacket = FALSE;
						/*Tiago: Proteger com mutex*/
						p_inteiro = inteiro;

						break;
					case 0x3C: //"<"
						close = siCloseFile(siFile);
						if (close == FALSE){
							#ifdef DEBUG_ON
								debug(fp,"SDCard: Can't close the file.\n");
							#endif
						}
						/* End of Parser File */
						bEOF = TRUE;
						bSuccess = TRUE; //pensar melhor
						break;
					default:
						#ifdef DEBUG_ON
							fprintf(fp,"SDCard: Problem with the parser.\n");
						#endif
						break;
				}
			} while ( bEOF == FALSE );
		} else {
			#ifdef DEBUG_ON
				fprintf(fp,"SDCard: File not found.\n");
			#endif
		}
	} else {
		#ifdef DEBUG_ON
			fprintf(fp,"SDCard: No SDCard.\n");
		#endif
	}
	/* Load the default configuration if not successful in read the SDCard */
	if ( bSuccess == FALSE ) {
		/*Enviar mensagem que e gravar log que n�o encontrou o arquivo e come�ara a utilizar o padrao*/
		printf("Debug Configs: Could not load the default values from SDCard\n");
		printf("Can't find the file:'%s'.\n", ETH_FILE_NAME);



		xDefaults.usiRows = 4510;
		xDefaults.usiCols = 2255;
		xDefaults.usiOLN = 30;
		xDefaults.usiPreScanSerial = 25;
		xDefaults.usiOverScanSerial = 15;
		xDefaults.usiSyncPeriod = 6250;
		xDefaults.usiDelay = 20;
		xDefaults.bDataPacket = TRUE;
		xDefaults.ulLineDelay = 0;
		xDefaults.ulColDelay = 0;
		xDefaults.ulADCPixelDelay = 0;

	}

	return bSuccess;
}


