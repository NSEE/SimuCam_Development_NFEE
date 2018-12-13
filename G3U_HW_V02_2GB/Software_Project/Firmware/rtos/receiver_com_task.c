
#include "receiver_com_task.h"


tReceiverStates eReceiverMode;

/*  This function implements the task that will receive packet via UART
    also need to parse the command in order to send to the MEB task */
void vReceiverComTask(void *task_data)
{
    bool bSucess = FALSE;
    eReceiverMode = sConfiguring;
    char cReceiveBuffer[SIZE_RCV_BUFFER];
    char cTempBuffer[SIZE_RCV_BUFFER];
    short int siStrLen;
    short int siStrLenTemp;
    tPreParsed xPerParcedBuffer;
    
    for(;;)
    {
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
                    gets(cReceiveBuffer);
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
                memset(cReceiveBuffer,0,SIZE_RCV_BUFFER);
                do
                {
                    siStrLen = strnlen(cReceiveBuffer);
                    memset(cTempBuffer,0,SIZE_RCV_BUFFER);
                    gets(cTempBuffer);
                    siStrLenTemp = strnlen(cTempBuffer);
                    memcpy(&cReceiveBuffer[siStrLen], cTempBuffer, siStrLenTemp+1);

                    bSucess = bPreParser( cReceiveBuffer , &xPerParcedBuffer );
                } while ( bSucess == FALSE );
                /* Will not pre parser until the command is completed with ';' */
                if ( xPerParcedBuffer->cCommand == 's' ) {
                    eReceiverMode = sReceiving;

                    /*Enviar mensagem para a tarefa sender para sair do estado de inicialização*/

                } else {
                    eReceiverMode = sWaitingConn;
                }

                break;
            case sReceiving:
                
                bSucess = FALSE;
                memset(cReceiveBuffer,0,SIZE_RCV_BUFFER);
                do
                {
                    siStrLen = strnlen(cReceiveBuffer);
                    memset(cTempBuffer,0,SIZE_RCV_BUFFER);
                    gets(cTempBuffer);
                    siStrLenTemp = strnlen(cTempBuffer);
                    memcpy(&cReceiveBuffer[siStrLen], cTempBuffer, siStrLenTemp+1);

                    bSucess = bPreParser( cReceiveBuffer , &xPerParcedBuffer );
                } while ( bSucess == FALSE );
                /* Will not pre parser until the command is completed with ';' */

                eReceiverMode = sParsing;

                break;
            case sParsing:
                /* At this point we have a preparsed command in the variable xPerPaecedBufer */

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
    bool bEOF = FALSE;
    short int siStrLen, siTeminador, siIniReq, siIniResp, siCRC;
	char c, i, *p_inteiro;
	char inteiro[6]; /* Max size of parsed value is 6 digits, for now*/

    siStrLen = strlen(buffer);
    siTeminador = strcspn(buffer,FINAL_CHAR);

    /* Check if FINAL_CHAR is inide the buffer limits */
    if ( siTeminador < siStrLen ) {

        /* Check if in the buffer has Initiator Char and verify if is before the FINAL_CHAR */
        siIniReq = strcspn(buffer, START_REQUEST_CHAR);
        siIniResp = strcspn(buffer, START_REPLY_CHAR);
        /* Get only the first ocurrance of command*/
        siIniReq = min_sim(siIniReq, siIniResp);

        /* Found a full command inside the buffer*/
        if ( siIniReq < siTeminador ) {

            siCRC = strcspn(buffer, SEPARATOR_CRC);

            xPerParcedBuffer->ucCalculatedCRC8 = ucCrc8wInit(buffer[siIniReq] , (siCRC - siIniReq) );

            xPerParcedBuffer->ucType = buffer[siIniReq];
            xPerParcedBuffer->cCommand = buffer[siIniReq+1];
            xPerParcedBuffer->ucNofBytes = 0;
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
                } while ( ( c != SEPARATOR_CHAR ) && ( c != FINAL_CHAR ) && ( c != SEPARATOR_CRC ) ); //ASCII: 58 = ':' 59 = ';' and '|'
                (*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

                /* The last block in the message is the CRC*/
                if (c == FINAL_CHAR) {
                    xPerParcedBuffer->ucMessageCRC8 = (unsigned char)atoi( inteiro );
                } else {
                    xPerParcedBuffer->ucBytes[min_sim(xPerParcedBuffer->ucNofBytes,SIZE_UCVALUES)] = (unsigned short int)atoi( inteiro );
                    xPerParcedBuffer->ucNofBytes++;
                }
                    
                p_inteiro = inteiro;
                
            } while ( c != FINAL_CHAR );            
            bSuccess = TRUE;
        } else {
        /* Malformed command, maybe there is a beggining of the command in this malformad packet (return false and wait for more characters)*/
            bSuccess = FALSE;
        }
    }

    return bSuccess;
}