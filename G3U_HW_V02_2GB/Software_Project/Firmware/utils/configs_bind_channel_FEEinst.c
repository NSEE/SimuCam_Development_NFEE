/*
 * configs_simucam.c
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#include "configs_bind_channel_FEEinst.h"

TDefaultsCH xDefaultsCH;

bool ucCheckAndApllySPWChannel( char cLetter, unsigned char *ucChannelNumber );

/* Load the bind configuration of the SPW channels and FEE instance*/
bool vCHConfs( void ){
	short int siFile;
	bool bSuccess = FALSE;
	bool bEOF = FALSE;
	bool close = FALSE;
	char c, cChannel;


	if ( (xSdHandle.connected == TRUE) && (bSDcardIsPresent()) && (bSDcardFAT16Check()) ){

		siFile = siOpenFile( SPW_FILE_NAME );

		if ( siFile >= 0 ){

			cChannel = -1;

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
							debug(fp,"SDCard: Problem with SDCard");
						#endif
						bEOF = TRUE;
						break;
					case 0x20: 	//ASCII: 0x20 = space
					case 10: 	//ASCII: 10 = LN
					case 13: 	//ASCII: 13 = CR
						break;

					case '0':
						do {
							do {
								c = cGetNextChar(siFile);
								if ( (isalpha(c)) && (c !=46) && (c !=59) ) {
									cChannel = c;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'

							bSuccess = ucCheckAndApllySPWChannel( cChannel , &xDefaultsCH.ucFEEtoChanell[0] );

							if (bSuccess == TRUE) {
								xDefaultsCH.ucChannelToFEE[ xDefaultsCH.ucFEEtoChanell[0] ] = 0;
							} else {
								return FALSE;
							}
						} while ( (c !=59) );

						break;

					case '1':
						do {
							do {
								c = cGetNextChar(siFile);
								if ( (isalpha(c)) && (c !=46) && (c !=59) ) {
									cChannel = c;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'

							bSuccess = ucCheckAndApllySPWChannel( cChannel , &xDefaultsCH.ucFEEtoChanell[1] );

							if (bSuccess == TRUE) {
								xDefaultsCH.ucChannelToFEE[ xDefaultsCH.ucFEEtoChanell[1] ] = 1;
							} else {
								return FALSE;
							}
						} while ( (c !=59) );

						break;

					case '2':
						do {
							do {
								c = cGetNextChar(siFile);
								if ( (isalpha(c)) && (c !=46) && (c !=59) ) {
									cChannel = c;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'

							bSuccess = ucCheckAndApllySPWChannel( cChannel , &xDefaultsCH.ucFEEtoChanell[2] );

							if (bSuccess == TRUE) {
								xDefaultsCH.ucChannelToFEE[ xDefaultsCH.ucFEEtoChanell[2] ] = 2;
							} else {
								return FALSE;
							}
						} while ( (c !=59) );

						break;

					case '3':
						do {
							do {
								c = cGetNextChar(siFile);
								if ( (isalpha(c)) && (c !=46) && (c !=59) ) {
									cChannel = c;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'

							bSuccess = ucCheckAndApllySPWChannel( cChannel , &xDefaultsCH.ucFEEtoChanell[3] );

							if (bSuccess == TRUE) {
								xDefaultsCH.ucChannelToFEE[ xDefaultsCH.ucFEEtoChanell[3] ] = 3;
							} else {
								return FALSE;
							}
						} while ( (c !=59) );

						break;

					case '4':
						do {
							do {
								c = cGetNextChar(siFile);
								if ( (isalpha(c)) && (c !=46) && (c !=59) ) {
									cChannel = c;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'

							bSuccess = ucCheckAndApllySPWChannel( cChannel , &xDefaultsCH.ucFEEtoChanell[4] );

							if (bSuccess == TRUE) {
								xDefaultsCH.ucChannelToFEE[ xDefaultsCH.ucFEEtoChanell[4] ] = 4;
							} else {
								return FALSE;
							}
						} while ( (c !=59) );

						break;

					case '5':
						do {
							do {
								c = cGetNextChar(siFile);
								if ( (isalpha(c)) && (c !=46) && (c !=59) ) {
									cChannel = c;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'

							bSuccess = ucCheckAndApllySPWChannel( cChannel , &xDefaultsCH.ucFEEtoChanell[5] );

							if (bSuccess == TRUE) {
								xDefaultsCH.ucChannelToFEE[ xDefaultsCH.ucFEEtoChanell[5] ] = 5;
							} else {
								return FALSE;
							}
						} while ( (c !=59) );

						break;

					case '6':
						do {
							do {
								c = cGetNextChar(siFile);
								if ( (isalpha(c)) && (c !=46) && (c !=59) ) {
									cChannel = c;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'

							bSuccess = ucCheckAndApllySPWChannel( cChannel , &xDefaultsCH.ucFEEtoChanell[6] );

							if (bSuccess == TRUE) {
								xDefaultsCH.ucChannelToFEE[ xDefaultsCH.ucFEEtoChanell[6] ] = 6;
							} else {
								return FALSE;
							}
						} while ( (c !=59) );

						break;

					case '7':
						do {
							do {
								c = cGetNextChar(siFile);
								if ( (isalpha(c)) && (c !=46) && (c !=59) ) {
									cChannel = c;
								}
							} while ( (c !=46) && (c !=59) ); //ASCII: 46 = '.' 59 = ';'

							bSuccess = ucCheckAndApllySPWChannel( cChannel , &xDefaultsCH.ucFEEtoChanell[7] );

							if (bSuccess == TRUE) {
								xDefaultsCH.ucChannelToFEE[ xDefaultsCH.ucFEEtoChanell[7] ] = 7;
							} else {
								return FALSE;
							}
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
						bSuccess = TRUE; //pensar melhor
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
		/* Load default? */

	}

	return bSuccess;
}

/* todo: Should verify if the sequence is valid and if any number is repeated*/
bool ucCheckAndApllySPWChannel( char cLetter, unsigned char *ucChannelNumber ) {
//	static char cChannelLists[8] = {-1, -1, -1, -1, -1, -1, -1, -1};
//	static unsigned char ucIterator = 0;

//	/* Check if the char is between ASCII( 65 ) e ASCII( 72 ) */
//
//	/* A ~ H */
//	if ( (cLetter < 65) || (cLetter > 72) ) {
//		return FALSE;
//	}
//
//	/* Check the CHannel was already bind with another FEE instance */
//	for (int i = 0; i < ucIterator; i++) {
//		if ( cChannelLists[i] == cLetter ) {
//			return FALSE;
//		}
//	}
//
//	/* A->0; B->1; ... H->7 */
//	cChannelLists[ucIterator] = cLetter - 65;
//	ucIterator++;
//
//	*ucChannelNumber = cChannelLists[ucIterator];

	// The verification will be implemented later

	*ucChannelNumber = (unsigned char) cLetter - 65;

	return TRUE;
}
