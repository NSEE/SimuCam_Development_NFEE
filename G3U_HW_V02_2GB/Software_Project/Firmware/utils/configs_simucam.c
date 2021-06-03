/*
 * configs_simucam.c
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#include "configs_simucam.h"

const TEthInterfaceParams cxDefaultsEthInterfaceParams = {
	.siPortPUS = 17000,
	.bDHCP     = FALSE,
	.ucIP      = {192, 168, 17, 10},
	.ucSubNet  = {255, 255, 255, 0},
	.ucGTW     = {192, 168, 17, 1},
	.ucDNS     = {1, 1, 1, 1},
	.ucPID     = 112,
	.ucPCAT    = 6
};

const TGenSimulationParams cxDefaultsGenSimulationParams = {
	.usiOverScanSerial = 0,
	.usiPreScanSerial  = 0,
	.usiOLN            = 300,
	.usiCols           = 2295,
	.usiRows           = 4510,
	.usiExposurePeriod = 25000,
	.bBufferOverflowEn = TRUE,
	.ulStartDelay      = 0,
	.ulSkipDelay       = 110000,
	.ulLineDelay       = 90000,
	.ulADCPixelDelay   = 333,
	.ucDebugLevel      = 4,
	.usiGuardFEEDelay  = 50,
	.ucSyncSource      = 0
};

const TSpwInterfaceParams cxDefaultsSpwInterfaceParams = {
	.bSpwLinkStart           = FALSE,
	.bSpwLinkAutostart       = TRUE,
	.ucSpwLinkSpeed          = 100,
	.bTimeCodeTransmissionEn = TRUE,
	.ucLogicalAddr           = 81,
	.ucRmapKey               = 209,
	.ucDataProtId            = 240,
	.ucDpuLogicalAddr        = 80
};

/*Configuration related to the eth connection*/
TEthInterfaceParams xConfEth;
TGenSimulationParams xDefaults;
TSpwInterfaceParams xConfSpw[N_OF_NFEE];
TGlobal	xGlobal;

/* Load ETH configuration values from SD Card */
bool bLoadDefaultEthConf( void ) {
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
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							debug(fp,"SDCard: Problem with SDCard");
						}
						#endif
						bEOF = TRUE;
						break;
					case 0x20: 	//ASCII: 0x20 = space
					case 10: 	//ASCII: 10 = LN
					case 13: 	//ASCII: 13 = CR
						break;
//					case 'M':
//
//						ucParser = 0;
//						do {
//							do {
//								c = cGetNextChar(siFile);
//								if ( isdigit( c ) ) {
//									(*p_inteiro) = c;
//									p_inteiro++;
//								}
//							} while ( (c !=58) && (c !=59) ); //ASCII: 58 = ':' 59 = ';'
//							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//							xConfEth.ucMAC[min_sim(ucParser,5)] = (unsigned char)atoi( inteiro );
//							p_inteiro = inteiro;
//							ucParser++;
//						} while ( (c !=59) );
//
//						break;
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
					case 'A':
						ucParser = 0;
						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfEth.ucPID = (unsigned char)atoi( inteiro );
						p_inteiro = inteiro;

						break;
					case 0x3C: //"<"
						close = siCloseFile(siFile);
						if (close == FALSE){
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
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
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"SDCard: Problem with the parser.\n");
						}
						#endif
						break;
				}
			} while ( bEOF == FALSE );
		} else {
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"SDCard: File not found.\n");
			}
			#endif
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
			fprintf(fp,"SDCard: No SDCard.\n");
		}
		#endif
	}
	/* Load the default configuration if not successful in read the SDCard */
	if ( bSuccess == FALSE ) {

		vLoadHardcodedEthConf();

	}

	return bSuccess;
}

/* Load debug values from SD Card, only used during the development */
bool bLoadDefaultDebugConf( void ) {
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

//					case 'X':
//						ucParser = 0;
//						do {
//							do {
//								c = cGetNextChar(siFile);
//								if ( isdigit( c ) ) {
//									(*p_inteiro) = c;
//									p_inteiro++;
//								}
//							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'
//							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//							xDefaults.usiPreBtSync = (unsigned short int)atoi( inteiro );
//							p_inteiro = inteiro;
//							ucParser++;
//						} while ( (c !=59) );
//
//						break;
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

							xDefaults.usiExposurePeriod = (unsigned short int)atoi( inteiro );
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
//					case 'R':
//						ucParser = 0;
//						do {
//							do {
//								c = cGetNextChar(siFile);
//								if ( isdigit( c ) ) {
//									(*p_inteiro) = c;
//									p_inteiro++;
//								}
//							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'
//							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//							xDefaults.ucRmapKey = (unsigned short int)atoi( inteiro );
//							p_inteiro = inteiro;
//							ucParser++;
//						} while ( (c !=59) );
//
//						break;
//					case 'A':
//						ucParser = 0;
//						do {
//							do {
//								c = cGetNextChar(siFile);
//								if ( isdigit( c ) ) {
//									(*p_inteiro) = c;
//									p_inteiro++;
//								}
//							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'
//							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//							xDefaults.ucLogicalAddr = (unsigned short int)atoi( inteiro );
//							p_inteiro = inteiro;
//							ucParser++;
//						} while ( (c !=59) );
//
//						break;
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
//					case 'B':
//
//						do {
//							c = cGetNextChar(siFile);
//							if ( isdigit( c ) ) {
//								(*p_inteiro) = c;
//								p_inteiro++;
//							}
//						} while ( c !=59 ); //ASCII: 59 = ';'
//						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//						xDefaults.usiLinkNFEE0 = (unsigned short int)atoi( inteiro );
//						p_inteiro = inteiro;
//
//						break;
					case 'F':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.ucDebugLevel = (unsigned short int)atoi( inteiro );
						p_inteiro = inteiro;

						break;
//					case 'Q':
//
//						do {
//							c = cGetNextChar(siFile);
//							if ( isdigit( c ) ) {
//								(*p_inteiro) = c;
//								p_inteiro++;
//							}
//						} while ( c !=59 ); //ASCII: 59 = ';'
//						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//						xDefaults.usiPatternType = (unsigned short int)atoi( inteiro );
//						p_inteiro = inteiro;
//
//						break;
					case 'Y':

						do {
							c = cGetNextChar(siFile);
							if ( isdigit( c ) ) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ( c !=59 ); //ASCII: 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xDefaults.usiGuardFEEDelay = (unsigned short int)atoi( inteiro );
						p_inteiro = inteiro;

						break;
//					case 'D':
//
//						do {
//							c = cGetNextChar(siFile);
//							if ( isdigit( c ) ) {
//								(*p_inteiro) = c;
//								p_inteiro++;
//							}
//						} while ( c !=59 ); //ASCII: 59 = ';'
//						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//						xDefaults.usiDataProtId = (unsigned short int)atoi( inteiro );
//						p_inteiro = inteiro;
//
//						break;
//					case 'H':
//
//						do {
//							c = cGetNextChar(siFile);
//							if ( isdigit( c ) ) {
//								(*p_inteiro) = c;
//								p_inteiro++;
//							}
//						} while ( c !=59 ); //ASCII: 59 = ';'
//						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//						xDefaults.usiDpuLogicalAddr = (unsigned short int)atoi( inteiro );
//						p_inteiro = inteiro;
//
//						break;
//					case 'E':
//
//						ucParser = 0;
//						do {
//							do {
//								c = cGetNextChar(siFile);
//								if ( isdigit( c ) ) {
//									(*p_inteiro) = c;
//									p_inteiro++;
//								}
//							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'
//							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//							xDefaults.ucReadOutOrder[min_sim(ucParser,3)] = (unsigned char)atoi( inteiro );
//							p_inteiro = inteiro;
//							ucParser++;
//						} while ( (c !=59) );
//
//						break;
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
//					case 'Z':
//
//						do {
//							c = cGetNextChar(siFile);
//							if ( isdigit( c ) ) {
//								(*p_inteiro) = c;
//								p_inteiro++;
//							}
//						} while ( c !=59 ); //ASCII: 59 = ';'
//						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//						sidhcpTemp = atoi( inteiro );
//						if (sidhcpTemp == 1)
//							xDefaults.bSpwLinkStart = TRUE;
//						else
//							xDefaults.bSpwLinkStart = FALSE;
//
//						p_inteiro = inteiro;
//
//						break;
//					case 'I': /*SPW Packet length*/
//						ucParser = 0;
//						do {
//							do {
//								c = cGetNextChar(siFile);
//								if ( isdigit( c ) ) {
//									(*p_inteiro) = c;
//									p_inteiro++;
//								}
//							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'
//							(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED
//
//							xDefaults.usiSpwPLength = (unsigned short int)atoi( inteiro );
//							p_inteiro = inteiro;
//							ucParser++;
//						} while ( (c !=59) );
//
//						break;
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

		vLoadHardcodedDebugConf();

	}

	return bSuccess;
}

void vLoadHardcodedEthConf( void ) {

	/* Hard-coded ETH configurations */

	xConfEth = cxDefaultsEthInterfaceParams;

}

void vLoadHardcodedDebugConf( void ) {

	/* Hard-coded DEBUG configurations */

	xDefaults = cxDefaultsGenSimulationParams;

}

bool bLoadHardcodedSpwConf( alt_u8 ucFee ) {
	bool bStatus = FALSE;

	if (N_OF_NFEE > ucFee) {

		xConfSpw[ucFee] = cxDefaultsSpwInterfaceParams;

		bStatus = TRUE;
	}

	return (bStatus);
}

#if DEBUG_ON
	void vShowEthConfig( void ) {

		fprintf(fp, "Ethernet loaded configurations:\n");

//		fprintf(fp, "  MAC: %02X:%02X:%02X:%02X:%02X:%02X \n", xConfEth.ucMAC[0], xConfEth.ucMAC[1], xConfEth.ucMAC[2], xConfEth.ucMAC[3], xConfEth.ucMAC[4], xConfEth.ucMAC[5]);

		fprintf(fp, "  IP: %i.%i.%i.%i \n", xConfEth.ucIP[0], xConfEth.ucIP[1], xConfEth.ucIP[2], xConfEth.ucIP[3]);

		fprintf(fp, "  GTW: %i.%i.%i.%i \n", xConfEth.ucGTW[0], xConfEth.ucGTW[1], xConfEth.ucGTW[2], xConfEth.ucGTW[3]);

		fprintf(fp, "  Sub: %i.%i.%i.%i \n", xConfEth.ucSubNet[0], xConfEth.ucSubNet[1], xConfEth.ucSubNet[2], xConfEth.ucSubNet[3]);

		fprintf(fp, "  DNS: %i.%i.%i.%i \n", xConfEth.ucDNS[0], xConfEth.ucDNS[1], xConfEth.ucDNS[2], xConfEth.ucDNS[3]);

		fprintf(fp, "  Server Port: %i\n", xConfEth.siPortPUS);

		fprintf(fp, "  Use DHCP: %i\n", xConfEth.bDHCP);

		fprintf(fp, "  PUS PID: %i\n", xConfEth.ucPID);

		fprintf(fp, "  PUS PCAT: %i\n", xConfEth.ucPCAT);

		fprintf(fp, "\n");

	}

	void vShowDebugConfig(void) {

		fprintf(fp, "Debug loaded configurations:\n");

		fprintf(fp, "  SimuCam Exposure period: %u [ms] \n", xDefaults.usiExposurePeriod);

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

		fprintf(fp, "  N-FEE guard delay: %u [ms] \n", xDefaults.usiGuardFEEDelay);

		fprintf(fp, "  Messages debug level: %u \n", xDefaults.ucDebugLevel);

		fprintf(fp, "\n");

	}

	bool bShowSpwConfig( alt_u8 ucFee ) {
		bool bStatus = FALSE;

		if (N_OF_NFEE > ucFee) {

			fprintf(fp, "FEE %u SpaceWire Interface loaded parameters:\n", ucFee);

			fprintf(fp, "  SpaceWire link set as Link Start: %u \n", xConfSpw[ucFee].bSpwLinkStart);

			fprintf(fp, "  SpaceWire link set as Link Auto-Start: %u \n", xConfSpw[ucFee].bSpwLinkAutostart);

			fprintf(fp, "  SpaceWire Link Speed [Mhz]: %u \n", xConfSpw[ucFee].ucSpwLinkSpeed);

			fprintf(fp, "  Timecode Transmission Enable: %u \n", xConfSpw[ucFee].bTimeCodeTransmissionEn);

			fprintf(fp, "  RMAP Logical Address: %u \n", xConfSpw[ucFee].ucLogicalAddr);

			fprintf(fp, "  RMAP Key: %u \n", xConfSpw[ucFee].ucRmapKey);

			fprintf(fp, "  Data Packet Protocol ID: %u \n", xConfSpw[ucFee].ucDataProtId);

			fprintf(fp, "  Data Packet Target Logical Address: %u \n", xConfSpw[ucFee].ucDpuLogicalAddr);

			fprintf(fp, "\n");

			bStatus = TRUE;
		}

		return (bStatus);
	}
#endif
