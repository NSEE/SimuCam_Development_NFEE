/*
 * ccd.h
 *
 *  Created on: 10/01/2019
 *      Author: Tiago-Low
 */

#ifndef CCD_H_
#define CCD_H_

#include "../simucam_definitions.h"
#include "configs_simucam.h"

#define BYTES_PER_PIXEL		2

union LastMask{
    unsigned char ucByte[8];
    unsigned long long ullWord;
};

/* There's a left and right side for each CCD, and CcdMemMap has an instance for each half CCD */
typedef struct CcdMemMap{
	unsigned long ulOffsetAddr;     /* (bytes) Initial Addrs for the ccd in the DDR memory */
	unsigned long ulBlockI;         /* (blocks) The index block counting that was already sent to the SPW buffer */
    unsigned long ulAddrI;          /* (bytes) The index of the beggining of the next block */
} TCcdMemMap;

typedef struct FullCcdMemMap{
	TCcdMemMap xLeft;               /* Memory Mapping of the Left CCD */
	TCcdMemMap xRight;              /* Memory Mapping of the Right CCD */
} TFullCcdMemMap;

/* Same for the all 4 CCDs of the FEE */
typedef struct CcdMemDef{
	unsigned long usiNTotalBlocks;     /* Total of 17 line memorys (16 lines for pixels + 1 for mask) */
	unsigned long usiTotalBytes;            /* Total os bytes of a half CCD including the mask lines */
    unsigned char ucPaddingBytes;           /* How many bytes need to be filled with zero padding in the last memory line that has pixels */
    union LastMask ucPaddingMask;	        /* Last mask with zero padding */
    unsigned long ulVStart;	/* (bytes) Add transparency to the start and end of the CCD transmission */
    unsigned long ulVEnd;	/* (bytes) Add transparency to the start and end of the CCD transmission */
    unsigned long ulHStart;	/* (bytes) Add transparency to the start and end of the CCD transmission */
    unsigned long ulHEnd;	/* (bytes) Add transparency to the start and end of the CCD transmission */
} TCcdMemDef;

/* One CCD Info per FEE */
typedef struct CcdInfos{
	unsigned short int usiSPrescanN;        /* Number of columns for serial prescan */
	unsigned short int usiSOverscanN;       /* Number of columns for serial overscan */
    unsigned short int usiOLN;              /* OverScan Lines Number */
    unsigned short int usiHalfWidth;        /* CCD half-size (WIDTH) */
    unsigned short int usiHeight;           /* CCD lines (HEIGHT) */        
} TCcdInfos;



void vCCDLoadDefaultValues( TCcdInfos *ccdDef );
void vCCDChangeValues( TCcdInfos *ccdDef, unsigned short int usiHeight, unsigned short int usiOLN, unsigned short int usiHalfWidth,
                                unsigned short int usiSOverscanN, unsigned short int usiSPrescanN  );

#endif /* CCD_H_ */
