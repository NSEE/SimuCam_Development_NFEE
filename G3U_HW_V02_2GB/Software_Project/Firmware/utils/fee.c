/*
 * fee.c
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */

#include "fee.h"

void vNFeeNotInUse( TNFee *pxNfeeL, unsigned char ucIdNFEE ) {

    /* NFEE id [0..7] */
    pxNfeeL->ucId = ucIdNFEE;
    pxNfeeL->xControl.bEnabled = FALSE;
    pxNfeeL->xControl.bUsingDMA = FALSE;
}


/* Initialize the structure of control of NFEE with the default Configurations */
void vNFeeStructureInit( TNFee *pxNfeeL, unsigned char ucIdNFEE ) {
    unsigned char ucIL = 0;

    /* NFEE id [0..5] */
    pxNfeeL->ucId = ucIdNFEE;

    /* Load the default values of the CCDs regarding pixels configuration */
    vCCDLoadDefaultValues(&pxNfeeL->xCcdInfo);

    /* Update the values of memory mapping for this FEE */
    vUpdateMemMapFEE(pxNfeeL);

    /* Initilizing control variables */
    pxNfeeL->xControl.bEnabled = TRUE;
    pxNfeeL->xControl.bUsingDMA = FALSE;
    /* The NFEE initialize in the Config mode by default */
    pxNfeeL->xControl.eMode = sFeeConfig;    

    /*  todo: This function supposed to load the values from a SD Card in the future, for now it will load
        hard coded values */
    //bLoadNFEEDefsSDCard(); !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    /* Set the default redout order [ 0, 1, 2, 3 ] */
    for ( ucIL = 0; ucIL < 4; ucIL++) 
        pxNfeeL->xControl.ucROutOrder[ucIL] = ucIL;
    /* The default side is left */
    pxNfeeL->xControl.eSide = sLeft;
    pxNfeeL->xControl.bEchoing = FALSE;
    pxNfeeL->xControl.bLogging = FALSE;
    pxNfeeL->xControl.bChannelEnable = FALSE;

}

/* Update the memory mapping for the FEE due to the CCD informations */
void vUpdateMemMapFEE( TNFee *pxNfeeL ) {
    unsigned long ulTotalSizeL = 0; /* pixels */
    unsigned long ulMemLinesL = 0; /* mem lines */
    unsigned long ulTotalMemLinesL = 0;
    unsigned long ulMemLeftBytesL = 0; /* bytes */
    unsigned long ulMemLeftLinesL = 0; /* mem lines */
    unsigned long ulMaskMemLinesL = 0; /* mem lines */
    unsigned char ucPixelsInLastBlockL = 0;
    unsigned char ucShiftsL = 0;
    unsigned char ucIL = 0;
    unsigned long ulLastOffset = 0;
    unsigned long ulStepHalfCCD = 0;


    /* Size of the footprint of the CCD in the DDR memory */
    pxNfeeL->xMemMap.ulTotalBytes = ( OFFSET_STEP_FEE );

    /* Offset of the FEE in the DDR memory */
    pxNfeeL->xMemMap.ulOffsetRoot = OFFSET_STEP_FEE * pxNfeeL->ucId;

    /* LUT Addrs */
    pxNfeeL->xMemMap.ulLUTAddr = LUT_INITIAL_ADDR + pxNfeeL->xMemMap.ulOffsetRoot;

    /* (HEIGHT + usiOLN)*(usiSPrescanN + usiSOverscanN + usiHalfWidth) */
    ulTotalSizeL =  ( pxNfeeL->xCcdInfo.usiHeight + pxNfeeL->xCcdInfo.usiOLN ) *
                    ( pxNfeeL->xCcdInfo.usiHalfWidth + pxNfeeL->xCcdInfo.usiSOverscanN + pxNfeeL->xCcdInfo.usiSPrescanN );

    /* Total size in Bytes of a half CCD */
    pxNfeeL->xMemMap.xCommon.usiTotalBytes = ulTotalSizeL * BYTES_PER_PIXEL;

    /* Total of Memory lines (64 bits memory) */
    ulMemLinesL = (unsigned long) pxNfeeL->xMemMap.xCommon.usiTotalBytes / BYTES_PER_MEM_LINE;
    ulMemLeftBytesL = pxNfeeL->xMemMap.xCommon.usiTotalBytes % BYTES_PER_MEM_LINE;   /* Word memory Alignment check: how much bytes left not align in the last word of the memory */
    if ( ulMemLeftBytesL > 0 ) {
        ulMemLinesL = ulMemLinesL + 1;
        pxNfeeL->xMemMap.xCommon.usiTotalBytes = pxNfeeL->xMemMap.xCommon.usiTotalBytes - ulMemLeftBytesL + BYTES_PER_MEM_LINE; /* Add a full line, after will be filled with zero padding */
        pxNfeeL->xMemMap.xCommon.ucPaddingBytes = BYTES_PER_MEM_LINE - ulMemLeftBytesL;
    } else {
        pxNfeeL->xMemMap.xCommon.ucPaddingBytes = 0;
    }

    /* At this point we have mapping the pixel in the CCD and calculate the zero padding for the last WORD of the line memory of the half ccd */

    /* For every 16 mem line will be 1 mask mem line */
    ulMaskMemLinesL = (unsigned long) ulMemLinesL / BLOCK_MEM_SIZE;
    ulMemLeftLinesL = ulMemLinesL % BLOCK_MEM_SIZE;
    if ( ulMemLeftLinesL >= 1 ) {
        ulMaskMemLinesL = ulMaskMemLinesL + 1;
        ulTotalMemLinesL = ( ulMemLinesL - ulMemLeftLinesL + BLOCK_MEM_SIZE ) + ulMaskMemLinesL; /* One extra 16 sized block, will be filled with zero padding the ret os spare lines */
    } else {
        ulTotalMemLinesL = ulMemLinesL + ulMaskMemLinesL;
    }

    /* Calculating how is the final mask with zero padding */
    if ( ulMemLeftBytesL >= 1 ) {
        ucPixelsInLastBlockL = (unsigned char) (( ulMemLeftLinesL * PIXEL_PER_MEM_LINE ) + (unsigned int) ( ulMemLeftBytesL / BYTES_PER_PIXEL ));
    } else {
        ucPixelsInLastBlockL = (unsigned char) ( ulMemLeftLinesL * PIXEL_PER_MEM_LINE );
    }

    /* 16 * 4 = 64 - (number of pixels in the last block)) */
    ucShiftsL = ( BLOCK_MEM_SIZE * PIXEL_PER_MEM_LINE ) - ucPixelsInLastBlockL;

    /* WARNING: Verify the memory alocation (endianess) */
    pxNfeeL->xMemMap.xCommon.ucPaddingMask.ullWord = (unsigned long long)(0xFFFFFFFFFFFFFFFF >> ucShiftsL);

    /* Number of block is te same as the number of line masks in the memory */
    pxNfeeL->xMemMap.xCommon.usiNTotalBlocks = ulMaskMemLinesL;

    /* Set the addr for every CCD of the FEE, left and right sides */
    ulLastOffset = pxNfeeL->xMemMap.ulOffsetRoot + RESERVED_FEE_X + RESERVED_HALF_CCD_X;
    ulStepHalfCCD = RESERVED_HALF_CCD_X + pxNfeeL->xMemMap.xCommon.usiTotalBytes;
    for ( ucIL = 0; ucIL < 4; ucIL++ ) {
        pxNfeeL->xMemMap.xCcd[ ucIL ].xLeft.ulOffsetAddr = ulLastOffset;
        ulLastOffset = ulLastOffset + ulStepHalfCCD;
        pxNfeeL->xMemMap.xCcd[ ucIL ].xRight.ulOffsetAddr = ulLastOffset; 
        ulLastOffset = ulLastOffset + ulStepHalfCCD;
    }
}

/* Load the default configuration of the SPW/RMAP */
void vFeeSpwRMAPLoadDefault( TNFee *pxNfeeL ) {
    //bGetSpwRmapSDCard();
    //todo: For now is hardcoded
    //todo: Verificar qual a estrutura usar para as configurações
}

/* Only in NFEE_CONFIG */
/* Change the active configuration of the SPW/RMAP */
void vFeeSpwRMAPChangeConfig( TNFee *pxNfeeL ) {
    //todo: Verificar qual a estrutura usar para as configurações
}

/* Only in NFEE_CONFIG */
/* Change the default configuration of the SPW/RMAP */
void vFeeSpwRMAPChangeDefault( TNFee *pxNfeeL ) {
    //bSaveSpwRmapSDCard();
    //todo: Verificar qual a estrutura usar para as configurações, enviar o numero do FEE tbm
}

/* Any mode */
/* Enable SPW channel for the FEE */
void cFeeSpwChannelEnable( TNFee *pxNfeeL ) {
    //todo: Verificar com o França
}

/* Any mode */
/* Disable SPW channel for the FEE */
void cFeeSpwChannelDisable( TNFee *pxNfeeL ) {
    //todo: Verificar com o França
}

/* Any mode */
/* Dump and send using PUS the RMAP Configuration areas [NFEESIM-UR-699] */
void cFeeRMAPDump( TNFee *pxNfeeL ) {

    //todo: ler as areas de memoria do RMAP e enviar via ethernet

}

/* Any mode */
/* Allow the user to activate the echo mode for RMAP [NFEESIM-UR-588]  */
void cFeeRMAPEchoingEnable( TNFee *pxNfeeL ) {
    pxNfeeL->xControl.bEchoing = TRUE;
}

/* Any mode */
/* Allow the user to disable the echo mode for RMAP [NFEESIM-UR-589]  */
void cFeeRMAPEchoingDisable( TNFee *pxNfeeL ) {
    pxNfeeL->xControl.bEchoing = FALSE;
}

/* Any mode */
/* Allow the user to activate the log of RMAP [NFEESIM-UR-588]  */
void cFeeRMAPLogEnable( TNFee *pxNfeeL ) {
    pxNfeeL->xControl.bLogging = TRUE;
}

/* Any mode */
/* Allow the user to disable the log of RMAP [NFEESIM-UR-589]  */
void cFeeRMAPLogDisable( TNFee *pxNfeeL ) {
    pxNfeeL->xControl.bLogging = FALSE;
}
