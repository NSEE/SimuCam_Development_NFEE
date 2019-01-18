/*
 * receiver_uart_task.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */


#include "receiver_uart_task.h"


void vReceiverUartTask(void *task_data) {
    bool bSuccess = FALSE;
    char cReceiveBuffer[SIZE_RCV_BUFFER];
    char cReceive[SIZE_RCV_BUFFER+64];
    tReaderStates eReaderRXMode;
    static tPreParsed xPreParsedReader;

    #ifdef DEBUG_ON
        debug(fp,"Receiver UART Task. (Task on)\n");
    #endif

    eReaderRXMode = sRConfiguring;

    for(;;) {

        switch (eReaderRXMode)
        {
            case sRConfiguring:
                /* For future implementations */
                eReaderRXMode = sGetRxUart;
                break;
            case sGetRxUart:

                memset(cReceiveBuffer, 0, SIZE_RCV_BUFFER);
                scanf("%s", cReceive);
                memcpy(cReceiveBuffer, cReceive, (SIZE_RCV_BUFFER -1) ); /* Make that there's a zero terminator */
                bSuccess = bPreParser( cReceiveBuffer , &xPreParsedReader );

                if ( bSuccess == TRUE ) {

                    if ( (xPreParsedReader.cType == START_REQUEST_CHAR) || (xPreParsedReader.cType == START_REPLY_CHAR) ) {
                        /* The packet is a request or reply sent by the NUC*/
                        eReaderRXMode = sSendToParser;
                    } else {
                        /* The packet is an ACK or NACK sent by the NUC*/
                        /* If is a Nack, do nothing. The packet will be retransmited by the timeout checker. */
                        if ( xPreParsedReader.cType == NACK_CHAR ) {
                            eReaderRXMode = sGetRxUart;
                            #ifdef DEBUG_ON
                                debug(fp,"Nack Received. Do nothing!\n");
                            #endif
                        } else
                            eReaderRXMode = sSendToACKReceiver;

                    }

                } else {
                    /*Should Send NACK - Mocking value the only parte that metters is the "cType = '#'" part */
                    xPreParsedReader.cType = '#';
                    xPreParsedReader.cCommand = '.';
                    xPreParsedReader.usiValues[0] = 1;

                    /*Try to send ack to the Ack Sender Task*/
                    bSuccess = setPreAckSenderFreePos( &xPreParsedReader );
                    if ( bSuccess == FALSE ) {
                        vFailSendNack();
                    }
                    eReaderRXMode = sGetRxUart;
                }

                break;
            case sSendToParser:

                /* Try to send ack to the Ack Sender Task*/
                bSuccess = setPreAckSenderFreePos( &xPreParsedReader );
                if ( bSuccess == TRUE ) {
                    /* If was possible to send ack, then try to send the command to the Parser Task*/
                    bSuccess = setPreParsedFreePos( &xPreParsedReader );
                    if ( bSuccess == FALSE ) {
                        //TODO
                        /* At this point ack was sent but the command was not sent to the Parser task
                           should sent an error message for the NUC and maye to the SGSE*/
                        vFailSetPreParsedBuffer();
                    }
                } else {
                    vFailSetPreAckSenderBuffer();
                }
                /* If is not possible to send the ACK for this command then we don't process the command,
                   because it will be sent again by the NUC and we won't wast processing performing the command twice.*/
                eReaderRXMode = sGetRxUart;
                break;
            case sSendToACKReceiver:

                bSuccess = setPreAckReceiverFreePos( &xPreParsedReader );
                if ( bSuccess == FALSE ) {
                    /*If was not possible to receive the ack do nothing.*/
                    vFailSetPreAckReceiverBuffer();
                }
                eReaderRXMode = sGetRxUart;
                break;
            default:
                eReaderRXMode = sGetRxUart;
                break;
        }

    }
}

/*  This function will parse the buffer into a command, will identify if is an request or reply
    also will separate all the values separated by ':'. If the command isn't complete (';' in the final)
    it will return false. */
    /* Max size of parsed value is 6 digits, for now*/
bool bPreParser( char *buffer, tPreParsed *xPerParcedBuffer )
{
    bool bSuccess = FALSE;
    short int siStrLen, siTeminador, siIniReq, siIniResp, siIniACK, siIniNACK, siCRC;
    unsigned char i;
	char c, *p_inteiro;
	char inteiro[6]; /* Max size of parsed value is 6 digits, for now */

    siStrLen = strlen(buffer);
    siTeminador = siPosStr(buffer, FINAL_CHAR);
    siIniACK = siPosStr(buffer, ACK_CHAR);
    siIniNACK = siPosStr(buffer, NACK_CHAR);
    siIniACK = min_sim(siIniACK, siIniNACK);
    siIniReq = siPosStr(buffer, START_REQUEST_CHAR);
    siIniResp = siPosStr(buffer, START_REPLY_CHAR);
    siIniReq = min_sim(siIniReq, siIniResp);
    siIniReq = min_sim(siIniReq, siIniACK);
    siCRC = siPosStr(buffer, SEPARATOR_CRC);

    /* Check if there is [!|?] , |, ; in the packet*/
    if ( (siTeminador == (siStrLen-1)) && (siCRC < siTeminador) && (siIniReq < siCRC) ) {

#ifdef DEBUG_ON
	fprintf(fp," Debug -  siIni = %hhu, siCRC = %hhu\n", siIniReq, siCRC );
#endif

        xPerParcedBuffer->ucCalculatedCRC8 = ucCrc8wInit(&buffer[siIniReq] , (siCRC - siIniReq) );
        xPerParcedBuffer->cType = buffer[siIniReq];

        if (xPerParcedBuffer->cType == NACK_CHAR ) {
            xPerParcedBuffer->ucMessageCRC8 = 54; /*CRC8("#")=54*/
            xPerParcedBuffer->ucCalculatedCRC8 = 54; /*Even if calculated crc is wrong we should re-send the commands*/
            bSuccess = TRUE;
        } else {
            xPerParcedBuffer->cCommand = buffer[siIniReq+1];
            xPerParcedBuffer->ucNofBytes = 0;
            memset( xPerParcedBuffer->usiValues , 0 , SIZE_UCVALUES);

            i = siIniReq + 3; /* "?C:i..." */
            do {
                p_inteiro = inteiro;
                memset( &(inteiro) , 0 , sizeof( inteiro ) );
                do {
                    c = buffer[i];
                    if ( isdigit( c ) ) {
                        (*p_inteiro) = c;
                        p_inteiro++;
                    }
                    i++;
                } while ( (siStrLen>i) && ( ( c != SEPARATOR_CHAR ) && ( c != FINAL_CHAR ) && ( c != SEPARATOR_CRC )) ); //ASCII: 58 = ':' 59 = ';' and '|'
                (*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

                if ( ( c == SEPARATOR_CHAR ) || ( c == SEPARATOR_CRC ) ) {
                    xPerParcedBuffer->usiValues[min_sim(xPerParcedBuffer->ucNofBytes,SIZE_UCVALUES)] = (unsigned short int)atoi( inteiro );
                    xPerParcedBuffer->ucNofBytes++;
                }
                else if ( c == FINAL_CHAR )
                {
                    xPerParcedBuffer->ucMessageCRC8 = (unsigned char)atoi( inteiro );
                }

            } while ( (c != FINAL_CHAR) && (siStrLen>i) );

            if ( c == FINAL_CHAR )
                if ( xPerParcedBuffer->ucMessageCRC8 == xPerParcedBuffer->ucCalculatedCRC8 ){
                    bSuccess = TRUE;
                } else {
                    /* Wrong CRC */
                    #ifdef DEBUG_ON
                        debug(fp,"Wrong CRC. Pre Parsed.\n");
                    #endif
                    bSuccess = FALSE;
                }

            else
                bSuccess = FALSE; /*Index overflow in the buffer*/
            }
    } else {
        /*Malformed Packet*/
        bSuccess = FALSE;
    }
    memset(buffer,0,strlen(buffer));

    return bSuccess;
}

/* Search for a Free location to put the pre parsed packet in the pipe for the ParserTask */
bool setPreParsedFreePos( tPreParsed *xPrePReader ) {
    bool bSuccess = FALSE;
    INT8U error_code;
    unsigned char i = 0;

    OSMutexPend(xMutexPreParsed, 30, &error_code); /* Try to get mutex that protects the preparsed buffer. Wait max 30 ticks = 30 ms */
    if ( error_code == OS_NO_ERR ) {
        /* Have free access to the buffer, check if there's any no threated command using the cType  */

        for( i = 0; i < N_PREPARSED_ENTRIES; i++ )
        {
            if ( xPreParsed[i].cType == 0 ) {
                /* Locate a free place*/
                /* Need to check if the performance is the same as memcpy*/
                xPreParsed[i] = (*xPrePReader);
                error_code = OSSemPost(xSemCountPreParsed);
                if ( error_code == OS_ERR_NONE ) {
                    bSuccess = TRUE;
                } else {
                    vFailSendPreParsedSemaphore();
                    xPreParsed[i].cType = 0;
                    bSuccess = FALSE;
                }
                break;
            }
        }
        OSMutexPost(xMutexPreParsed);
    }
    return bSuccess;
}



/* Search for some free location in the xSenderACK array, that comunicates with the AckSenderTask */
bool setPreAckSenderFreePos( tPreParsed *xPrePReader ) {
    bool bSuccess = FALSE;
    INT8U error_code;
    unsigned char i = 0;

    bSuccess = FALSE;
    OSMutexPend(xMutexSenderACK, 50, &error_code); /* Try to get mutex that protects the preparsed buffer. Wait max 50 ticks = 50 ms */
    if ( error_code == OS_NO_ERR ) {
        /* Have free access to the buffer, check if there's any no threated command using the cType  */

        for(i = 0; i < N_ACKS_SENDER; i++)
        {
            if ( xSenderACK[i].cType == 0 ) {
                /* Locate a free place*/
                /* Need to check if the performance is the same as memcpy*/
                xSenderACK[i].cType = xPrePReader->cType;
                xSenderACK[i].cCommand = xPrePReader->cCommand;
                xSenderACK[i].usiId = xPrePReader->usiValues[0]; /*The first value is always the command id*/

                error_code = OSSemPost(xSemCountSenderACK);
                if ( error_code != OS_ERR_NONE ) {
                    vFailSendPreAckSenderSemaphore();
                    xSenderACK[i].cType = 0;
                } else
                    bSuccess = TRUE;
                break;
            }
        }
        OSMutexPost(xMutexSenderACK);
    }

    return bSuccess;
}

/* Search for some free location in the xSenderACK array, that comunicates with the AckSenderTask */
bool setPreAckReceiverFreePos( tPreParsed *xPrePReader ) {
    bool bSuccess = FALSE;
    INT8U error_code;
    unsigned char i = 0;

    bSuccess = FALSE;
    OSMutexPend(xMutexReceivedACK, 50, &error_code); /* Try to get mutex that protects the preparsed buffer. Wait 50 ticks = 50 ms */
    if ( error_code == OS_NO_ERR ) {
        /* Have free access to the buffer, check if there's any no threated command using the cType  */

        for( i = 0; i < N_ACKS_RECEIVED; i++ )
        {
            if ( xReceivedACK[i].cType == 0 ) {
                /* Locate a free place*/
                /* Need to check if the performance is the same as memcpy*/
                xReceivedACK[i].cType = xPrePReader->cType;
                xReceivedACK[i].cCommand = xPrePReader->cCommand;
                xReceivedACK[i].usiId = xPrePReader->usiValues[0];

                error_code = OSSemPost(xSemCountReceivedACK);
                if ( error_code == OS_ERR_NONE ) {
                    bSuccess = TRUE;
                } else {
                    vFailSendPreAckReceiverSemaphore();
                    xReceivedACK[i].cType = 0;
                }
                break;
            }
        }
        OSMutexPost(xMutexReceivedACK);
    } else {
        /* Could not  */
        #ifdef DEBUG_ON
            debug(fp,"Could not put the ack packet receiveid in the queue. (setPreAckReceiverFreePos)\n");
        #endif
    }

    return bSuccess;
}




/* =========================== Version 2 of the management function ========================= */


/*  This function will parse the buffer into a command, will identify if is an request or reply
    also will separate all the values separated by ':'. If the command isn't complete (';' in the final)
    it will return false. */
    /* Max size of parsed value is 6 digits, for now*/
bool bPreParserV2( char *buffer, tPreParsed *xPerParcedBuffer )
{
    bool bSuccess = FALSE;
    short int siStrLen, siTeminador, siIni, siCRC;
    unsigned char i;
	char c, *p_inteiro;
	char inteiro[6]; /* Max size of parsed value is 6 digits, for now */


    bSuccess = FALSE;

    siStrLen = strnlen(buffer, SIZE_RCV_BUFFER);
    siTeminador = siPosStr(buffer, FINAL_CHAR);

    /* Check the protocol terminator char ';' */
    if ( (siTeminador != (siStrLen-1)) )
        return bSuccess;

    siCRC = siPosStr(buffer, SEPARATOR_CRC);

    /* Check if there's an CRC char */
    if ( siCRC > siTeminador )
        return bSuccess;

    siIni = strcspn( buffer , ALL_INI_CHAR ); /* Verify if there's any one of the initial characters */

    /* Check if there's any initial char protocol and if is before the crc char */
    if ( siIni > siCRC)
        return bSuccess;

    
    /*" ---> At this point we validate the existence and position of all characters in for the protocol in the message "*/


    xPerParcedBuffer->cType = buffer[siIni];
    if (xPerParcedBuffer->cType == NACK_CHAR ) {
        bSuccess = TRUE;
        return bSuccess;
    }


    /*" ---> At this point the packet is a Resquest, Reply or ACK packet"*/

	#ifdef DEBUG_ON
		fprintf(fp," Debug -  siIni = %hhu, siCRC = %hhu\n", siIni, siCRC );
	#endif

    xPerParcedBuffer->ucCalculatedCRC8 = ucCrc8wInit( &buffer[siIni] , (siCRC - siIni) );

    xPerParcedBuffer->cCommand = buffer[siIni+1];
    xPerParcedBuffer->ucNofBytes = 0;
    memset( xPerParcedBuffer->usiValues , 0 , SIZE_UCVALUES*sizeof(xPerParcedBuffer->usiValues) );    

    i = siIni + 3; /* "?C:i..." */
    do {
        p_inteiro = inteiro;
        memset( &(inteiro) , 0 , sizeof( inteiro ) );
        do {
            c = buffer[i];
            if ( isdigit( c ) ) {
                (*p_inteiro) = c;
                p_inteiro++;
            }
            i++;
        } while ( (siStrLen>i) && ( ( c != SEPARATOR_CHAR ) && ( c != FINAL_CHAR ) && ( c != SEPARATOR_CRC )) ); //ASCII: 58 = ':' 59 = ';' and '|'
        (*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

        if ( ( c == SEPARATOR_CHAR ) || ( c == SEPARATOR_CRC ) ) {
            xPerParcedBuffer->usiValues[min_sim(xPerParcedBuffer->ucNofBytes,SIZE_UCVALUES)] = (unsigned short int)atoi( inteiro );
            xPerParcedBuffer->ucNofBytes++;
        }
        else if ( c == FINAL_CHAR )
        {
            xPerParcedBuffer->ucMessageCRC8 = (unsigned char)atoi( inteiro );
        }

    } while ( (c != FINAL_CHAR) && (siStrLen>i) );


    if ( c == FINAL_CHAR )
        if ( xPerParcedBuffer->ucMessageCRC8 == xPerParcedBuffer->ucCalculatedCRC8 ){
            bSuccess = TRUE;
        } else {
            /* Wrong CRC */
            #ifdef DEBUG_ON
                fprintf(fp,"Wrong CRC. Expected = %hhu, received = %hhu\n", xPerParcedBuffer->ucCalculatedCRC8, xPerParcedBuffer->ucMessageCRC8 );
            #endif
            bSuccess = FALSE;
        }
    else
        bSuccess = FALSE; /* Index overflow in the buffer */


    return bSuccess;
}
