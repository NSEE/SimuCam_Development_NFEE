/*
 * feeV2.c
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */

#include "feeV2.h"


/* Initialize the structure of control of NFEE with the default Configurations */
void vNFeeStructureInit( TNFee *pxNfeeL, unsigned char ucIdNFEE ) {

	/* NFEE id [0..5] */
    pxNfeeL->ucId = ucIdNFEE;

    /* Load the default values of the CCDs regarding pixels configuration */
    vCCDLoadDefaultValues(&pxNfeeL->xCcdInfo);

    /* Update the values of memory mapping for this FEE */
    vUpdateMemMapFEE(pxNfeeL);

    /* Initilizing control variables */
    pxNfeeL->xControl.bEnabled = TRUE;
    pxNfeeL->xControl.bChannelEnable = FALSE;
    pxNfeeL->xControl.bSimulating = FALSE;
    pxNfeeL->xControl.bWatingSync = FALSE;
    pxNfeeL->xControl.bEchoing = FALSE;
    pxNfeeL->xControl.bLogging = FALSE;
    pxNfeeL->xControl.bTransientMode = FALSE;
    /* The default side is left */
    pxNfeeL->xControl.eSide = sLeft;
    pxNfeeL->xControl.ucTimeCode = 0;


    /* The NFEE initialize in the Config mode by default */
    pxNfeeL->xControl.eState = sInit;
    pxNfeeL->xControl.eLastMode = sInit;
    pxNfeeL->xControl.eMode = sInit;
    pxNfeeL->xControl.eNextMode = sInit;

    pxNfeeL->xControl.eDataSource = dsPattern;

    pxNfeeL->ucSPWId = (unsigned char)xDefaultsCH.ucFEEtoChanell[ ucIdNFEE ];

    /* Initialize the structs of the Channel, Double Buffer, RMAP and Data packet */
    if ( bCommInitCh(&pxNfeeL->xChannel, pxNfeeL->ucSPWId ) == FALSE ) {
		#if DEBUG_ON
    	if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
			fprintf(fp, "\n CRITICAL! Can't Initialized SPW Channel %i \n", pxNfeeL->ucId);
    	}
		#endif
    }

    if ( bCommSetGlobalIrqEn( TRUE, pxNfeeL->ucSPWId ) == FALSE ) {
		#if DEBUG_ON
    	if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
			fprintf(fp, "\n CRITICAL! Can't Enable global interrupt for the channel %i \n", pxNfeeL->ucId);
    	}
		#endif
    }

    bDpktGetPixelDelay(&pxNfeeL->xChannel.xDataPacket);
    pxNfeeL->xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay = uliPxDelayCalcPeriodMs(xDefaults.ulStartDelay);
    pxNfeeL->xChannel.xDataPacket.xDpktPixelDelay.uliSkipDelay = uliPxDelayCalcPeriodNs(xDefaults.ulSkipDelay);
    pxNfeeL->xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay = uliPxDelayCalcPeriodNs(xDefaults.ulLineDelay);
    pxNfeeL->xChannel.xDataPacket.xDpktPixelDelay.uliAdcDelay = uliPxDelayCalcPeriodNs(xDefaults.ulADCPixelDelay);
    bDpktSetPixelDelay(&pxNfeeL->xChannel.xDataPacket);

    /* Set the default redout order [ 0, 1, 2, 3 ] */
	pxNfeeL->xControl.ucROutOrder[0] =  pxNfeeL->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
	pxNfeeL->xControl.ucROutOrder[1] =  pxNfeeL->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
	pxNfeeL->xControl.ucROutOrder[2] =  pxNfeeL->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
	pxNfeeL->xControl.ucROutOrder[3] =  pxNfeeL->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;

    /* Copy to control what should be applied in the master Sync - FullImage */
    pxNfeeL->xControl.xErrorSWCtrlFull.bEnabled = FALSE;
    pxNfeeL->xControl.xErrorSWCtrlFull.bMissingData = FALSE;
    pxNfeeL->xControl.xErrorSWCtrlFull.bMissingPkts = FALSE;
    pxNfeeL->xControl.xErrorSWCtrlFull.bTxDisabled = FALSE;
    pxNfeeL->xControl.xErrorSWCtrlFull.ucFrameNum = 0;
    pxNfeeL->xControl.xErrorSWCtrlFull.usiDataCnt = 0;
    pxNfeeL->xControl.xErrorSWCtrlFull.usiNRepeat = 0;
    pxNfeeL->xControl.xErrorSWCtrlFull.usiSequenceCnt = 0;

    /* Copy to control what should be applied in the master Sync - Windowing */
    pxNfeeL->xControl.xErrorSWCtrlWin.bEnabled = FALSE;
    pxNfeeL->xControl.xErrorSWCtrlWin.bMissingData = FALSE;
    pxNfeeL->xControl.xErrorSWCtrlWin.bMissingPkts = FALSE;
    pxNfeeL->xControl.xErrorSWCtrlWin.bTxDisabled = FALSE;
    pxNfeeL->xControl.xErrorSWCtrlWin.ucFrameNum = 0;
    pxNfeeL->xControl.xErrorSWCtrlWin.usiDataCnt = 0;
    pxNfeeL->xControl.xErrorSWCtrlWin.usiNRepeat = 0;
    pxNfeeL->xControl.xErrorSWCtrlWin.usiSequenceCnt = 0;

    bDpktGetTransmissionErrInj(&pxNfeeL->xChannel.xDataPacket);
    pxNfeeL->xChannel.xDataPacket.xDpktTransmissionErrInj.bMissingDataEn = pxNfeeL->xControl.xErrorSWCtrlFull.bMissingData;
    pxNfeeL->xChannel.xDataPacket.xDpktTransmissionErrInj.bMissingPktsEn = pxNfeeL->xControl.xErrorSWCtrlFull.bMissingPkts;
    pxNfeeL->xChannel.xDataPacket.xDpktTransmissionErrInj.bTxDisabledEn = pxNfeeL->xControl.xErrorSWCtrlFull.bTxDisabled;
    pxNfeeL->xChannel.xDataPacket.xDpktTransmissionErrInj.ucFrameNum = pxNfeeL->xControl.xErrorSWCtrlFull.ucFrameNum;
    pxNfeeL->xChannel.xDataPacket.xDpktTransmissionErrInj.usiDataCnt = pxNfeeL->xControl.xErrorSWCtrlFull.usiDataCnt;
    pxNfeeL->xChannel.xDataPacket.xDpktTransmissionErrInj.usiNRepeat = pxNfeeL->xControl.xErrorSWCtrlFull.usiNRepeat;
    pxNfeeL->xChannel.xDataPacket.xDpktTransmissionErrInj.usiSequenceCnt = pxNfeeL->xControl.xErrorSWCtrlFull.usiSequenceCnt;
    bDpktSetTransmissionErrInj(&pxNfeeL->xChannel.xDataPacket);

    pxNfeeL->xControl.xTrap.bEnabledSerial = FALSE;
    pxNfeeL->xControl.xTrap.bEnabled = FALSE;
    pxNfeeL->xControl.xTrap.bPumping = FALSE;
    pxNfeeL->xControl.xTrap.bEmiting = FALSE;
    pxNfeeL->xControl.xTrap.dCI = 0.0;
    pxNfeeL->xControl.xTrap.dSDT = 0.0;
    pxNfeeL->xControl.xTrap.dTotalWait = 0.0;
    pxNfeeL->xControl.xTrap.usiTOI = 0;
    pxNfeeL->xControl.xTrap.usiOVRL = 0;
    pxNfeeL->xControl.xTrap.uliDT = 0;
    pxNfeeL->xControl.xTrap.usiRP = 0;
    pxNfeeL->xControl.xTrap.usiSC = 0;
    pxNfeeL->xControl.xTrap.usiNofSyncstoWait = 0;
    pxNfeeL->xControl.xTrap.ucICountSyncs = 0;

    pxNfeeL->xControl.xTrap.xRestoreDelays.uliAdcDelay = pxNfeeL->xChannel.xDataPacket.xDpktPixelDelay.uliAdcDelay;
    pxNfeeL->xControl.xTrap.xRestoreDelays.uliStartDelay = pxNfeeL->xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay;
    pxNfeeL->xControl.xTrap.xRestoreDelays.uliSkipDelay = pxNfeeL->xChannel.xDataPacket.xDpktPixelDelay.uliSkipDelay;
    pxNfeeL->xControl.xTrap.xRestoreDelays.uliLineDelay = pxNfeeL->xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay;

    /* Just Initial Values */
    pxNfeeL->xCopyRmap.xCopyControl = pxNfeeL->xControl;
    pxNfeeL->xCopyRmap.xCopyMemMap = pxNfeeL->xMemMap;
    pxNfeeL->xCopyRmap.usiCopyPacketLength = pxNfeeL->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength;
    pxNfeeL->xCopyRmap.bCopyDigitaliseEn = pxNfeeL->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn;
    pxNfeeL->xCopyRmap.bCopyReadoutEn = pxNfeeL->xChannel.xFeeBuffer.xFeebMachineControl.bReadoutEn;
    pxNfeeL->xCopyRmap.bCopyChargeInjEn = FALSE;

    pxNfeeL->xCopyRmap.xbRmapChanges.bPacketSize = FALSE;
    pxNfeeL->xCopyRmap.xbRmapChanges.bReadoutOrder = FALSE;
    pxNfeeL->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = FALSE;
    pxNfeeL->xCopyRmap.xbRmapChanges.bhEnd = FALSE;
    pxNfeeL->xCopyRmap.xbRmapChanges.bvStartvEnd = FALSE;
    pxNfeeL->xCopyRmap.xbRmapChanges.bChargeInjection = FALSE;

    pxNfeeL->xDataPktError.ucErrorCnt = 0;
    pxNfeeL->xDataPktError.bStartErrorInj = FALSE;

    pxNfeeL->xImgWinContentErr.ucLeftErrorCnt = 0;
    pxNfeeL->xImgWinContentErr.ucRightErrorCnt = 0;
    pxNfeeL->xImgWinContentErr.bStartLeftErrorInj = FALSE;
    pxNfeeL->xImgWinContentErr.bStartRightErrorInj = FALSE;

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

    pxNfeeL->xMemMap.xCommon.usiTotalBytes = ulTotalMemLinesL * BYTES_PER_MEM_LINE;


    /* Calculating how is the final mask with zero padding */
    if ( ulMemLeftBytesL >= 1 ) {
        ucPixelsInLastBlockL = (unsigned char) (( ulMemLeftLinesL * PIXEL_PER_MEM_LINE ) + (unsigned int) ( ulMemLeftBytesL / BYTES_PER_PIXEL ));
    } else {
        ucPixelsInLastBlockL = (unsigned char) ( ulMemLeftLinesL * PIXEL_PER_MEM_LINE );
    }

    /* 16 * 4 = 64 - (number of pixels in the last block)) */
    ucShiftsL = ( BLOCK_MEM_SIZE * PIXEL_PER_MEM_LINE ) - ucPixelsInLastBlockL;

    /* WARNING: Verify the memory allocation (endianess) */
    pxNfeeL->xMemMap.xCommon.ucPaddingMask.ullWord = (unsigned long long)(0xFFFFFFFFFFFFFFFF << ucShiftsL);

    /* Number of block is te same as the number of line masks in the memory */
    pxNfeeL->xMemMap.xCommon.usiNTotalBlocks = ulMaskMemLinesL;

    /* Set the addr for every CCD of the FEE, left and right sides */
/*    ulLastOffset = pxNfeeL->xMemMap.ulOffsetRoot + RESERVED_FEE_X + RESERVED_HALF_CCD_X;
    ulStepHalfCCD = RESERVED_HALF_CCD_X + pxNfeeL->xMemMap.xCommon.usiTotalBytes;
    for ( ucIL = 0; ucIL < 4; ucIL++ ) {
        pxNfeeL->xMemMap.xCcd[ ucIL ].xLeft.ulOffsetAddr = ulLastOffset;
        ulLastOffset = ulLastOffset + ulStepHalfCCD;
        pxNfeeL->xMemMap.xCcd[ ucIL ].xRight.ulOffsetAddr = ulLastOffset;
        ulLastOffset = ulLastOffset + ulStepHalfCCD;
    }*/

    /* Set the addr for every CCD of the FEE, left and right sides */
	ulLastOffset = pxNfeeL->xMemMap.ulOffsetRoot + RESERVED_FEE_X + RESERVED_HALF_CCD_X;
	ulStepHalfCCD = RESERVED_HALF_CCD_X + pxNfeeL->xMemMap.xCommon.usiTotalBytes;
	for ( ucIL = 0; ucIL < 4; ucIL++ ) {
		/* Verify and round the start address to be 256 bits (32 bytes) aligned */
		if (ulLastOffset % 32) {
			/* Address is not aligned, set it to the next aligned address */
			ulLastOffset = ((unsigned long) (ulLastOffset / 32) + 1) * 32;
		}
		pxNfeeL->xMemMap.xCcd[ ucIL ].xLeft.ulOffsetAddr = ulLastOffset;
		ulLastOffset = ulLastOffset + ulStepHalfCCD;
		/* Verify and round the start address to be 256 bits (32 bytes) aligned */
		if (ulLastOffset % 32) {
			/* Address is not aligned, set it to the next aligned address */
			ulLastOffset = ((unsigned long) (ulLastOffset / 32) + 1) * 32;
		}
		pxNfeeL->xMemMap.xCcd[ ucIL ].xRight.ulOffsetAddr = ulLastOffset;
		ulLastOffset = ulLastOffset + ulStepHalfCCD;
	}

}

/* This function will provide updated value for:
 * - unsigned long ulStartAddrTrans;
   - unsigned long ulEndAddrTrans;


 */
bool bMemNewLimits( TNFee *pxNfeeL, unsigned short int usiVStart, unsigned short int usiVEnd ) {
	bool bSucess = FALSE;

	/* Verify the limits */
	if ( usiVEnd > (pxNfeeL->xCcdInfo.usiHeight + pxNfeeL->xCcdInfo.usiOLN) )
		return bSucess;

	/* Verify is start > end*/
	if ( usiVStart >= usiVEnd )
		return bSucess;



	/* Need implementation*/
	bSucess = TRUE;
	return bSucess;

}

/* Update the memory mapping for the FEE due to the CCD informations */
void vResetMemCCDFEE( TNFee *pxNfeeL ) {
	unsigned char ucIL = 0;

    for ( ucIL = 0; ucIL < 4; ucIL++ ) {
        pxNfeeL->xMemMap.xCcd[ ucIL ].xLeft.ulAddrI = 0;
        pxNfeeL->xMemMap.xCcd[ ucIL ].xLeft.ulBlockI = 0;
        pxNfeeL->xMemMap.xCcd[ ucIL ].xRight.ulAddrI = 0;
        pxNfeeL->xMemMap.xCcd[ ucIL ].xRight.ulBlockI = 0;
    }
}
