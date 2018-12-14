
#include "receiver_com_task.h"


/*  This function implements the task that will receive packet via UART
    also need to parse the command in order to send to the MEB task */
void vReceiverComTask(void *task_data)
{
    bool bSucess = FALSE;
    INT8U error_code;
    tReceiverStates eReceiverMode;
    char cReceiveBuffer[SIZE_RCV_BUFFER];
    char cTempBuffer[SIZE_RCV_BUFFER];
    short int siStrLen;
    short int siStrLenTemp;
    tPreParsed xPreParsedBuffer;
    
    eReceiverMode = sConfiguring;

    #ifdef DEBUG_ON
        debug(fp,"vReceiverComTask, enter task.\n");
    #endif

    for(;;) {

        memset(cReceiveBuffer, 0, SIZE_RCV_BUFFER);
        switch (eReceiverMode)
        {
            case sConfiguring:
                /* Do nothing for now */
                if (BY_PASS)
                    eReceiverMode = sPiping;
                else
                    eReceiverMode = sWaitingConn;
                break;
            case sPiping:
                /*  This mode is used to send everuthing that is received in UART
                    to the std console of NIOS II output */
                #ifdef DEBUG_ON
                    scanf("%s", cReceiveBuffer);
                    if ( strcmp( cReceiveBuffer , CHANGE_MODE_SEQUENCE ) == 0 ) {
                        debug(fp,"Changing de mode of operation. \n");
                        eReceiverMode = sWaitingConn;
                    } else {
                        debug(fp,cReceiveBuffer);
                    }
                #else
                    eReceiverMode = sReceiving;
                #endif

                break;
            case sWaitingConn:
                /*  This mode waits for the NUC send the status, this is how Simucam
                    knows that NUC is up */
                bSucess = FALSE;
                do
                {
                    siStrLen = strnlen(cReceiveBuffer, SIZE_RCV_BUFFER);
                    memset(cTempBuffer,0,SIZE_RCV_BUFFER);
                    scanf("%s", cTempBuffer);
                    siStrLenTemp = strnlen(cTempBuffer, SIZE_RCV_BUFFER);
                    memcpy(&cReceiveBuffer[siStrLen], cTempBuffer, siStrLenTemp+1);

                    bSucess = bPreParser( cReceiveBuffer , &xPreParsedBuffer );
                } while ( bSucess == FALSE );

                /* Will not pre parser until the command is completed with ';' */
                if ( xPreParsedBuffer.cCommand == 'S' ) {
                    eReceiverMode = sReceiving;
                    /* Post Semaphore to tell to vSenderComTask to stop sending status packet*/
                    error_code = OSSemPost(xSemCommInit);
                } else {
                    eReceiverMode = sWaitingConn;
                }

                break;
            case sReceiving:

                bSucess = FALSE;
                do
                {
                    siStrLen = strnlen(cReceiveBuffer, SIZE_RCV_BUFFER);
                    memset(cTempBuffer,0,SIZE_RCV_BUFFER);
                    scanf("%s", cTempBuffer);
                    siStrLenTemp = strnlen(cTempBuffer, SIZE_RCV_BUFFER);
                    memcpy(&cReceiveBuffer[siStrLen], cTempBuffer, siStrLenTemp+1);

                    bSucess = bPreParser( cReceiveBuffer , &xPreParsedBuffer );
                } while ( bSucess == FALSE );
                /* Will not pre parser until the command is completed with ';' */

                eReceiverMode = sParsing;

                break;
            case sParsing:
                /* At this point we have a preparsed command in the variable xPerPaecedBufer */
                /* Check CRC8 */
                if ( xPreParsedBuffer.ucCalculatedCRC8 == xPreParsedBuffer.ucMessageCRC8 ) {
                    if ( xPreParsedBuffer.cCommand == 'P') {
                        /* This is a PUS command, should handle properly */

                    } else {
                        /* Otherwise this is a internal control command */

                        switch (xPreParsedBuffer.cCommand)
                        {
                            case 'U':
                                if ( xPreParsedBuffer.usiValues[0] == "&$=" ) {
                                    /* Change to Piping mode */
                                    eReceiverMode = sPiping;
                                } else {
                                    eReceiverMode = sReceiving;
                                }
                                break;
                            default:
                                break;
                        }
                    }
                } else {
                	eReceiverMode = sHandlingError;
                }

                break;
            case sSendingMEB:
                /* code */
                break;
            case sHandlingError:
                /* code */
                break;
            default:
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
    char cTempChar[2] = "";
    short int siStrLen, siTeminador, siIniReq, siIniResp, siCRC;
	char c, i, *p_inteiro;
	char inteiro[6]; /* Max size of parsed value is 6 digits, for now*/

    siStrLen = strlen(buffer);
    cTempChar[0] = FINAL_CHAR; /* This step was add for performance. The command strcspn needs "" (const char *) */
    siTeminador = strcspn(buffer,cTempChar);
    /* Check if FINAL_CHAR is inide the buffer limits */
    if ( siTeminador < siStrLen ) {

        /* Check if in the buffer has Initiator Char and verify if is before the FINAL_CHAR */
    	cTempChar[0] = START_REQUEST_CHAR; /* This step was add for performance. The command strcspn needs "" (const char *) */
        siIniReq = strcspn(buffer, cTempChar);
        cTempChar[0] = START_REPLY_CHAR; /* This step was add for performance. The command strcspn needs "" (const char *) */
        siIniResp = strcspn(buffer, cTempChar);
        /* Get only the first ocurrance of command*/
        siIniReq = min_sim(siIniReq, siIniResp);

        /* Found a full command inside the buffer*/
        if ( siIniReq < siTeminador ) {

        	memset( &(inteiro) , 0 , sizeof( inteiro ) );
        	p_inteiro = inteiro;

            /*Check if the packet has crc*/
        	cTempChar[0] = SEPARATOR_CRC; /* This step was add for performance. The command strcspn needs "" (const char *) */
            siCRC = strcspn(buffer, cTempChar);
            if ( ( siCRC >  siIniReq ) && (siCRC < siTeminador) ) {

                xPerParcedBuffer->ucCalculatedCRC8 = ucCrc8wInit(buffer[siIniReq] , (siCRC - siIniReq) );
                xPerParcedBuffer->ucType = buffer[siIniReq];
                xPerParcedBuffer->cCommand = buffer[siIniReq+1];
                xPerParcedBuffer->ucNofBytes = 0;
                memset( xPerParcedBuffer->usiValues , 0 , SIZE_UCVALUES);
                i = siIniReq + 3; /* "?C:i..." */
                do {
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

                    /* The last block in the message is the CRC*/
                    if (c == FINAL_CHAR) {
                        xPerParcedBuffer->ucMessageCRC8 = (unsigned char)atoi( inteiro );
                    } else if ( siStrLen > i ){
                        xPerParcedBuffer->usiValues[min_sim(xPerParcedBuffer->ucNofBytes,SIZE_UCVALUES)] = (unsigned short int)atoi( inteiro );
                        xPerParcedBuffer->ucNofBytes++;
                    } else {
                    	 memset(buffer,0,strlen(buffer));
                    	 bSuccess = FALSE;
                    }
                        
                    p_inteiro = inteiro;
                    
                } while ( (c != FINAL_CHAR) && (siStrLen>i) );

                if ( c != FINAL_CHAR) {
                    memset(buffer,0,strlen(buffer));
                    bSuccess = FALSE;
                } else {
                    bSuccess = TRUE;
                }

                
            } else {
                memset(buffer,0,strlen(buffer));
                bSuccess = FALSE;
            }


           
        } else {
        	/* Malformed command, maybe there is a beggining of the command in this malformad packet (return false and wait for more characters)*/
            bSuccess = FALSE;
            memcpy(&buffer[0], buffer[siTeminador], (siStrLen-siTeminador)+1);
        }
    }

    return bSuccess;
}
