/*
 * ccd.c
 *
 *  Created on: 10/01/2019
 *      Author: Tiago-Low
 */

#include "ccd.h"


void vCCDLoadDefaultValues( TCcdInfos *ccdDef ) {

    /*  todo: This function supposed to load the values from a SD Card in the future, for now it will load
        hard coded values */
    //bLoadCcdDefsSDCard();

	ccdDef->usiHeight = 4510;
	ccdDef->usiOLN = 30;
	ccdDef->usiHalfWidth = 2255;
	ccdDef->usiSOverscanN = 15;
	ccdDef->usiSPrescanN = 25;
}

/* Only in NFEE_CONFIG of NFEE_STAND_BY */
/* Used to change de values of the CCD definitions from any source */
void vCCDChangeValues( TCcdInfos *ccdDef, unsigned short int usiHeight, unsigned short int usiOLN, unsigned short int usiHalfWidth,
                                unsigned short int usiSOverscanN, unsigned short int usiSPrescanN  ) {

	ccdDef->usiHeight = usiHeight;
	ccdDef->usiOLN = usiOLN;
	ccdDef->usiHalfWidth = usiHalfWidth;
	ccdDef->usiSOverscanN = usiSOverscanN;
	ccdDef->usiSPrescanN = usiSPrescanN;
}
