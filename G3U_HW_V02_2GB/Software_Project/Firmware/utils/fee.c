/*
 * fee.c
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */

#include "fee.h"



void vCalcMemoryDistribution( unsigned char ucFeeInst ) {
    unsigned long ulTotalSizeL = 0; /* pixels */
    unsigned long ulTotalBytesL = 0; /* bytes */
    unsigned long ulMemLinesL = 0; /* mem lines */
    unsigned long ulMemLeftBytesL = 0; /* bytes */
    unsigned long ulMemLeftLinesL = 0; /* mem lines */
    unsigned long ulMaskMemLinesL = 0; /* mem lines */
    unsigned long ulTotalMemLinesL = 0;

    /* (HEIGHT + usiOLN)*(usiSPrescanN + usiSOverscanN + usiHalfWidth) */
    ulTotalSizeL =   ( xFEECcdDefs[ucFeeInst].usiHeight + xFEECcdDefs[ucFeeInst].usiOLN ) *
                        ( xFEECcdDefs[ucFeeInst].usiHalfWidth + xFEECcdDefs[ucFeeInst].usiSOverscanN + xFEECcdDefs[ucFeeInst].usiSPrescanN );
    
    ulTotalBytesL = ulTotalSizeL * 2;  /* 1 pixel = 2 bytes */
    ulMemLinesL = (unsigned long) ulTotalBytesL / BYTES_PER_MEM_LINE;
    ulMemLeftBytesL = ulTotalBytesL % BYTES_PER_MEM_LINE;   /* Check how much lines will have in the last block */
    if ( ulMemLeftBytesL > 0 ) {
        ulMemLinesL = ulMemLinesL + 1;
        ulTotalBytesL = ulTotalBytesL - ulMemLeftBytesL + BYTES_PER_MEM_LINE; /* Add a full line, after will be filled with zero padding */
    }

    /* Every 16 mem line will be 1 mask mem line */
    ulMaskMemLinesL = (unsigned long) ulMemLinesL / BLOCK_MEM_SIZE;
    ulMemLeftLinesL = ulMemLinesL % BLOCK_MEM_SIZE;
    if ( ulMemLeftLinesL > 0 ) {
        ulMaskMemLinesL = ulMaskMemLinesL + 1;
        ulTotalMemLinesL = ( ulMemLinesL - ulMemLeftLinesL ) + ulMaskMemLinesL + BLOCK_MEM_SIZE; /* One extra 16 sized block, will be filled with zero padding the ret os spare lines */
    } else {
        ulTotalMemLinesL = ulMemLinesL + ulMaskMemLinesL;
    }


    /* todo: There's too many local variables! Use directly the global one */
    xFEEMemMaps[ucFeeInst].ulOffsetRoot = OFFSET_STEP_FEE * ucFeeInst;   /*  Offset root memory for the FEE  */
    xFEEMemMaps[ucFeeInst].ulTotalSizeBytes = ulTotalBytesL;
    xFEEMemMaps[ucFeeInst].ulNMemLines  = ulMemLinesL;
    xFEEMemMaps[ucFeeInst].ulNMaskMemLines = ulMaskMemLinesL;
    xFEEMemMaps[ucFeeInst].ulNTotalMemLines = ulTotalMemLinesL;
    /* The number of blocks is the same of number of line masks. todo: Improvement - Use only the mask number of lines*/
    xFEEMemMaps[ucFeeInst].ulNBlocks17 = ulMaskMemLinesL;
    xFEEMemMaps[ucFeeInst].ucNofLeftBytes = ulMemLeftBytesL;
    xFEEMemMaps[ucFeeInst].ucNofLeftLines = ulMemLeftLinesL;
}