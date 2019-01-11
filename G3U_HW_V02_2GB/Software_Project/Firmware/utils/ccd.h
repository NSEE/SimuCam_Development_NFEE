/*
 * ccd.h
 *
 *  Created on: 10/01/2019
 *      Author: Tiago-Low
 */

#ifndef CCD_H_
#define CCD_H_

#include "../simucam_definitions.h"



typedef struct CcdMemMap{
	unsigned long ulOffsetAddr; /* Initial Addrs for the ccd in the DDR memory */
	unsigned long ulBlockIterator; /* The index block counting that was already sent to the SPW buffer */
} TCcdMemMap;


/* One definition per FEE */
typedef struct CcdDefinitions{
	unsigned short int usiSPrescanN;        /* Number of columns for serial prescan */
	unsigned short int usiSOverscanN;       /* Number of columns for serial overscan */
    unsigned short int usiOLN;              /* OverScan Lines Number */
    unsigned short int usiHalfWidth;        /* CCD half-size (WIDTH) */
    unsigned short int usiHeight;           /* CCD lines (HEIGHT) */        
} TCcdDefinitions;

void vCCDLoadDefaultValues( TCcdDefinitions *ccdDef );
void vCCDChangeValues( TCcdDefinitions *ccdDef, unsigned short int usiHeight, unsigned short int usiOLN, unsigned short int usiHalfWidth,
                                unsigned short int usiSOverscanN, unsigned short int usiSPrescanN  );

#endif /* CCD_H_ */
