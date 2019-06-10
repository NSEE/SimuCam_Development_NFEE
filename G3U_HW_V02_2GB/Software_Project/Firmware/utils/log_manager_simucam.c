/*
 * logger_manager_simucam.c
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#include "log_manager_simucam.h"


bool bLogWriteSDCard ( const char * cDataIn, const char * cFilename )
{
	return TRUE;
}

/* Prefer to use directly vSendLog, if there's any error use this function */
void vLogWriteNUC ( const char * cDataIn )
{
	char cTemp[114] = "";
	memset(cTemp,0,114);
	memcpy(cTemp,cDataIn, min_sim( strlen(cDataIn), 113 ) ); /* 113 to let a zero terminator in the worst case (truc the message) */
	vSendLog ( cDataIn );
}



