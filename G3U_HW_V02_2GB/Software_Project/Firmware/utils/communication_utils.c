/*
 * communication_utils.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#include "communication_utils.h"


bool bSendUART512v2 ( char *cBuffer, short int siIdMessage ) {
	INT8U ucErrorCode = 0;;
	unsigned short int ucIL = 0;
	bool bSuccessL = FALSE;

	OSSemPend(xSemCountBuffer512, TICKS_WAITING_FOR_SPACE, &ucErrorCode);
	/* Check if gets The semaphore, if yes means that are some space in the (re)transmission buffer */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* No space in the transmission buffer */
		vFailGetCountSemaphorexBuffer512(); /*Could not send back the semaphore, this is critical.*/
		return bSuccessL;
	}


	/* ---> At this point we know that there is some space in the buffer */


	/* Need to get the Mutex that protects xBuffer128 */
	OSMutexPend(xMutexBuffer128, TICKS_WAITING_MUTEX_RETRANS, &ucErrorCode); /* Wait X ticks = X ms */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex, so we need to give the semaphore back */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp,"Could not get the mutex xMutexBuffer512(128) that protect xBuffer512(128). (bSendUART512v2)\n");
		}
		#endif
		ucErrorCode = OSSemPost(xSemCountBuffer512);
		if ( ucErrorCode != OS_ERR_NONE ) {
			vFailSetCountSemaphorexBuffer512(); /*Could not send back the semaphore, this is critical.*/
		}

		return bSuccessL;
	}


	/* ---> At this point we Have the mutex of the xBuffer128, and we can use it freely */



	/* Search for space */
	for( ucIL = 0; ucIL < N_512; ucIL++)
	{
		if ( xInUseRetrans.b512[ucIL] == FALSE ) {
			/* Clear the buffer */
			memset(xBuffer512[ucIL].buffer, 0, 512);
			/* Making sure that will have some \0 */
			memcpy(xBuffer512[ucIL].buffer, cBuffer, 511);
			xBuffer512[ucIL].usiId = siIdMessage;
			xBuffer512[ucIL].ucNofRetries = 0;
			xBuffer512[ucIL].usiTimeOut = 0;
			xBuffer512[ucIL].bSent = FALSE;
			xInUseRetrans.b512[ucIL] = TRUE;
			break;
		}
	}

	if ( ucIL >= N_512 ) {
		ucErrorCode = OSSemPost(xSemCountBuffer512);
		OSMutexPost(xMutexBuffer128);
		return bSuccessL;
	}

	bSuccessL = TRUE;
	SemCount512--; /* Sure that you get the semaphore */


	/* ---> Now try to get the Mutex that protects the TX of the UART to transmit the message */


	OSMutexPend(xTxUARTMutex, TICKS_WAITING_MUTEX_TX, &ucErrorCode); /* Wait X ticks = X ms */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex of TX */
		/* That's ok, as the message was already put in the retransmission buffer it will be sent by the checker timeout task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp,"Could not get the mutex xTxUARTMutex, but the message is already in the retransmission buffer. (bSendUART128v2)\n");
		}
		#endif
		/* Indicates that this buffer already has a message that should be sent by the retransmission immediately */
		/* Free the Mutex of the xBuffer128 */
		OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
		return bSuccessL;
	}


	/* ---> At this point we have all resources to send the message */


	puts(xBuffer512[ucIL].buffer);
	xBuffer512[ucIL].bSent = TRUE;


	/* ---> Best scenario, giving the mutexes back in the inverse order to avoid deadlock */

	OSMutexPost(xTxUARTMutex);
	OSMutexPost(xMutexBuffer128);

	return bSuccessL;
}



/* Make sure that there is only 127 characters to send */
/* Always, ALWAYS send only an char[128] that you first did a memset(cBuffer,0,128), before put some string on it. */
bool bSendUART128v2 ( char *cBuffer, short int siIdMessage ) {
	INT8U ucErrorCode = 0;;
	unsigned char ucIL = 0;
	bool bSuccessL = FALSE;
	
	OSSemPend(xSemCountBuffer128, TICKS_WAITING_FOR_SPACE, &ucErrorCode);
	/* Check if gets The semaphore, if yes means that are some space in the (re)transmission buffer */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* No space in the transmission buffer */
		vFailGetCountSemaphorexBuffer128(); /*Could not send back the semaphore, this is critical.*/
		return bSuccessL;
	}


	/* ---> At this point we know that there is some space in the buffer */


	/* Need to get the Mutex that protects xBuffer128 */
	OSMutexPend(xMutexBuffer128, TICKS_WAITING_MUTEX_RETRANS, &ucErrorCode); /* Wait X ticks = X ms */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex, so we need to give the semaphore back */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp,"Could not get the mutex xMutexBuffer128 that protect xBuffer128. (bSendUART128v2)\n");
		}
		#endif
		ucErrorCode = OSSemPost(xSemCountBuffer128);
		if ( ucErrorCode != OS_ERR_NONE ) {
			vFailSetCountSemaphorexBuffer128(); /*Could not send back the semaphore, this is critical.*/
		}

		return bSuccessL;
	}
	

	/* ---> At this point we Have the mutex of the xBuffer128, and we can use it freely */


	
	/* Search for space */
	for( ucIL = 0; ucIL < N_128; ucIL++)
	{
		if ( xInUseRetrans.b128[ucIL] == FALSE ) {
			/* Clear the buffer */
			memset(xBuffer128[ucIL].buffer, 0, 128);
			/* Making sure that will have some \0 */
			memcpy(xBuffer128[ucIL].buffer, cBuffer, 127);
			xBuffer128[ucIL].usiId = siIdMessage;
			xBuffer128[ucIL].ucNofRetries = 0;
			xBuffer128[ucIL].usiTimeOut = 0;
			xBuffer128[ucIL].bSent = FALSE;
			xInUseRetrans.b128[ucIL] = TRUE;
			break;
		}
	}

	if ( ucIL >= N_128 ) {
		ucErrorCode = OSSemPost(xSemCountBuffer128);
		OSMutexPost(xMutexBuffer128);
		return bSuccessL;
	}

	bSuccessL = TRUE;
	SemCount128--; /* Sure that you get the semaphore */


	/* ---> Now try to get the Mutex that protects the TX of the UART to transmit the message */


	OSMutexPend(xTxUARTMutex, TICKS_WAITING_MUTEX_TX, &ucErrorCode); /* Wait X ticks = X ms */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex of TX */
		/* That's ok, as the message was already put in the retransmission buffer it will be sent by the checker timeout task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp,"Could not get the mutex xTxUARTMutex, but the message is already in the retransmission buffer. (bSendUART128v2)\n");
		}
		#endif
		/* Indicates that this buffer already has a message that should be sent by the retransmission immediately */
		/* Free the Mutex of the xBuffer128 */
		OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
		return bSuccessL;
	}


	/* ---> At this point we have all resources to send the message */


	puts(xBuffer128[ucIL].buffer);
	xBuffer128[ucIL].bSent = TRUE;


	/* ---> Best scenario, giving the mutexes back in the inverse order to avoid deadlock */

	OSMutexPost(xTxUARTMutex);
	OSMutexPost(xMutexBuffer128);

	return bSuccessL;
}




/* Make sure that there is only 63 characters to send */
/* Always, ALWAYS send only an char[64] that you first did a memset(cBuffer,0,64), before put some string on it. */
bool bSendUART64v2 ( char *cBuffer, short int siIdMessage ) {
	INT8U ucErrorCode = 0;
	unsigned char ucIL = 0;
	bool bSuccessL = FALSE;


	OSSemPend(xSemCountBuffer64, TICKS_WAITING_FOR_SPACE, &ucErrorCode);
	/* Check if gets The semaphore, if yes means that are some space in the (re)transmission buffer */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* No space in the transmission buffer */
		vFailGetCountSemaphorexBuffer64(); /*Could not send back the semaphore, this is critical.*/
		return bSuccessL;
	}


	/* ---> At this point we know that there is some space in the buffer */

	
	/* Need to get the Mutex that protects xBuffer64 */
	OSMutexPend(xMutexBuffer64, TICKS_WAITING_MUTEX_RETRANS, &ucErrorCode); /* Wait X ticks = X ms */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex, so we need to give the semaphore back */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp,"Could not get the mutex xMutexBuffer64 that protect xBuffer64. (bSendUART64v2)\n");
		}
		#endif
		ucErrorCode = OSSemPost(xSemCountBuffer64);
		if ( ucErrorCode != OS_ERR_NONE ) {
			vFailSetCountSemaphorexBuffer64(); /*Could not send back the semaphore, this is critical.*/
		}

		return bSuccessL;
	}
	

	/* ---> At this point we Have the mutex of the xBuffer64, and we can use it freely */


	for( ucIL = 0; ucIL < N_64; ucIL++)
	{
		if ( xInUseRetrans.b64[ucIL] == FALSE ) {
			/* Clear the buffer */
			memset(xBuffer64[ucIL].buffer, 0, 64);
			/* Making sure that will have some \0 */
			memcpy(xBuffer64[ucIL].buffer, cBuffer, 63);
			xBuffer64[ucIL].usiId = siIdMessage;
			xBuffer64[ucIL].ucNofRetries = 0;
			xBuffer64[ucIL].usiTimeOut = 0;
			xBuffer64[ucIL].bSent = FALSE;
			xInUseRetrans.b64[ucIL] = TRUE;
			break;
		}
	}


	if ( ucIL >= N_64 ) {
		ucErrorCode = OSSemPost(xSemCountBuffer64);
		OSMutexPost(xMutexBuffer64);
		return bSuccessL;
	}

	bSuccessL = TRUE;
	SemCount64--; /* Sure that you get the semaphore */


	/* ---> Now try to get the Mutex that protects the TX of the UART to transmit the message */


	OSMutexPend(xTxUARTMutex, TICKS_WAITING_MUTEX_TX, &ucErrorCode); /* Wait X ticks = X ms */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex of TX */
		/* That's ok, as the message was already put in the retransmission buffer it will be sent by the checker timeout task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp,"Could not get the mutex xTxUARTMutex, but the message is already in the retransmission buffer. (bSendUART64v2)\n");
		}
		#endif
		/* Indicates that this buffer already has a message that should be sent by the retransmission immediately */
		/* Free the Mutex of the xBuffer64 */
		OSMutexPost(xMutexBuffer64); /* Free the Mutex after use the xBuffer64 */
		return bSuccessL;
	}


	/* ---> At this point we have all resources to send the message */


	puts(xBuffer64[ucIL].buffer);
	xBuffer64[ucIL].bSent = TRUE;


	/* ---> Best scenario, giving the mutexes back in the inverse order to avoid deadlock */
	OSMutexPost(xTxUARTMutex);
	OSMutexPost(xMutexBuffer64);

	return bSuccessL;
}






/* Make sure that there is only 31 characters to send */
/* Always, ALWAYS send only an char[32] that you first did a memset(cBuffer,0,32), before put some string on it. */
bool bSendUART32v2 ( char *cBuffer, short int siIdMessage ) {
	INT8U ucErrorCode = 0;
	unsigned char ucIL = 0;
	bool bSuccessL = FALSE;
	

	OSSemPend(xSemCountBuffer32, TICKS_WAITING_FOR_SPACE, &ucErrorCode);
	/* Check if gets The semaphore, if yes means that are some space in the (re)transmission buffer */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* No space in the transmission buffer */
		vFailGetCountSemaphorexBuffer32(); /*Could not send back the semaphore, this is critical.*/
		return bSuccessL;
	}


	/* ---> At this point we know that there is some space in the buffer */


	/* Need to get the Mutex that protects xBuffer32 */
	OSMutexPend(xMutexBuffer32, TICKS_WAITING_MUTEX_RETRANS, &ucErrorCode); /* Wait X ticks = X ms */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex, so we need to give the semaphore back */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp,"Could not get the mutex xMutexBuffer32 that protect xBuffer32. (bSendUART32v2)\n");
		}
		#endif
		ucErrorCode = OSSemPost(xSemCountBuffer32);
		if ( ucErrorCode != OS_ERR_NONE ) {
			vFailSetCountSemaphorexBuffer32(); /*Could not send back the semaphore, this is critical.*/
		}

		return bSuccessL;
	}
	

	/* ---> At this point we Have the mutex of the xBuffer64, and we can use it freely */


	for( ucIL = 0; ucIL < N_32; ucIL++)
	{
		if ( xInUseRetrans.b32[ucIL] == FALSE ) {
			/* Clear the buffer */
			memset(xBuffer32[ucIL].buffer, 0, 32);
			/* Making sure that will have some \0 */
			memcpy(xBuffer32[ucIL].buffer, cBuffer, 31);
			xBuffer32[ucIL].usiId = siIdMessage;
			xBuffer32[ucIL].ucNofRetries = 0;
			xBuffer32[ucIL].usiTimeOut = 0;
			xBuffer32[ucIL].bSent = FALSE;
			xInUseRetrans.b32[ucIL] = TRUE;
			break;
		}
	}	

	if ( ucIL >= N_32 ) {
		ucErrorCode = OSSemPost(xSemCountBuffer32);
		OSMutexPost(xMutexBuffer32);
		return bSuccessL;
	}
	
	bSuccessL = TRUE;
	SemCount32--; /* Sure that you get the semaphore */


	/* ---> Now try to get the Mutex that protects the TX of the UART to transmit the message */


	OSMutexPend(xTxUARTMutex, TICKS_WAITING_MUTEX_TX, &ucErrorCode); /* Wait X ticks = X ms */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex of TX */
		/* That's ok, as the message was already put in the retransmission buffer it will be sent by the checker timeout task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp,"Could not get the mutex xTxUARTMutex, but the message is already in the retransmission buffer. (bSendUART32v2)\n");
		}
		#endif
		/* Indicates that this buffer already has a message that should be sent by the retransmission immediately */
		/* Free the Mutex of the xBuffer64 */
		OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xMutexBuffer32 */
		return bSuccessL;
	}


	/* ---> At this point we have all resources to send the message */

	puts(xBuffer32[ucIL].buffer);
	xBuffer32[ucIL].bSent = TRUE;

	/* ---> Best scenario, giving the mutexes back in the inverse order to avoid deadlock */


	OSMutexPost(xTxUARTMutex);
	OSMutexPost(xMutexBuffer32);

	return bSuccessL;
}


void vSendEthConf ( void ) {
    char cBufferETH[128] = "";
    unsigned char crc = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

	#if OS_CRITICAL_METHOD == 3
		OS_CPU_SR   cpu_sr;
	#endif

	OS_ENTER_CRITICAL();
	usiIdCMDLocal = usiGetIdCMD();
	OS_EXIT_CRITICAL();

    sprintf(cBufferETH, ETH_SPRINTF, ETH_CMD, usiIdCMDLocal, xConfEth.bDHCP,
                        xConfEth.ucIP[0], xConfEth.ucIP[1], xConfEth.ucIP[2], xConfEth.ucIP[3],
                        xConfEth.ucSubNet[0], xConfEth.ucSubNet[1], xConfEth.ucSubNet[2], xConfEth.ucSubNet[3],
                        xConfEth.ucGTW[0], xConfEth.ucGTW[1], xConfEth.ucGTW[2], xConfEth.ucGTW[3],
                        xConfEth.ucDNS[0], xConfEth.ucDNS[1], xConfEth.ucDNS[2], xConfEth.ucDNS[3],
                        xConfEth.siPortPUS);
    crc = ucCrc8wInit( cBufferETH , strlen(cBufferETH));
    sprintf(cBufferETH, "%s|%hhu;", cBufferETH, crc );

	bSuccees = bSendUART128v2(cBufferETH, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendEthConfUART();
	}
}


void vSendTurnOff ( void ) {
    char cBufferTurnOff[32] = "";
    unsigned char crc = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

	#if OS_CRITICAL_METHOD == 3
		OS_CPU_SR   cpu_sr;
	#endif

	OS_ENTER_CRITICAL();
	usiIdCMDLocal = usiGetIdCMD();
	OS_EXIT_CRITICAL();

	/* Creating the packet with the CRC */
    sprintf(cBufferTurnOff, TURNOFF_SPRINTF, usiIdCMDLocal);
    crc = ucCrc8wInit( cBufferTurnOff , strlen(cBufferTurnOff));
    sprintf(cBufferTurnOff, "%s|%hhu;", cBufferTurnOff, crc );

	bSuccees = bSendUART32v2(cBufferTurnOff, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendTurnOff();
	}
}

void vSendBufferChar128( const char * cDataIn ) {
    char cBufferL[128] = "";
    unsigned char crc = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

	#if OS_CRITICAL_METHOD == 3
		OS_CPU_SR   cpu_sr;
	#endif

	OS_ENTER_CRITICAL();
	usiIdCMDLocal = usiGetIdCMD();
	OS_EXIT_CRITICAL();

	/* Creating the packet with the CRC */
    sprintf(cBufferL, cDataIn, usiIdCMDLocal);
    crc = ucCrc8wInit( cBufferL , strlen(cBufferL));
    sprintf(cBufferL, "%s|%hhu;", cBufferL, crc );

	bSuccees = bSendUART128v2(cBufferL, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
		vCouldNotSendGenericMessageInternalCMD();
	}
}


void vSendReset ( void ) {
    char cBufferTurnOff[32] = "";
    unsigned char crc = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

	#if OS_CRITICAL_METHOD == 3
		OS_CPU_SR   cpu_sr;
	#endif

	OS_ENTER_CRITICAL();
	usiIdCMDLocal = usiGetIdCMD();
	OS_EXIT_CRITICAL();

	/* Creating the packet with the CRC */
    sprintf(cBufferTurnOff, RESET_SPRINTF, usiIdCMDLocal);
    crc = ucCrc8wInit( cBufferTurnOff , strlen(cBufferTurnOff));
    sprintf(cBufferTurnOff, "%s|%hhu;", cBufferTurnOff, crc );

	bSuccees = bSendUART32v2(cBufferTurnOff, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendTurnOff();
	}
}

void vSendLog ( const char * cDataIn ) {
    char cBufferLog[128] = "";
    unsigned char crc = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;


	#if OS_CRITICAL_METHOD == 3
		OS_CPU_SR   cpu_sr;
	#endif

	OS_ENTER_CRITICAL();
	usiIdCMDLocal = usiGetIdCMD();
	OS_EXIT_CRITICAL();


	/* Creating the packet with the CRC */
    sprintf(cBufferLog, LOG_SPRINTF, usiIdCMDLocal, cDataIn);
    crc = ucCrc8wInit( cBufferLog , strlen(cBufferLog));
    sprintf(cBufferLog, "%s|%hhu;", cBufferLog, crc );

	bSuccees = bSendUART128v2(cBufferLog, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendLog();
	}
}

void vLogSendErrorChars(char layer, char type, char subtype, char severity) {
	/* Send Error to NUC */
	char cLogSend[32];
	memset(cLogSend,0,32);
	cLogSend[0] = layer;
	cLogSend[1] = ':';
	cLogSend[2] = type;
	cLogSend[3] = ':';
	cLogSend[4] = subtype;
	cLogSend[5] = ':';
	cLogSend[6] = severity;
	vSendLogError(cLogSend);	
}

void vSendLogError ( const char * cDataIn ) {
    char cBufferLog[32] = "";
    unsigned char crc = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

	#if OS_CRITICAL_METHOD == 3
		OS_CPU_SR   cpu_sr;
	#endif

	OS_ENTER_CRITICAL();
	usiIdCMDLocal = usiGetIdCMD();
	OS_EXIT_CRITICAL();

	/* Creating the packet with the CRC */
    sprintf(cBufferLog, LOG_SPRINTFERROR, usiIdCMDLocal, cDataIn);
    crc = ucCrc8wInit( cBufferLog , strlen(cBufferLog));
    sprintf(cBufferLog, "%s|%hhu;", cBufferLog, crc );

	bSuccees = bSendUART32v2(cBufferLog, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendLog();
	}
}

unsigned short int usiGetIdCMD ( void ) {
    if ( usiIdCMD > 65534 )
        usiIdCMD = 2;
    else
        usiIdCMD++;

    return usiIdCMD;
}

inline short int siPosStr( char *buffer, char cValue) {
    char cTempChar[2] = "";
    cTempChar[0] = cValue; /* This step was add for performance. The command strcspn needs "" (const char *) */
    return strcspn(buffer, cTempChar);
}


void vTimeoutCheck (void *p_arg)
{
	INT8U error_code;

	/* Time to check the (re)transmission buffers, posting a semaphore to sync the task that will threat timeout logic (vTimeoutCheckerTask) */
	error_code = OSSemPost(xSemTimeoutChecker);
	if ( error_code != OS_ERR_NONE ) {
		vFailPostBlockingSemTimeoutTask();
	}
}


/* Send through a medium buffer */
void vSendPusTM64 ( tTMPus xPcktPus ) {
    char cBufferPus[64] = "";
    unsigned char crc = 0;
	unsigned char ucIL = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

	#if OS_CRITICAL_METHOD == 3
		OS_CPU_SR   cpu_sr;
	#endif

	OS_ENTER_CRITICAL();
	usiIdCMDLocal = usiGetIdCMD();
	OS_EXIT_CRITICAL();

	/* Start with the beginning of the PUS header values */
	sprintf(cBufferPus, PUS_TM_SPRINTF, usiIdCMDLocal, xPcktPus.usiPid, xPcktPus.usiCat, xPcktPus.usiType, xPcktPus.usiSubType, xPcktPus.usiPusId );
	/* Add how many parameters need to send in the command */
	for(ucIL = 0; ucIL < xPcktPus.ucNofValues; ucIL++)
	{
		sprintf(cBufferPus, PUS_ADDER_SPRINTF, cBufferPus, xPcktPus.usiValues[ucIL] );
	}
	/* Calculate the crc, append it and finish the string with ";" character */
    crc = ucCrc8wInit( cBufferPus , strlen(cBufferPus));
    sprintf(cBufferPus, "%s|%hhu;", cBufferPus, crc );

	bSuccees = bSendUART64v2(cBufferPus, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendTMPusCommand( cBufferPus );
	}
}

/* Send through a big buffer */
void vSendPusTM128 ( tTMPus xPcktPus ) {
    char cBufferPus[128] = "";
    unsigned char crc = 0;
	unsigned char ucIL = 0;
    unsigned short int usiIdCMDLocal;
	bool bSuccees = FALSE;

	#if OS_CRITICAL_METHOD == 3
		OS_CPU_SR   cpu_sr;
	#endif

	OS_ENTER_CRITICAL();
	usiIdCMDLocal = usiGetIdCMD();
	OS_EXIT_CRITICAL();

	/* Start with the beginning of the PUS header values */
	sprintf(cBufferPus, PUS_TM_SPRINTF, usiIdCMDLocal, xPcktPus.usiPid, xPcktPus.usiCat, xPcktPus.usiType, xPcktPus.usiSubType, xPcktPus.usiPusId );
	/* Add how many parameters need to send in the command */
	for(ucIL = 0; ucIL < xPcktPus.ucNofValues; ucIL++)
	{
		sprintf(cBufferPus, PUS_ADDER_SPRINTF, cBufferPus, xPcktPus.usiValues[ucIL] );
	}
	/* Calculate the crc, append it and finish the string with ";" character */
    crc = ucCrc8wInit( cBufferPus , strlen(cBufferPus));
    sprintf(cBufferPus, "%s|%hhu;", cBufferPus, crc );

	bSuccees = bSendUART128v2(cBufferPus, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendTMPusCommand( cBufferPus );
	}
}


/* Send through a big buffer */
void vSendPusTM512 ( tTMPus xPcktPus ) {
    char cBufferPus[512] = "";
    unsigned char crc = 0;
	unsigned short int usiIL = 0;
    unsigned short int usiIdCMDLocal;
	bool bSuccees = FALSE;

	#if OS_CRITICAL_METHOD == 3
		OS_CPU_SR   cpu_sr;
	#endif

	OS_ENTER_CRITICAL();
	usiIdCMDLocal = usiGetIdCMD();
	OS_EXIT_CRITICAL();

	/* Start with the beginning of the PUS header values */
	sprintf(cBufferPus, PUS_TM_SPRINTF, usiIdCMDLocal, xPcktPus.usiPid, xPcktPus.usiCat, xPcktPus.usiType, xPcktPus.usiSubType, xPcktPus.usiPusId );
	/* Add how many parameters need to send in the command */
	for(usiIL = 0; usiIL < xPcktPus.ucNofValues; usiIL++)
	{
		sprintf(cBufferPus, PUS_ADDER_SPRINTF, cBufferPus, xPcktPus.usiValues[usiIL] );
	}
	/* Calculate the crc, append it and finish the string with ";" character */
    crc = ucCrc8wInit( cBufferPus , strlen(cBufferPus));
    sprintf(cBufferPus, "%s|%hhu;", cBufferPus, crc );

	bSuccees = bSendUART512v2(cBufferPus, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendTMPusCommand( cBufferPus );
	}
}




/* TM_SCAM_TEST_CONNECTION */
/* 
hp-pck-type		hp-pid		hp-pcat		hp-srv-type		hp-srv-subtype
0				112			0			17				2
*/
void vTMPusTestConnection( unsigned short int usiPusId ) {
	tTMPus xTmPusL;

	/* For now is hardcoded after full release of the pus I will create defines */
	xTmPusL.usiPusId = usiPusId;
	xTmPusL.usiPid = 112;
	xTmPusL.usiCat = 0;
	xTmPusL.usiType = 17;
	xTmPusL.usiSubType = 2;
	xTmPusL.ucNofValues = 0;

	vSendPusTM64( xTmPusL );
}
