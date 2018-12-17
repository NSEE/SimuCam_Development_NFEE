
#include "receiver_com_task.h"


/*  This function implements the task that will receive packet via UART
    also need to parse the command in order to send to the MEB task */
void vReceiverComTask(void *task_data)
{
    bool bSuccess = FALSE;
    INT8U error_code;
    tReceiverStates eReceiverMode;
    char cReceiveBuffer[SIZE_RCV_BUFFER];
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
            	bSuccess = FALSE;

                memset(cReceiveBuffer, 0, SIZE_RCV_BUFFER);
                scanf("%s", cReceiveBuffer);
                bSuccess = bPreParser( cReceiveBuffer , &xPreParsedBuffer );

                if ( bSuccess ) {
                    eReceiverMode = sInitParsing;
                } else {
                    eReceiverMode = sHandlingError;
                    xPreParsedBuffer.ucErrorFlag = eBadFormatInit;
                }

                break;
            case sInitParsing:
                /* Check CRC8 */
                if ( xPreParsedBuffer.ucCalculatedCRC8 == xPreParsedBuffer.ucMessageCRC8 ) {
                    eReceiverMode = sReceiving;
                    /* Post Semaphore to tell to vSenderComTask to stop sending status packet*/
                    error_code = OSSemPost(xSemCommInit);

                    if ( error_code != OS_ERR_NONE ) {
                        eReceiverMode = sHandlingError;
                        xPreParsedBuffer.ucErrorFlag = eSemErrorInit;
                        #ifdef DEBUG_ON
                            debug(fp,"Can't post semaphore to SenderTask.\n");
                        #endif
                    }
                    
                } else {
                    eReceiverMode = sHandlingError;
                    xPreParsedBuffer.ucErrorFlag = eCRCErrorInit;
                    #ifdef DEBUG_ON
                        debug(fp,"CRC Fail. sInitParsing.\n");
                    #endif
                }

                break;                
            case sReceiving:

            	bSuccess = FALSE;

                memset(cReceiveBuffer, 0, SIZE_RCV_BUFFER);
                scanf("%s", cReceiveBuffer);
                bSuccess = bPreParser( cReceiveBuffer , &xPreParsedBuffer );

                if ( bSuccess ) {
                    eReceiverMode = sParsing;
                } else {
                    eReceiverMode = sHandlingError;
                    xPreParsedBuffer.ucErrorFlag = eBadFormat;
                } 

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
                                if ( xPreParsedBuffer.usiValues[0] == CHANGE_MODE_SEQUENCE ) {
                                    /* Change to Piping mode */
                                    eReceiverMode = sPiping;
                                } else {
                                    eReceiverMode = sReceiving;
                                }
                                break;
                            case 'C':
                                /* Send the ethernet configuration */
                                break;
                            default:
                                break;
                        }
                    }
                } else {
                	eReceiverMode = sHandlingError;
                    xPreParsedBuffer.ucErrorFlag = eCRCError;
                }

                break;
            case sSendingMEB:
                /* code */
                break;
            case sHandlingError:
                
                eReceiverMode = tErrorHandlerFunc (&xPreParsedBuffer);

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
    short int siStrLen, siTeminador, siIniReq, siIniResp, siIniACK, siIniNACK, siCRC;
	char c, i, *p_inteiro;
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
    siCRC = strcspn(buffer, SEPARATOR_CRC);

    /* Check if there is [!|?] , |, ; in the packet*/
    if ( (siTeminador == (siStrLen-1)) && (siCRC < siTeminador) && (siIniReq < siCRC) ) {

        xPerParcedBuffer->ucCalculatedCRC8 = ucCrc8wInit(&buffer[siIniReq] , (siCRC - siIniReq) );
        xPerParcedBuffer->ucType = buffer[siIniReq];

        if (xPerParcedBuffer->ucType == NACK_CHAR ) {
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

            if ( c == FINAL_CHAR)
                bSuccess = TRUE;
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

inline short int siPosStr( char *buffer, char cValue) {
    char cTempChar[2] = "";
    cTempChar[0] = cValue; /* This step was add for performance. The command strcspn needs "" (const char *) */
    return strcspn(buffer, cTempChar);
}

inline tReceiverStates tErrorHandlerFunc( tPreParsed *xPerParcedBuffer ) {
    tReceiverStates xReturnState;
    
    switch (xPerParcedBuffer->ucErrorFlag)
    {
        case eBadFormatInit:
            /* Enviar error Não entendimento */
            xReturnState = sWaitingConn;
            break;
        case eCRCErrorInit:
            /* Enviar erro de CRC */
            xReturnState = sWaitingConn;
            break;
        case eSemErrorInit:
            /* Não enviar error, tentar resolver internamente, senao erro critico */
            break;
        case eBadFormat:
            /* Enviar error Não entendimento */
            xReturnState = sReceiving;
            break;
        case eCRCError:
            /* Enviar erro de CRC */
            xReturnState = sReceiving;
            break;
        case eNoError:
            xReturnState = sReceiving;
            #ifdef DEBUG_ON
                debug(fp,"No error. Why Handling Error?. (tErrorHandlerFunc)\n");
            #endif 
            break;
        default:
            break;
    }
    #ifdef DEBUG_ON
        debug(fp,"(tErrorHandlerFunc)\n");
    #endif     

    return xReturnState;
}

void vSendEthConf (void) {





}