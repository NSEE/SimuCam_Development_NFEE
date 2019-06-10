/*
 * ccd.c
 *
 *  Created on: 10/01/2019
 *      Author: Tiago-Low
 */

#include "ccd.h"


void vCCDLoadDefaultValues( TCcdInfos *ccdDef ) {

	ccdDef->usiHeight = xDefaults.usiRows;
	ccdDef->usiOLN = xDefaults.usiOLN;
	ccdDef->usiHalfWidth = xDefaults.usiCols;
	ccdDef->usiSOverscanN = xDefaults.usiOverScanSerial;
	ccdDef->usiSPrescanN = xDefaults.usiPreScanSerial;

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nusiHeight %hu\n", ccdDef->usiHeight);
		fprintf(fp,"usiOLN %hu\n", ccdDef->usiOLN);
		fprintf(fp,"usiHalfWidth %hu\n", ccdDef->usiHalfWidth);
		fprintf(fp,"usiSOverscanN %hu\n", ccdDef->usiSOverscanN);
		fprintf(fp,"usiSPrescanN %hu\n",  ccdDef->usiSPrescanN);
	}
#endif

}

/* Only in NFEE_CONFIG of NFEE_STAND_BY */
/* Will be used to change de values of the CCD definitions from any source */
void vCCDChangeValues( TCcdInfos *ccdDef, unsigned short int usiHeight, unsigned short int usiOLN, unsigned short int usiHalfWidth,
                                unsigned short int usiSOverscanN, unsigned short int usiSPrescanN  ) {

	ccdDef->usiHeight = usiHeight;
	ccdDef->usiOLN = usiOLN;
	ccdDef->usiHalfWidth = usiHalfWidth;
	ccdDef->usiSOverscanN = usiSOverscanN;
	ccdDef->usiSPrescanN = usiSPrescanN;
}
