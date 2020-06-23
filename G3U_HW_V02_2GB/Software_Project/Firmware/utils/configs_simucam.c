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
TGlobal	xGlobal;


/* Load ETH configuration values from SD Card */
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
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							debug(fp,"SDCard: Problem with SDCard");
						}
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

							xConfEth.ucMAC[min_sim(ucParser,5)] = (unsigned char)atoi( inteiro );
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

							xConfEth.ucIP[min_sim(ucParser,3)] = (unsigned char)atoi( inteiro );
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

							xConfEth.ucGTW[min_sim(ucParser,3)] = (unsigned char)atoi( inteiro );
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'P':
						ucParser = 0;
						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfEth.siPortPUS = (unsigned short int)atoi( inteiro );
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

						sidhcpTemp = atoi( inteiro );
						if (sidhcpTemp == 1)
							xConfEth.bDHCP = TRUE;
						else
							xConfEth.bDHCP = FALSE;

						p_inteiro = inteiro;

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

							xConfEth.ucSubNet[min_sim(ucParser,3)] = (unsigned char)atoi( inteiro );
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

							xConfEth.ucDNS[min_sim(ucParser,3)] = (unsigned char)atoi( inteiro );
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;						
					case 0x3C: //"<"
						close = siCloseFile(siFile);
						if (close == FALSE){
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								debug(fp,"SDCard: Can't close the file.\n");
							}
							#endif
						}
						/* End of Parser File */
						bEOF = TRUE;
						bSuccess = TRUE; //todo: pensar melhor
						break;
					default:
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"SDCard: Problem with the parser.\n");
						}
						#endif
						break;
				}
			} while ( bEOF == FALSE );
		} else {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"SDCard: File not found.\n");
			}
			#endif
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			fprintf(fp,"SDCard: No SDCard.\n");
		}
		#endif
	}
	/* Load the default configuration if not successful in read the SDCard */
	if ( bSuccess == FALSE ) {

		/*ucMAC[0]:ucMAC[1]:ucMAC[2]:ucMAC[3]:ucMAC[4]:ucMAC[5]
		 *fc:f7:63:4d:1f:42*/
		xConfEth.ucMAC[0] = 0xFC;
		xConfEth.ucMAC[1] = 0xF7;
		xConfEth.ucMAC[2] = 0x63;
		xConfEth.ucMAC[3] = 0x4D;
		xConfEth.ucMAC[4] = 0x1F;
		xConfEth.ucMAC[5] = 0x42;

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
		 *255.255.255.0*/
		xConfEth.ucSubNet[0] = 255;
		xConfEth.ucSubNet[1] = 255;
		xConfEth.ucSubNet[2] = 255;
		xConfEth.ucSubNet[3] = 0;

		/*ucDNS[0].ucDNS[1].ucDNS[2].ucDNS[3]
		 *8.8.8.8*/
		xConfEth.ucDNS[0] = 8;
		xConfEth.ucDNS[1] = 8;
		xConfEth.ucDNS[2] = 8;
		xConfEth.ucDNS[3] = 8;

		xConfEth.siPortPUS = 17000;

		xConfEth.bDHCP = FALSE;
	}

	return bSuccess;
}

/* Load debug values from SD Card, only used during the development */
bool vLoadDebugConfs( void ){
	short int siFile, sidhcpTemp;
	bool bSuccess = FALSE;
	bool bEOF = FALSE;
	bool close = FALSE;
	unsigned char ucParser;
	char c, *p_inteiro, *p_inteiroll;
	char inteiro[8];
	char inteiroll[24];


	if ( (xSdHandle.connected == TRUE) && (bSDcardIsPresent()) && (bSDcardFAT16Check()) ){

		siFile = siOpenFile( DEBUG_FILE_NAME );

		if ( siFile >= 0 ){

			memset( &(inteiro) , 10 , sizeof( inteiro ) );
			memset( &(inteiroll) , 10 , sizeof( inteiroll ) );
			p_inteiro = inteiro;
			p_inteiroll = inteiroll;

			do {
				c = cGetNextChar(siFile);
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
						#if DEBUG_ON
							debug(fp,"SDCard: Problem with SDCard");
						#endif
						bEOF = TRUE;
						break;
					case 0x20: 	//ASCII: 0x20 = space
					case 10: 	//ASCII: 10 = LN
					case 13: 	//ASCII: 13 = CR
						break;

					case 'X':
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

							xDefaults.usiPreBtSync = (unsigned short int)atoi( inteiro );
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

							xDefaults.usiSyncPeriod = (unsigned short int)atoi( inteiro );
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

							xDefaults.usiPreScanSerial = (unsigned short int)atoi( inteiro );
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

							xDefaults.usiOverScanSerial = (unsigned short int)atoi( inteiro );
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'R':
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

							xDefaults.ucRmapKey = (unsigned short int)atoi( inteiro );
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'A':
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

							xDefaults.ucLogicalAddr = (unsigned short int)atoi( inteiro );
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

							xDefaults.usiRows = (unsigned short int)atoi( inteiro );
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

							xDefaults.usiOLN = (unsigned short int)atoi( inteiro );
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

							xDefaults.usiCols = (unsigned short int)atoi( inteiro );
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 'G':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiroll) = c;
								p_inteiroll++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.ulStartDelay = (unsigned long)atoll( inteiroll );
						p_inteiroll = inteiroll;

						break;
					case 'K':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiroll) = c;
								p_inteiroll++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.ulSkipDelay = (unsigned long)atoll( inteiroll );
						p_inteiroll = inteiroll;

						break;
					case 'J':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiroll) = c;
								p_inteiroll++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.ulLineDelay = (unsigned long)atoll( inteiroll );
						p_inteiroll = inteiroll;

						break;
					case 'M':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiroll) = c;
								p_inteiroll++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.ulADCPixelDelay = (unsigned long)atoll( inteiroll );
						p_inteiroll = inteiroll;

						break;
					case 'B':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.usiLinkNFEE0 = (unsigned short int)atoi( inteiro );
						p_inteiro = inteiro;

						break;
					case 'F':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.usiDebugLevel = (unsigned short int)atoi( inteiro );
						p_inteiro = inteiro;

						break;
					case 'Q':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.usiPatternType = (unsigned short int)atoi( inteiro );
						p_inteiro = inteiro;

						break;
					case 'Y':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.usiGuardNFEEDelay = (unsigned short int)atoi( inteiro );
						p_inteiro = inteiro;

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

						xDefaults.usiDataProtId = (unsigned short int)atoi( inteiro );
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

						xDefaults.usiDpuLogicalAddr = (unsigned short int)atoi( inteiro );
						p_inteiro = inteiro;

						break;
					case 'E':

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

							xDefaults.ucReadOutOrder[min_sim(ucParser,3)] = (unsigned char)atoi( inteiro );
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

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

						sidhcpTemp = atoi( inteiro );
						if (sidhcpTemp == 1)
							xDefaults.bBufferOverflowEn = TRUE;
						else
							xDefaults.bBufferOverflowEn = FALSE;

						p_inteiro = inteiro;

						break;
					case 'Z':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						sidhcpTemp = atoi( inteiro );
						if (sidhcpTemp == 1)
							xDefaults.bSpwLinkStart = TRUE;
						else
							xDefaults.bSpwLinkStart = FALSE;

						p_inteiro = inteiro;

						break;
					case 'I': /*SPW Packet length*/
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

							xDefaults.usiSpwPLength = (unsigned short int)atoi( inteiro );
							p_inteiro = inteiro;
							ucParser++;
						} while ( (c !=59) );

						break;
					case 0x3C: //"<"
						close = siCloseFile(siFile);
						if (close == FALSE){
							#if DEBUG_ON
								debug(fp,"SDCard: Can't close the file.\n");
							#endif
						}
						/* End of Parser File */
						bEOF = TRUE;
						bSuccess = TRUE; //tod: pensar melhor
						break;
					default:
						#if DEBUG_ON
							fprintf(fp,"SDCard: Problem with the parser. (%hhu)\n",c);
						#endif
						break;
				}
			} while ( bEOF == FALSE );
		} else {
			#if DEBUG_ON
				fprintf(fp,"SDCard: File not found.\n");
			#endif
		}
	} else {
		#if DEBUG_ON
			fprintf(fp,"SDCard: No SDCard.\n");
		#endif
	}
	/* Load the default configuration if not successful in read the SDCard */
	if ( bSuccess == FALSE ) {

		xDefaults.usiSyncPeriod     = 6250; /* ms */
		xDefaults.usiRows           = 4510;
		xDefaults.usiOLN            = 50;
		xDefaults.usiCols           = 2295;
		xDefaults.usiPreScanSerial  = 0;
		xDefaults.usiOverScanSerial = 0;
		xDefaults.ulStartDelay      = 0; /* ms */
		xDefaults.ulSkipDelay       = 110000; /* ns */
		xDefaults.ulLineDelay       = 90000; /* ns */
		xDefaults.ulADCPixelDelay   = 333; /* ns */
		xDefaults.bBufferOverflowEn = FALSE;
		xDefaults.ucRmapKey         = 209; /* 0xD1 */
		xDefaults.ucLogicalAddr     = 81; /* 0x51 */
		xDefaults.bSpwLinkStart     = FALSE;
		xDefaults.usiLinkNFEE0      = 0;
		xDefaults.usiGuardNFEEDelay = 50; /* ms */
		xDefaults.usiDebugLevel     = 4; /* Main Progress and main messages (ex. Syncs, state changes) */
		xDefaults.usiPatternType    = 0; /* Official URD */
		xDefaults.usiDataProtId     = 240; /* 0xF0 */
		xDefaults.usiDpuLogicalAddr = 80; /* 0x50 */
		xDefaults.ucReadOutOrder[0] = 0;
		xDefaults.ucReadOutOrder[1] = 1;
		xDefaults.ucReadOutOrder[2] = 2;
		xDefaults.ucReadOutOrder[3] = 3;
		xDefaults.usiSpwPLength     = 32140; /* 32k LESIA */
		xDefaults.usiPreBtSync      = 200; /* ms */

	}

	return bSuccess;
}

#if DEBUG_ON
	void vShowEthConfig( void ) {

		fprintf(fp, "Ethernet loaded configurations:\n");

		fprintf(fp, "  MAC: %02X:%02X:%02X:%02X:%02X:%02X \n", xConfEth.ucMAC[0], xConfEth.ucMAC[1], xConfEth.ucMAC[2], xConfEth.ucMAC[3], xConfEth.ucMAC[4], xConfEth.ucMAC[5]);

		fprintf(fp, "  IP: %i.%i.%i.%i \n", xConfEth.ucIP[0], xConfEth.ucIP[1], xConfEth.ucIP[2], xConfEth.ucIP[3]);

		fprintf(fp, "  GTW: %i.%i.%i.%i \n", xConfEth.ucGTW[0], xConfEth.ucGTW[1], xConfEth.ucGTW[2], xConfEth.ucGTW[3]);

		fprintf(fp, "  Sub: %i.%i.%i.%i \n", xConfEth.ucSubNet[0], xConfEth.ucSubNet[1], xConfEth.ucSubNet[2], xConfEth.ucSubNet[3]);

		fprintf(fp, "  DNS: %i.%i.%i.%i \n", xConfEth.ucDNS[0], xConfEth.ucDNS[1], xConfEth.ucDNS[2], xConfEth.ucDNS[3]);

		fprintf(fp, "  Server Port: %i\n", xConfEth.siPortPUS);

		fprintf(fp, "  Use DHCP: %i\n", xConfEth.bDHCP);

		fprintf(fp, "\n");

	}

	void vShowDebugConfig(void) {

		fprintf(fp, "Debug loaded configurations:\n");

		fprintf(fp, "  SimuCam sync period: %u [ms] \n", xDefaults.usiSyncPeriod);

		fprintf(fp, "  CCD image lines: %u \n", xDefaults.usiRows);

		fprintf(fp, "  CCD parallel overscan lines: %u \n", xDefaults.usiOLN);

		fprintf(fp, "  CCD columns: %u \n", xDefaults.usiCols);

		fprintf(fp, "  CCD serial prescan columns: %u \n", xDefaults.usiPreScanSerial);

		fprintf(fp, "  CCD serial overscan columns: %u \n", xDefaults.usiOverScanSerial);

		fprintf(fp, "  CCD start readout delay: %lu [ms] \n", xDefaults.ulStartDelay);

		fprintf(fp, "  CCD line skip delay: %lu [ns] \n", xDefaults.ulSkipDelay);

		fprintf(fp, "  CCD line transfer delay %lu [ns] \n", xDefaults.ulLineDelay);

		fprintf(fp, "  CCD ADC and pixel transfer delay: %lu [ns] \n", xDefaults.ulADCPixelDelay);

		fprintf(fp, "  Output buffer overflow enable: %u \n", xDefaults.bBufferOverflowEn);

		fprintf(fp, "  SimuCam RMAP key: 0x%02X \n", xDefaults.ucRmapKey);

		fprintf(fp, "  SimuCam logical address: 0x%02X \n", xDefaults.ucLogicalAddr);

		fprintf(fp, "  Configure SpW links as link started: %u \n", xDefaults.bSpwLinkStart);

		fprintf(fp, "  SpW Link for the FEE-0: %u \n", xDefaults.usiLinkNFEE0);

		fprintf(fp, "  N-FEE guard delay: %u [ms] \n", xDefaults.usiGuardNFEEDelay);

		fprintf(fp, "  Messages debug level: %u \n", xDefaults.usiDebugLevel);

		fprintf(fp, "  Generated pattern type: %u \n", xDefaults.usiPatternType);

		fprintf(fp, "  Data packet protocol ID: 0x%02X \n", xDefaults.usiDataProtId);

		fprintf(fp, "  DPU logical address: 0x%02X \n", xDefaults.usiDpuLogicalAddr);

		fprintf(fp, "  CCDs readout order: %hhu %hhu %hhu %hhu \n", xDefaults.ucReadOutOrder[0], xDefaults.ucReadOutOrder[1], xDefaults.ucReadOutOrder[2], xDefaults.ucReadOutOrder[3]);

		fprintf(fp, "  Data packet length: %u [B] \n", xDefaults.usiSpwPLength);

		fprintf(fp, "  SimuCam pre-sync time: %u [ms] \n", xDefaults.usiPreBtSync);

		fprintf(fp, "\n");

	}
#endif
