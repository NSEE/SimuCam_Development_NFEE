/*
 * fee_task.c
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */


#include "fee_task.h"

const char *cTemp[64];
static unsigned char ucIterationSide;


void vFeeTask(void *task_data) {
	static TNFee *pxNFee;
	INT8U error_code;
	static unsigned char ucMemUsing;
	static alt_u32 tCodFeeTask;
	alt_u32 tCodeNext;
	static unsigned long incrementador; /* remover*/
	tQMask uiCmdFEE;
	static TCcdMemMap *xCcdMapLocal;
	volatile unsigned char ucReadout;
	unsigned long usiLengthBlocks;
	bool bDmaReturn;
	bool bFinal;
	alt_u16 *pusiHK;
	unsigned char ucIL;


	pxNFee = ( TNFee * ) task_data;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
		fprintf(fp,"NFEE %hhu Task. (Task on)\n", pxNFee->ucId);
	}
	#endif

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		vPrintConsoleNFee( pxNFee );
	}
	#endif


	for(;;){

		switch ( pxNFee->xControl.eMode ) {
			case sFeeInit:

				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/*
				error_code = OSQFlush( xWaitSyncQFee[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}
				*/

				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdXSize = pxNFee->xCcdInfo.usiHalfWidth + pxNFee->xCcdInfo.usiSPrescanN + pxNFee->xCcdInfo.usiSOverscanN;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdYSize = pxNFee->xCcdInfo.usiHeight + pxNFee->xCcdInfo.usiOLN;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiDataYSize = pxNFee->xCcdInfo.usiHeight;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiOverscanYSize = pxNFee->xCcdInfo.usiOLN;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = xDefaults.usiSpwPLength;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = pxNFee->xControl.ucROutOrder[0];
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucProtocolId = xDefaults.usiDataProtId; /* 0xF0 ou  0x02*/
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xDefaults.usiDpuLogicalAddr;
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);

				bRmapGetRmapMemHKArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd1VodE = 0xFF00;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd1VodF = 0xFF01;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd1VrdMon = 0xFF02;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd2VodE = 0xFF03;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd2VodF = 0xFF04;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd2VrdMon = 0xFF05;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd3VodE = 0xFF06;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd3VodF = 0xFF07;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd3VrdMon = 0xFF08;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd4VodE  = 0xFF09;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd4VodF = 0xFF0A;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd4VrdMon = 0xFF0B;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVccd = 0xFF0C;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVrclk = 0xFF0D;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkViclk = 0xFF0E;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVrclkLow = 0xFF0F;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHk5vbPos = 0xFF10;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHk5vbNeg = 0xFF11;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHk33vbPos = 0xFF12;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHk25vaPos = 0xFF13;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHk33vdPos = 0xFF14;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHk25vdPos = 0xFF15;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHk15vdPos = 0xFF16;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHk5vref = 0xFF17;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVccdPosRaw = 0xFF18;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVclkPosRaw = 0xFF19;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVan1PosRaw = 0xFF1A;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVan3NegRaw = 0xFF1B;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVan2PosRaw = 0xFF1C;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVdigFpgaRaw = 0xFF1D;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkVdigSpwRaw = 0xFF1E;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkViclkLow = 0xFF1F;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkAdcTempAE = 0xFF20;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkAdcTempAF = 0xFF21;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd1Temp = 0xFF22;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd2Temp = 0xFF23;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd3Temp = 0xFF24;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd4Temp = 0xFF25;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkWp605Spare = 0xFF26;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA0 = 0xFF27;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA1 = 0xFF28;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA2 = 0xFF29;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA3 = 0xFF2A;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA4 = 0xFF2B;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA5 = 0xFF2C;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA6 = 0xFF2D;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA7 = 0xFF2E;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA8 = 0xFF2F;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA9 = 0xFF30;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA10 = 0xFF31;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA11 = 0xFF32;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA12 = 0xFF33;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA13 = 0xFF34;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA14 = 0xFF35;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA15 = 0xFF36;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt0 = 0xFF37;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt1 = 0xFF38;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt2 = 0xFF39;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt3 = 0xFF3A;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt4 = 0xFF3B;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt5 = 0xFF3C;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt6 = 0xFF3D;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt7 = 0xFF3E;
				pxNFee->xChannel.xRmap.xRmapMemHKArea.usiZeroHiresAmp = 0xFF3F;
				bRmapSetRmapMemHKArea(&pxNFee->xChannel.xRmap);


				vLoadCtemp();

				bRmapGetRmapMemHKArea(&pxNFee->xChannel.xRmap);
				pusiHK = &pxNFee->xChannel.xRmap.xRmapMemHKArea.usiHkCcd1VodE;

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"\n\n================= H  K ==================\n");
					for (ucIL = 0; ucIL < 64; ++ucIL) {
						fprintf(fp,"   - %s = %04x \n", cTemp[ucIL] , *pusiHK);
						pusiHK++;
					}
					fprintf(fp,"\n================= H  K ==================\n\n");
				}
				#endif

				/* Change the configuration */
				bRmapGetCodecConfig( &pxNFee->xChannel.xRmap );
				pxNFee->xChannel.xRmap.xRmapCodecConfig.ucKey = (unsigned char) xDefaults.ucRmapKey ;
				pxNFee->xChannel.xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char) xDefaults.ucLogicalAddr;
				bRmapSetCodecConfig( &pxNFee->xChannel.xRmap );

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"NFEE %hhu Task. RMAP KEY = %hu\n", pxNFee->ucId ,xDefaults.ucRmapKey );
					fprintf(fp,"NFEE %hhu Task. Log. Addr. = %hu \n", pxNFee->ucId, xDefaults.ucLogicalAddr);
				}
				#endif

				pxNFee->xControl.eMode = sToFeeConfig;
				ucIterationSide = pxNFee->xControl.eSide;

				break;
			case sToFeeConfig: /* Transition */

				ucMemUsing = (unsigned char) ( *pxNFee->xControl.pActualMem );

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x06; /*Off*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Disable the link SPW */
				bDisableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = FALSE;
				bSetPainelLeds( LEDS_OFF , uliReturnMaskG( pxNFee->ucSPWId ) );
				bSetPainelLeds( LEDS_ON , uliReturnMaskR( pxNFee->ucSPWId ) );

				/* Disable RMAP interrupts */
				bDisableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucSPWId);

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Config Mode\n", pxNFee->ucId);
				}
				#endif

				/* Complete when MUTEX were created */
				if ( pxNFee->xControl.bDMALocked == TRUE ) {
					/* If is with the Mutex, should release */
					OSMutexPost(xDma[ucMemUsing].xMutexDMA);
					pxNFee->xControl.bDMALocked = FALSE;
				}

				/*
				error_code = OSQFlush( xWaitSyncQFee[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}
				*/

				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);

				/* End of simulation! Clear everything that is possible */
				pxNFee->xControl.bWatingSync = FALSE;
				pxNFee->xControl.bSimulating = FALSE;
				pxNFee->xControl.bUsingDMA = FALSE;
				pxNFee->xControl.bEnabled = TRUE;

				vResetMemCCDFEE(pxNFee);

				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				pxNFee->xControl.bWatingSync = TRUE;
				pxNFee->xControl.eMode = sFeeConfig;
				ucIterationSide = pxNFee->xControl.eSide;
				bFinal = FALSE;
				break;


			case sFeeConfig: /* Real mode */

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinConfig( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}

				break;
			case sFeeOn: /* Not implemented yet */

				pxNFee->xControl.eMode = sToFeeStandBy;
				break;
			case sToFeeStandBy: /* Transition */

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x00; /*sFeeStandBy*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				/* Disable RMAP interrupts */
				bEnableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucId);

				/* Enable the link SPW */
				bEnableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = TRUE;
				bSetPainelLeds( LEDS_OFF , uliReturnMaskR( pxNFee->ucSPWId ) );
				bSetPainelLeds( LEDS_ON , uliReturnMaskG( pxNFee->ucSPWId ) );


				pxNFee->xControl.bSimulating = TRUE;
				pxNFee->xControl.bUsingDMA = FALSE;
				pxNFee->xControl.bEnabled = TRUE;

				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);

				/* Cleaning other syncs that maybe in the queue */
				pxNFee->xControl.bWatingSync = FALSE;
				/*
				error_code = OSQFlush( xWaitSyncQFee[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}
				*/

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Standby\n", pxNFee->ucId);
				}
				#endif

				/* Reset the memory addr variables thats is used in the transmission*/
				vResetMemCCDFEE(pxNFee);

				incrementador = 0;

				pxNFee->xControl.bWatingSync = TRUE;
				pxNFee->xControl.eMode = sFeeStandBy;
				ucIterationSide = pxNFee->xControl.eSide;
				break;


			case sFeeStandBy: /* Real mode */

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinStandBy( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}

				break;


			case sNextPatternIteration:

				/*
				error_code = OSQFlush( xWaitSyncQFee[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}
				*/

				pxNFee->xControl.bUsingDMA = TRUE;
				pxNFee->xControl.bSimulating = TRUE;

				vResetMemCCDFEE(pxNFee);

				/* Wait until both buffers are empty  */
				vWaitUntilBufferEmpty( pxNFee->ucSPWId );

				/*if (xDefaults.usiLinkNFEE0 == 0) {
					while ( (bFeebGetCh1LeftFeeBusy()== TRUE) || (bFeebGetCh1RightFeeBusy()== TRUE)  ) {}
				} else {
					while ( (bFeebGetCh2LeftFeeBusy()== TRUE) || (bFeebGetCh2RightFeeBusy()== TRUE)  ) {}
				}
				*/


				OSTimeDlyHMSM(0,0,0,xDefaults.usiGuardNFEEDelay);

				vSetDoubleBufferLeftSize( SDMA_MAX_BLOCKS, pxNFee->ucSPWId );
				vSetDoubleBufferRightSize( SDMA_MAX_BLOCKS, pxNFee->ucSPWId );

				/*if (xDefaults.usiLinkNFEE0 == 0) {
					bFeebCh1SetBufferSize((unsigned char)SDMA_MAX_BLOCKS,0);
					bFeebCh1SetBufferSize((unsigned char)SDMA_MAX_BLOCKS,1);
				} else {
					bFeebCh2SetBufferSize((unsigned char)SDMA_MAX_BLOCKS,0);
					bFeebCh2SetBufferSize((unsigned char)SDMA_MAX_BLOCKS,1);
				}*/

				/* Enable IRQ and clear the Double Buffer */
				bEnableDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				bSpwcGetTimecode(&pxNFee->xChannel.xSpacewire);
				tCodFeeTask = pxNFee->xChannel.xSpacewire.xTimecode.ucCounter;
				tCodeNext = ( tCodFeeTask + 1) % 4;
				if ( tCodeNext == 0 ) {
					/* Should get Data from the another memory, because is a cicle start */
					ucMemUsing = (unsigned char) (( *pxNFee->xControl.pActualMem + 1 ) % 2) ; /* Select the other memory*/
				} else {
					ucMemUsing = (unsigned char) ( *pxNFee->xControl.pActualMem ) ;
				}

				ucReadout = pxNFee->xControl.ucROutOrder[tCodeNext];

				if ( pxNFee->xControl.eSide == sLeft )
					xCcdMapLocal = &pxNFee->xMemMap.xCcd[ucReadout].xLeft;
				else
					xCcdMapLocal = &pxNFee->xMemMap.xCcd[ucReadout].xRight;

				ucIterationSide = pxNFee->xControl.eSide;


				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = ucReadout;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImagePattern;
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);


				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"\n\n=========DATA PACKET=============\n");
					fprintf(fp,"usiCcdXSize %hu\n", pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdXSize);
					fprintf(fp,"usiCcdYSize %hu\n", pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdYSize);
					fprintf(fp,"usiDataYSize %hu\n", pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiDataYSize);
					fprintf(fp,"usiOverscanYSize %hu\n", pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiOverscanYSize);
					fprintf(fp,"usiPacketLength %hu\n", pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength);
					fprintf(fp,"ucCcdNumber %hu\n", pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber);
					fprintf(fp,"ucFeeMode %hu\n", pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode);
					fprintf(fp,"=========DATA PACKET=============\n");
				}
				#endif

				/* Make one requests for the Double buffer */
				bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId);
				bDmaReturn = FALSE;
				/* When get the mutex, perform two DMA writes in order to fill the "double" part of the double buffer */
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* First Check if is access to the DMA (priority) */
					if ( uiCmdFEE.ucByte[2] == M_FEE_DMA_ACCESS ) {

						/* Try to get the Mutex */
	                    OSMutexPend(xDma[ucMemUsing].xMutexDMA, 0, &error_code); /* Blocking way */
	                    if ( error_code == OS_ERR_NONE ) {
	                    	pxNFee->xControl.bDMALocked = TRUE;

							bDmaReturn = bPrepareDoubleBuffer( xCcdMapLocal, ucMemUsing, pxNFee->ucId, pxNFee, ucIterationSide );
							OSMutexPost(xDma[ucMemUsing].xMutexDMA);
							pxNFee->xControl.bDMALocked = FALSE;
		
						}
						/* Send message telling to controller that is not using the DMA any more */
						bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);							

						if ( bDmaReturn == TRUE ) {
							if (pxNFee->xControl.bWatingSync==TRUE) {
								pxNFee->xControl.eNextMode = sToTestFullPattern;
								pxNFee->xControl.eMode = sFeeWaitingSync;
							} else {
								pxNFee->xControl.eNextMode = sToTestFullPattern;
								pxNFee->xControl.eMode = sToTestFullPattern;
							}
							incrementador++;
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
								fprintf(fp,"\nNFEE-%hu Task: Double buffer prepared\n", pxNFee->ucId);
							}
							#endif
						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
								fprintf(fp,"\nNFEE-%hu Task: Could not prepare the double buffer\n", pxNFee->ucId);
							}
							#endif
						}
					} else {
						vQCmdFEEinFullPattern( pxNFee, uiCmdFEE.ulWord );
					}
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}	
				break;


			case sToTestFullPattern: /* Transition */
				bFinal = FALSE;

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x02; /*Pattern Full Image*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Full Image Pattern Mode\n", pxNFee->ucId);
				}
				#endif

				ucIterationSide = pxNFee->xControl.eSide;

				pxNFee->xControl.bUsingDMA = TRUE;
				pxNFee->xControl.eMode = sFeeTestFullPattern;
				pxNFee->xControl.eNextMode = sFeeTestFullPattern;
				pxNFee->xControl.bWatingSync = TRUE;
				pxNFee->xControl.bSimulating = TRUE;
				pxNFee->xControl.bEnabled = TRUE;
				//bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId); /*todo:REMOVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

				vSetDoubleBufferLeftSize( SDMA_MAX_BLOCKS, pxNFee->ucSPWId );
				vSetDoubleBufferRightSize( SDMA_MAX_BLOCKS, pxNFee->ucSPWId );

				/*if (xDefaults.usiLinkNFEE0 == 0) {
					bFeebCh1SetBufferSize((unsigned char)SDMA_MAX_BLOCKS,0);
					bFeebCh1SetBufferSize((unsigned char)SDMA_MAX_BLOCKS,1);
				} else {
					bFeebCh2SetBufferSize((unsigned char)SDMA_MAX_BLOCKS,0);
					bFeebCh2SetBufferSize((unsigned char)SDMA_MAX_BLOCKS,1);
				}*/
				ucMemUsing = (unsigned char) ( *pxNFee->xControl.pActualMem ) ;
				break;

			case sFeeTestFullPattern: /* Real mode */
				bFinal = FALSE;

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* First Check if is access to the DMA (priority) */
					if ( uiCmdFEE.ucByte[2] == M_FEE_DMA_ACCESS ) {

						/* Try to get the Mutex */
						OSMutexPend(xDma[ucMemUsing].xMutexDMA, 0, &error_code); /* Blocking way */
						if ( error_code == OS_ERR_NONE ) {
							pxNFee->xControl.bDMALocked = TRUE;

							/* Is this the last block? */
							if ( (xCcdMapLocal->ulBlockI + SDMA_MAX_BLOCKS) >= pxNFee->xMemMap.xCommon.usiNTotalBlocks ) {

								/*Define the size of the data in the double buffer (need this to create the interrupt right)*/
								usiLengthBlocks = pxNFee->xMemMap.xCommon.usiNTotalBlocks - xCcdMapLocal->ulBlockI;

								vSetDoubleBufferLeftSize( (unsigned char)usiLengthBlocks, pxNFee->ucSPWId );
								vSetDoubleBufferRightSize( (unsigned char)usiLengthBlocks, pxNFee->ucSPWId );

								/*
								if (xDefaults.usiLinkNFEE0 == 0) {
									bFeebCh1SetBufferSize((unsigned char)usiLengthBlocks,0);
									bFeebCh1SetBufferSize((unsigned char)usiLengthBlocks,1);
								} else {
									bFeebCh2SetBufferSize((unsigned char)usiLengthBlocks,0);
									bFeebCh2SetBufferSize((unsigned char)usiLengthBlocks,1);
								}*/

								bFinal = TRUE;

							} else {
								usiLengthBlocks = SDMA_MAX_BLOCKS;
							}


							if ( ucMemUsing == 0  ) {
								bDmaReturn = bSdmaDmaM1Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)usiLengthBlocks, ucIterationSide, pxNFee->ucSPWId);
							} else {
								bDmaReturn = bSdmaDmaM2Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)usiLengthBlocks, ucIterationSide, pxNFee->ucSPWId);
							}

							OSMutexPost(xDma[ucMemUsing].xMutexDMA);
							pxNFee->xControl.bDMALocked = FALSE;

							if ( bDmaReturn == TRUE ) {
								/* Value of xCcdMapLocal->ulAddrI already set in the last iteration */
								xCcdMapLocal->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*usiLengthBlocks;
								xCcdMapLocal->ulBlockI += usiLengthBlocks;
							} else {
								bFinal = FALSE;

								/* Send the request for use the DMA, but to front of the QUEUE */
								bSendRequestNFeeCtrl_Front( M_NFC_DMA_REQUEST, 0, pxNFee->ucId);
							}


							/* Send message telling to controller that is not using the DMA any more */
							bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);

							if ( bFinal == TRUE ) {
								pxNFee->xControl.eMode = sEndTransmission;
							} else {
								//bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId); /*todo:REMOVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
							}

						}
					} else {
						vQCmdFEEinFullPattern( pxNFee, uiCmdFEE.ulWord );

						if ( pxNFee->xControl.bWatingSync == FALSE ) {
							pxNFee->xControl.eMode = pxNFee->xControl.eNextMode;
						}
					}

				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}

				break;

			case sEndTransmission:

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\nEnd of transmission NFEE-%hhu -> CCD %hhu\n", pxNFee->ucId, ucReadout);
					fprintf(fp,"Memory used: %u\n", ucMemUsing);
				}
				#endif

				pxNFee->xControl.bWatingSync = TRUE;
				pxNFee->xControl.bUsingDMA = FALSE;

				if ( xDefaults.bOneShot == FALSE ) {

					if ( pxNFee->xControl.eNextMode == sToFeeStandBy ) {

						bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy;
						bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);

						pxNFee->xControl.eMode =  sFeeWaitingSync;
						pxNFee->xControl.eNextMode =  sToFeeStandBy;
					} else {
						pxNFee->xControl.eMode =  sNextPatternIteration;
						pxNFee->xControl.eNextMode =  sFeeWaitingSync;
					}

				} else {
					pxNFee->xControl.eMode =  sFeeWaitingSync;
					pxNFee->xControl.eNextMode =  sToFeeStandBy;
				}

				break;

			case sFeeWaitingSync:

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: (sFeeWaitingSync)\n", pxNFee->ucId);
				}
				#endif

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code != OS_ERR_NONE ) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ (sFeeWaitingSync)\n", pxNFee->ucId);
					}
					#endif
				} else {
					vQCmdFEEinWaitingSync( pxNFee, uiCmdFEE.ulWord  );
				}

				break;


			default:
				pxNFee->xControl.eMode = sToFeeConfig;
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"\nNFEE %hhu Task: Unexpected mode (default)\n", pxNFee->ucId);
				}
				#endif
				break;
		}

	}

}

void vQCmdFEEinWaitingSync( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeConfig;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;
			case M_FEE_STANDBY_FORCED:
			case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* If a transition to Standby was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				if ( sToTestFullPattern == pxNFeeP->xControl.eNextMode ) {

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				}

				pxNFeeP->xControl.eMode = sFeeWaitingSync; /*sSIMTestFullPattern*/
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				break;
			case M_FEE_FULL_PATTERN:
			case M_FEE_FULL_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sNextPatternIteration; /*sSIMTestFullPattern*/
				pxNFeeP->xControl.eNextMode = sFeeWaitingSync;
				break;
			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"\nNFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPWaitingSync( pxNFeeP, cmd );
				break;
			case M_SYNC:
			case M_MASTER_SYNC:
				/* Warning */
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					pxNFeeP->xControl.bWatingSync = FALSE;

				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in Config mode)\n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}


void vQCmdFEEinConfig( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG_FORCED:
			case M_FEE_CONFIG:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task:  Already in Config mode\n", pxNFeeP->ucId);
				}
				#endif
				break;
			/*case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				break;*/
			case M_FEE_STANDBY: /* Config -> StandBy is always forced mode (don't need sync) */
			case M_FEE_STANDBY_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeStandBy;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				break;				
			case M_FEE_FULL_PATTERN_FORCED:
			case M_FEE_FULL_PATTERN:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: Can't go to Full Image Pattern from Config mode\n", pxNFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: Can't threat RMAP Messages in this mode (Config)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_SYNC:
			case M_MASTER_SYNC:
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (Config)\n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}

void vQCmdFEEinStandBy( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			/*case M_FEE_CONFIG:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;*/
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeConfig;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;				
			case M_FEE_STANDBY_FORCED:
			case M_FEE_STANDBY:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task:  Already in Stand by\n", pxNFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_FULL_PATTERN:
			case M_FEE_FULL_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sNextPatternIteration; /*sSIMTestFullPattern*/
				pxNFeeP->xControl.eNextMode = sFeeWaitingSync;
				break;

			case M_FEE_RMAP:
				vQCmdFeeRMAPinStandBy( pxNFeeP, cmd );

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */

				break;


			case M_SYNC:
			case M_MASTER_SYNC:
				/* Warning */
				if ( pxNFeeP->xControl.eMode == sFeeWaitingSync ) {
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					pxNFeeP->xControl.bWatingSync = FALSE;
				}
				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in Config mode)\n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}



void vQCmdFEEinFullPattern( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			/*case M_FEE_CONFIG:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;*/
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeConfig;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;				
			case M_FEE_RUN:
				/*pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sFeeOn;*/
				break;
			case M_FEE_STANDBY:
				/*pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;*/ /* To finish the actual transfer only when sync comes */
				if ( pxNFeeP->xControl.eMode == sNextPatternIteration ) {
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eMode = sFeeWaitingSync;
					pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				} else {
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eMode = sFeeTestFullPattern;
					pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				}

				break;
			case M_FEE_STANDBY_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeStandBy;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy; /* To finish the actual transfer only when sync comes */
				break;				
			case M_FEE_FULL_PATTERN:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task:  Already in Full Image Pattern mode\n", pxNFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif

				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPinFullPattern( pxNFeeP, cmd );

				break;

			case M_SYNC:
			case M_MASTER_SYNC:
				/* Warning */
				if ( pxNFeeP->xControl.eMode == sFeeWaitingSync ) {
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					pxNFeeP->xControl.bWatingSync = FALSE;
				}

				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in Confg mode)\n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}



void vQCmdFeeRMAPinStandBy( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U ucADDRReg= 0u;
	INT32U ucValueReg = 0u;
	INT32U ucValueMasked = 0u;
	INT32U ucValueMasked2 = 0u;


#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received (StandBy)\n", pxNFeeP->ucId);
	}
#endif


	uiCmdFEEL.ulWord = cmd;

	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);

	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			ucValueMasked = (COMM_RMAP_IMGCLK_TRCNT_CTRL_MSK & ucValueReg) >> 4; /* Number of rows */
			ucValueMasked2 = (COMM_RMAP_REGCLK_TRCNT_CTRL_MSK & ucValueReg) >> 20; /* Number of columns */


			pxNFeeP->xCcdInfo.usiHeight = ucValueMasked - pxNFeeP->xCcdInfo.usiOLN;
			pxNFeeP->xCcdInfo.usiHalfWidth = ucValueMasked2 - (pxNFeeP->xCcdInfo.usiSOverscanN + pxNFeeP->xCcdInfo.usiSPrescanN);
			vUpdateMemMapFEE(pxNFeeP);

			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiOverscanYSize = pxNFeeP->xCcdInfo.usiOLN;
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdXSize = ucValueMasked2 ;
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdYSize = ucValueMasked;
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiDataYSize = ucValueMasked - pxNFeeP->xCcdInfo.usiOLN;
		
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

			break;
		case 0x041://0x00000004:ccd_seq_2_config
			break;
		case 0x042://0x00000008:spw_packet_1_config

			ucValueMasked = (ucValueReg & (INT32U)COMM_RMAP_PACKET_SIZE_CTRL_MSK) >> 4;
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = ucValueMasked;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"REG :%lu\n", ucValueReg);
				fprintf(fp,"Pkt L:%lu\n", ucValueMasked);
			}
			#endif

			ucValueMasked2 = (ucValueReg & COMM_RMAP_CCD_DTRAN_SEL_CTRL_MSK) >> 2;

			switch (ucValueMasked2) {
				case 0b01:
					pxNFeeP->xControl.eSide = sLeft;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
						fprintf(fp," - Left side\n");
					}
					#endif
					break;
				case 0b10:
					pxNFeeP->xControl.eSide = sRight;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
						fprintf(fp," - Right side\n");
					}
					#endif
					break;
				case 0b11:
					pxNFeeP->xControl.eSide = sLeft;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
						fprintf(fp," - Both sides, but not supported yet. Switching to Left side\n");
					}
					#endif
				default:
					pxNFeeP->xControl.eSide = sLeft;

					bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
					pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSpwPacket1Config = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSpwPacket1Config & 0xFFFFFFF7);
					bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
						fprintf(fp," - Switching to Left side\n");
					}
					#endif
					break;
				}
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"\nNFEE %hhu Task: Side changed (FullPattern) side: %hhu\n", pxNFeeP->ucId, pxNFeeP->xControl.eSide);
			}
			#endif
			break;
		case 0x043://0x0000000C:spw_packet_2_config
		case 0x44://0x00000010:CCD_1_windowing_1_config
		case 0x45://0x00000014:CCD_1_windowing_2_config
		case 0x46://0x00000018:CCD_2_windowing_1_config
		case 0x47://0x0000001C:CCD_2_windowing_2_config
		case 0x48://0x00000020:CCD_3_windowing_1_config
		case 0x49://0x00000024:CCD_3_windowing_2_config
		case 0x4A://0x00000028:CCD_4_windowing_1_config
		case 0x4B://0x0000002C:CCD_4_windowing_2_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"Command not allowed yet ( %hhu )\n", ucADDRReg);
			}
			#endif
				break;
		case 0x0000004C://0x00000038:operation_mode_config
			/* Mode Selection */
			ucValueMasked = (COMM_RMAP_MODE_SEL_CTRL_MSK & ucValueReg) >> 4;

			switch (ucValueMasked) {
				case 0: /* Standby */

				#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp,"- already in Stand by mode\n");
					}
				#endif

					break;
				case 2: /* PAttern Full image */
				#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp,"- to Full-Image-Pattern\n");
					}
				#endif

					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eMode = sNextPatternIteration; /*sSIMTestFullPattern*/
					pxNFeeP->xControl.eNextMode = sFeeWaitingSync;

					break;
				case 6:
				#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp,"- Off-Mode not allowed.\n");
					}
				#endif
					break;
				case 1:
				case 3:
				case 4:
				case 5:
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"- mode not allowed yet ( %lu )\n", ucValueMasked);
					}
					#endif
					break;
			}

			break;
		case 0x0000004D://0x0000003C:sync_config

			ucValueMasked = (COMM_RMAP_SELF_TRIGGER_CTRL_MSK & ucValueReg) >> 2; /* Number of rows */

			/* Cannot perform this operation */
			if ( ucValueMasked ) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp," - operation not allowed (StandBy-Mode)\n");
				}
				#endif
				/* Clear the trigger */
				bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
				pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig & 0xFFFFFFFB);
				bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);
			}

			break;
		case 0x0000004E://0x00000040:dac_control
		case 0x0000004F://0x00000044:clock_source_control
		case 0x00000050://0x00000048:frame_number
		case 0x00000051://0x0000004C:current_mode
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp," Command not allowed yet ( %hhu )\n", ucADDRReg);
			}
			#endif
			break;
		}
}

void vQCmdFeeRMAPinFullPattern( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received (FullPattern)\n", pxNFeeP->ucId);
	}
	#endif

	uiCmdFEEL.ulWord = cmd;

	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);


	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
		case 0x041://0x00000004:ccd_seq_2_config
		case 0x042://0x00000008:spw_packet_1_config
			if ( (pxNFeeP->xControl.eNextMode == sToTestFullPattern) || (pxNFeeP->xControl.eNextMode == sFeeWaitingSync) )
			{

				ucValueMasked2 = (ucValueReg & COMM_RMAP_CCD_DTRAN_SEL_CTRL_MSK) >> 2;

				switch (ucValueMasked2) {
					case 0b01:
						pxNFeeP->xControl.eSide = sLeft;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
							fprintf(fp," - Left side\n");
						}
						#endif
						break;
					case 0b10:
						pxNFeeP->xControl.eSide = sRight;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
							fprintf(fp," - Right side\n");
						}
						#endif
						break;
					case 0b11:
						pxNFeeP->xControl.eSide = sLeft;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
							fprintf(fp," - Both sides, but not supported yet. Switching to Left side\n");
						}
						#endif
					default:
						pxNFeeP->xControl.eSide = sLeft;

						bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
						pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSpwPacket1Config = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSpwPacket1Config & 0xFFFFFFF7);
						bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
							fprintf(fp," - Switching to Left side\n");
						}
						#endif
					break;
				}
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\nNFEE %hhu Task: Side changed (FullPattern) side: %hhu\n", pxNFeeP->ucId, pxNFeeP->xControl.eSide);
				}
				#endif


				pxNFeeP->xControl.eMode =  sNextPatternIteration;
				pxNFeeP->xControl.eNextMode =  sFeeWaitingSync;
			} else {
				if (pxNFeeP->xControl.eNextMode == sFeeTestFullPattern) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp,"\nNFEE %hhu Task: Can't change the CCD side while in transmission (FullPattern) side: %hhu\n", pxNFeeP->ucId, pxNFeeP->xControl.eSide);
					}
					#endif
				}
			}



			break;
		case 0x043://0x0000000C:spw_packet_2_config
		case 0x44://0x00000010:CCD_1_windowing_1_config
		case 0x45://0x00000014:CCD_1_windowing_2_config
		case 0x46://0x00000018:CCD_2_windowing_1_config
		case 0x47://0x0000001C:CCD_2_windowing_2_config
		case 0x48://0x00000020:CCD_3_windowing_1_config
		case 0x49://0x00000024:CCD_3_windowing_2_config
		case 0x4A://0x00000028:CCD_4_windowing_1_config
		case 0x4B://0x0000002C:CCD_4_windowing_2_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp," Command not allowed yet ( %hhu )\n", ucADDRReg);
			}
			#endif
				break;

		case 0x0000004C://0x00000038:operation_mode_config
			/* Mode Selection */
			ucValueMasked = (COMM_RMAP_MODE_SEL_CTRL_MSK & ucValueReg) >>4;

			switch (ucValueMasked) {
				case 0: /* Standby */
				#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
						fprintf(fp,"- to Stand-By\n");
					}
				#endif

					if ( pxNFeeP->xControl.eMode == sNextPatternIteration ) {
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eMode = sFeeWaitingSync;
						pxNFeeP->xControl.eNextMode = sToFeeStandBy;
					} else {
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eMode = sFeeTestFullPattern;
						pxNFeeP->xControl.eNextMode = sToFeeStandBy;
					}

					//pxNFeeP->xControl.bWatingSync = TRUE;
					//pxNFeeP->xControl.eMode = sFeeTestFullPattern;
					//pxNFeeP->xControl.eNextMode = sToFeeStandBy; /* To finish the actual transfer only when sync comes */

					break;
				case 2: /* PAttern Full image */
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp,"NFEE %hhu Task:  Already in Full Image Pattern mode\n", pxNFeeP->ucId);
					}
					#endif

					break;
				case 6:
				#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp," Off-Mode not allowed.\n");
					}
				#endif
					break;
				case 1:
				case 3:
				case 4:
				case 5:
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp," mode not allowed yet ( %lu )\n", ucValueMasked);
					}
					#endif
					break;
			}

			break;
		case 0x0000004D://0x0000003C:sync_config

			ucValueMasked = (COMM_RMAP_SELF_TRIGGER_CTRL_MSK & ucValueReg) >> 2; /* Number of rows */

			if ( ucValueMasked ) {

				if ( pxNFeeP->xControl.eNextMode == sToFeeStandBy ) {
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp," - Mode Forced.\n");
					}
					#endif
				}

				/* Clear the trigger */
//				bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
//				pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig & 0xFFFFFFFB);
//				bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);

			}

			break;
		case 0x0000004E://0x00000040:dac_control
		case 0x0000004F://0x00000044:clock_source_control
		case 0x00000050://0x00000048:frame_number
		case 0x00000051://0x0000004C:current_mode
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"Command not allowed yet ( %hhu )\n", ucADDRReg);
			}
			#endif
			break;
		}
}


void vQCmdFeeRMAPWaitingSync( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received (WaitingSync)\n", pxNFeeP->ucId);
	}
	#endif

	uiCmdFEEL.ulWord = cmd;

	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);


	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
		case 0x041://0x00000004:ccd_seq_2_config
		case 0x042://0x00000008:spw_packet_1_config

			if ( (pxNFeeP->xControl.eNextMode == sToTestFullPattern) || (pxNFeeP->xControl.eNextMode == sFeeWaitingSync) )
			{

				ucValueMasked2 = (ucValueReg & COMM_RMAP_CCD_DTRAN_SEL_CTRL_MSK) >> 2;

				switch (ucValueMasked2) {
					case 0b01:
						pxNFeeP->xControl.eSide = sLeft;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
							fprintf(fp," - Left side\n");
						}
						#endif
						break;
					case 0b10:
						pxNFeeP->xControl.eSide = sRight;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
							fprintf(fp," - Right side\n");
						}
						#endif
						break;
					case 0b11:
						pxNFeeP->xControl.eSide = sLeft;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
							fprintf(fp," - Both sides, but not supported yet. Switching to Left side\n");
						}
						#endif
					default:
						pxNFeeP->xControl.eSide = sLeft;

						bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
						pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSpwPacket1Config = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSpwPacket1Config & 0xFFFFFFF7);
						bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
							fprintf(fp," - Switching to Left side\n");
						}
						#endif
					break;
				}
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\nNFEE %hhu Task: Side changed (FullPattern) side: %hhu\n", pxNFeeP->ucId, pxNFeeP->xControl.eSide);
				}
				#endif


				pxNFeeP->xControl.eMode =  sNextPatternIteration;
				pxNFeeP->xControl.eNextMode =  sFeeWaitingSync;
			} else {
				if (pxNFeeP->xControl.eNextMode == sFeeTestFullPattern) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"\nNFEE %hhu Task: Can't change the CCD side while in transmission (FullPattern) side: %hhu\n", pxNFeeP->ucId, pxNFeeP->xControl.eSide);
					}
					#endif
				}
			}
			break;

		case 0x043://0x0000000C:spw_packet_2_config
		case 0x44://0x00000010:CCD_1_windowing_1_config
		case 0x45://0x00000014:CCD_1_windowing_2_config
		case 0x46://0x00000018:CCD_2_windowing_1_config
		case 0x47://0x0000001C:CCD_2_windowing_2_config
		case 0x48://0x00000020:CCD_3_windowing_1_config
		case 0x49://0x00000024:CCD_3_windowing_2_config
		case 0x4A://0x00000028:CCD_4_windowing_1_config
		case 0x4B://0x0000002C:CCD_4_windowing_2_config
		case 0x0000004C://0x00000038:operation_mode_config

		ucValueMasked = (COMM_RMAP_MODE_SEL_CTRL_MSK & ucValueReg) >>4;

		switch (ucValueMasked) {
			case 0: /* Standby */
			#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"- to Stand-By\n");
				}
			#endif

				if ( sToTestFullPattern == pxNFeeP->xControl.eNextMode ) {

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				}

				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;


				break;
			case 2: /* PAttern Full image */

				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync; /*sSIMTestFullPattern*/
				pxNFeeP->xControl.eNextMode = sNextPatternIteration;

				break;
			case 6:
			#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp," Off-Mode not allowed.\n");
				}
			#endif
				break;
			case 1:
			case 3:
			case 4:
			case 5:
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp," mode not allowed yet ( %lu )\n", ucValueMasked);
				}
				#endif
				break;
		}

			break;
		case 2: /* PAttern Full image */
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"NFEE %hhu Task:  Already in Full Image Pattern mode\n", pxNFeeP->ucId);
			}
			#endif

			pxNFeeP->xControl.bWatingSync = TRUE;
			pxNFeeP->xControl.eMode = sNextPatternIteration; /*sSIMTestFullPattern*/
			pxNFeeP->xControl.eNextMode = sFeeWaitingSync;

			break;
		case 0x0000004D://0x0000003C:sync_config

			ucValueMasked = (COMM_RMAP_SELF_TRIGGER_CTRL_MSK & ucValueReg) >> 2; /* Number of rows */

			if ( ucValueMasked ) {

				if ( pxNFeeP->xControl.eNextMode == sToFeeStandBy ) {
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp," - Mode Forced.\n");
					}
					#endif
				}

				/* Clear the trigger */
//				bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
//				pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig & 0xFFFFFFFB);
//				bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);
			}

			break;
		case 0x0000004E://0x00000040:dac_control
		case 0x0000004F://0x00000044:clock_source_control
		case 0x00000050://0x00000048:frame_number
		case 0x00000051://0x0000004C:current_mode
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp," Command not allowed yet ( %hhu )\n", ucADDRReg);
			}
			#endif
			break;
		}
}


bool bDisableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId ) {
	/* Disable RMAP channel */
	bRmapGetIrqControl(pxRmapCh);
	pxRmapCh->xRmapIrqControl.bWriteCmdEn = FALSE;
	bRmapSetIrqControl(pxRmapCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId ) {
	/* Enable RMAP */
	/* Before Enable the IRQ for Rmap, make a copy for compare when some command arrive */
	//bRmapGetMemConfigArea(&xRmap[ucId]);

	bRmapGetIrqControl(pxRmapCh);
	pxRmapCh->xRmapIrqControl.bWriteCmdEn = TRUE;
	bRmapSetIrqControl(pxRmapCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bDisableSPWChannel( TSpwcChannel *xSPW ) {
	/* Disable SPW channel */
	bSpwcGetLink(xSPW);
	xSPW->xLinkConfig.bLinkStart = FALSE;
	xSPW->xLinkConfig.bAutostart = FALSE;
	xSPW->xLinkConfig.bDisconnect = TRUE;
	bSpwcSetLink(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableSPWChannel( TSpwcChannel *xSPW ) {
	/* Enable SPW channel */
	bSpwcGetLink(xSPW);
	xSPW->xLinkConfig.bLinkStart = FALSE;
	xSPW->xLinkConfig.bAutostart = TRUE;
	xSPW->xLinkConfig.bDisconnect = FALSE;
	bSpwcSetLink(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableDbBuffer( TFeebChannel *pxFeebCh ) {
	/* Stop the module Double Buffer */
	bFeebStopCh(pxFeebCh);
	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);
	/* Start the module Double Buffer */
	bFeebStartCh(pxFeebCh);

	/*Enable IRQ of FEE Buffer*/
	bFeebGetWindowing(pxFeebCh);
	//pxFeebCh->xWindowingConfig.bMasking = DATA_PACKET;/* True= data packet;    FALSE= Transparent mode */
	pxFeebCh->xWindowingConfig.bMasking = xDefaults.bDataPacket;
	bFeebSetWindowing(pxFeebCh);

	/*Enable IRQ of FEE Buffer*/
	bFeebGetIrqControl(pxFeebCh);
	pxFeebCh->xIrqControl.bLeftBufferEmptyEn = TRUE;
	pxFeebCh->xIrqControl.bRightBufferEmptyEn = TRUE;
	bFeebSetIrqControl(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}


bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh ) {

	/*Disable IRQ of FEE Buffer*/
	bFeebGetIrqControl(pxFeebCh);
	pxFeebCh->xIrqControl.bLeftBufferEmptyEn = FALSE;
	pxFeebCh->xIrqControl.bRightBufferEmptyEn = FALSE;
	bFeebSetIrqControl(pxFeebCh);

	/* Stop the module Double Buffer */
	bFeebStopCh(pxFeebCh);

	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);
	bFeebStartCh(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bSendRequestNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPost(xNfeeSchedule, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailRequestDMA( ucValue );
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}

	return bSuccesL;
}

bool bSendRequestNFeeCtrl_Front( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPostFront(xNfeeSchedule, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailRequestDMA( ucValue );
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}

	return bSuccesL;
}

bool bSendGiveBackNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPost(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailRequestDMA( ucValue );
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}

	return bSuccesL;
}




#if DEBUG_ON
	void vPrintConsoleNFee( TNFee *pxNFeeI ) {
		TNFee *pxNFee;

		pxNFee = pxNFeeI;

		fprintf(fp,"=================================NFEE %hhu=====================================\n", pxNFee->ucId);
		fprintf(fp,"\n");
		fprintf(fp,"NFEE %hhu CCD infos: \n", pxNFee->ucId);
		fprintf(fp,"    PreScan = %hu \n", pxNFee->xCcdInfo.usiSPrescanN);
		fprintf(fp,"    OverScan = %hu \n", pxNFee->xCcdInfo.usiSOverscanN);
		fprintf(fp,"    OLN = %hu \n", pxNFee->xCcdInfo.usiOLN);
		fprintf(fp,"    Half Width = %hu \n", pxNFee->xCcdInfo.usiHalfWidth);
		fprintf(fp,"    Height = %hu \n", pxNFee->xCcdInfo.usiHeight);
		fprintf(fp,"\n");
		fprintf(fp,"NFEE %hhu Control: \n", pxNFee->ucId);
		fprintf(fp,"    NFEE State 	= %hu \n", pxNFee->xControl.eMode);
		fprintf(fp,"    NFEE Enable? = %hu \n", pxNFee->xControl.bEnabled);
		fprintf(fp,"    Using DMA?   = %hu \n", pxNFee->xControl.bUsingDMA);
		fprintf(fp,"    Logging?     = %hu \n", pxNFee->xControl.bLogging);
		fprintf(fp,"    Echoing?     = %hu \n", pxNFee->xControl.bEchoing);
		fprintf(fp,"    Channel Enable? = %hu \n", pxNFee->xControl.bChannelEnable);
		fprintf(fp,"    Readout order = [ %hhu , %hhu , %hhu , %hhu ] \n", pxNFee->xControl.ucROutOrder[0], pxNFee->xControl.ucROutOrder[1], pxNFee->xControl.ucROutOrder[2], pxNFee->xControl.ucROutOrder[3]);
		fprintf(fp,"    CCD Side = = %hu \n", pxNFee->xControl.eSide);
		fprintf(fp,"\n\n");
		fprintf(fp,"NFEE %hhu MEMORY MAP: \n", pxNFee->ucId);
		fprintf(fp,"    General Info: \n");
		fprintf(fp,"        Offset root 	= %lu \n", pxNFee->xMemMap.ulOffsetRoot);
		fprintf(fp,"        Total Bytes 	= %lu \n", pxNFee->xMemMap.ulTotalBytes);
		fprintf(fp,"        LUT ADDR 	= %lu \n", pxNFee->xMemMap.ulLUTAddr);
		fprintf(fp,"    Common to all CCDs: \n");
		fprintf(fp,"        Total Bytes 	= %lu \n", pxNFee->xMemMap.xCommon.usiTotalBytes);
		fprintf(fp,"        Total of Blocks = %lu \n", pxNFee->xMemMap.xCommon.usiNTotalBlocks);
		fprintf(fp,"        Padding Bytes 	= %hhu\n", pxNFee->xMemMap.xCommon.ucPaddingBytes);
		fprintf(fp,"        Padding MASK 	= %llu\n", pxNFee->xMemMap.xCommon.ucPaddingMask.ullWord);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 0 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 1 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 2 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 3 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"==============================================================================\n");
		fprintf(fp,"==============================================================================\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
	}
#endif


bool bPrepareDoubleBuffer( TCcdMemMap *xCcdMapLocal, unsigned char ucMem, unsigned char ucID, TNFee *pxNFee, unsigned char ucSide ) {
	bool  bDmaReturn;
	unsigned long ulLengthBlocks;

	bDmaReturn = FALSE;
	xCcdMapLocal->ulBlockI = 0;
	xCcdMapLocal->ulAddrI = xCcdMapLocal->ulOffsetAddr;


	if ( (xCcdMapLocal->ulBlockI + SDMA_MAX_BLOCKS) >= pxNFee->xMemMap.xCommon.usiNTotalBlocks ) {
		ulLengthBlocks = pxNFee->xMemMap.xCommon.usiNTotalBlocks - xCcdMapLocal->ulBlockI;
	} else {
		ulLengthBlocks = SDMA_MAX_BLOCKS;
	}

	vSetDoubleBufferLeftSize( (unsigned char)ulLengthBlocks, pxNFee->ucSPWId);
	vSetDoubleBufferRightSize( (unsigned char)ulLengthBlocks, pxNFee->ucSPWId );

	/*if (xDefaults.usiLinkNFEE0 == 0) {
		bFeebCh1SetBufferSize((unsigned char)ulLengthBlocks,0);
		bFeebCh1SetBufferSize((unsigned char)ulLengthBlocks,1);
	} else {
		bFeebCh2SetBufferSize((unsigned char)ulLengthBlocks,0);
		bFeebCh2SetBufferSize((unsigned char)ulLengthBlocks,1);
	}*/

	if (  ucMem == 0  ) {
		bDmaReturn = bSdmaDmaM1Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks;
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	} else {
		bDmaReturn = bSdmaDmaM2Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks;
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	}


	if ( (xCcdMapLocal->ulBlockI + SDMA_MAX_BLOCKS) >= pxNFee->xMemMap.xCommon.usiNTotalBlocks ) {
		ulLengthBlocks = pxNFee->xMemMap.xCommon.usiNTotalBlocks - xCcdMapLocal->ulBlockI;
	} else {
		ulLengthBlocks = SDMA_MAX_BLOCKS;
	}

	vSetDoubleBufferLeftSize( (unsigned char)ulLengthBlocks, pxNFee->ucSPWId );
	vSetDoubleBufferRightSize( (unsigned char)ulLengthBlocks, pxNFee->ucSPWId );

	/*if (xDefaults.usiLinkNFEE0 == 0) {
		bFeebCh1SetBufferSize((unsigned char)ulLengthBlocks,0);
		bFeebCh1SetBufferSize((unsigned char)ulLengthBlocks,1);
	} else {
		bFeebCh2SetBufferSize((unsigned char)ulLengthBlocks,0);
		bFeebCh2SetBufferSize((unsigned char)ulLengthBlocks,1);
	}*/

	if (  ucMem == 0  ) {
		bDmaReturn = bSdmaDmaM1Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks;
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	} else {
		bDmaReturn = bSdmaDmaM2Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks;
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	}

	return bDmaReturn;

}


void vSetDoubleBufferRightSize( unsigned char ucLength, unsigned char ucId ) {

	switch (ucId) {
		case 0:
			bFeebCh1SetBufferSize( ucLength, 1);
			break;
		case 1:
			bFeebCh2SetBufferSize( ucLength, 1);
			break;
		case 2:
			bFeebCh3SetBufferSize( ucLength, 1);
			break;
		case 3:
			bFeebCh4SetBufferSize( ucLength, 1);
			break;
		case 4:
			bFeebCh5SetBufferSize( ucLength, 1);
			break;
		case 5:
			bFeebCh6SetBufferSize( ucLength, 1);
			break;
		case 6:
			bFeebCh7SetBufferSize( ucLength, 1);
			break;
		case 7:
			bFeebCh8SetBufferSize( ucLength, 1);
			break;
		default:
			break;
	}

}

void vSetDoubleBufferLeftSize( unsigned char ucLength, unsigned char ucId ) {

	switch (ucId) {
		case 0:
			bFeebCh1SetBufferSize( ucLength, 0);
			break;
		case 1:
			bFeebCh2SetBufferSize( ucLength, 0);
			break;
		case 2:
			bFeebCh3SetBufferSize( ucLength, 0);
			break;
		case 3:
			bFeebCh4SetBufferSize( ucLength, 0);
			break;
		case 4:
			bFeebCh5SetBufferSize( ucLength, 0);
			break;
		case 5:
			bFeebCh6SetBufferSize( ucLength, 0);
			break;
		case 6:
			bFeebCh7SetBufferSize( ucLength, 0);
			break;
		case 7:
			bFeebCh8SetBufferSize( ucLength, 0);
			break;
		default:
			break;
	}

}

void vWaitUntilBufferEmpty( unsigned char ucId ) {

	switch (ucId) {
		case 0:
			while ( (bFeebGetCh1LeftFeeBusy()== TRUE) || (bFeebGetCh1RightFeeBusy()== TRUE)  ) {}
			break;
		case 1:
			while ( (bFeebGetCh2LeftFeeBusy()== TRUE) || (bFeebGetCh2RightFeeBusy()== TRUE)  ) {}
			break;
		case 2:
			while ( (bFeebGetCh3LeftFeeBusy()== TRUE) || (bFeebGetCh3RightFeeBusy()== TRUE)  ) {}
			break;
		case 3:
			while ( (bFeebGetCh4LeftFeeBusy()== TRUE) || (bFeebGetCh4RightFeeBusy()== TRUE)  ) {}
			break;
		case 4:
			//while ( (bFeebGetCh5LeftFeeBusy()== TRUE) || (bFeebGetCh5RightFeeBusy()== TRUE)  ) {}
			break;
		case 5:
			//while ( (bFeebGetCh6LeftFeeBusy()== TRUE) || (bFeebGetCh6RightFeeBusy()== TRUE)  ) {}
			break;
		case 6:
			//while ( (bFeebGetCh7LeftFeeBusy()== TRUE) || (bFeebGetCh7RightFeeBusy()== TRUE)  ) {}
			break;
		case 7:
			//while ( (bFeebGetCh8LeftFeeBusy()== TRUE) || (bFeebGetCh8RightFeeBusy()== TRUE)  ) {}
			break;
		default:
			break;
	}

}

inline unsigned long int uliReturnMaskR( unsigned char ucChannel ){
	unsigned long int uliOut;

	switch (ucChannel) {
		case 0:
			uliOut = LEDS_1R_MASK;
			break;
		case 1:
			uliOut = LEDS_2R_MASK;
			break;
		case 2:
			uliOut = LEDS_3R_MASK;
			break;
		case 3:
			uliOut = LEDS_4R_MASK;
			break;
		case 4:
			uliOut = LEDS_5R_MASK;
			break;
		case 5:
			uliOut = LEDS_6R_MASK;
			break;
		case 6:
			uliOut = LEDS_7R_MASK;
			break;
		case 7:
			uliOut = LEDS_8R_MASK;
			break;
		default:
			uliOut = LEDS_R_ALL_MASK;
			break;
	}
	return uliOut;
}


inline unsigned long int uliReturnMaskG( unsigned char ucChannel ){
	unsigned long int uliOut;

	switch (ucChannel) {
		case 0:
			uliOut = LEDS_1G_MASK;
			break;
		case 1:
			uliOut = LEDS_2G_MASK;
			break;
		case 2:
			uliOut = LEDS_3G_MASK;
			break;
		case 3:
			uliOut = LEDS_4G_MASK;
			break;
		case 4:
			uliOut = LEDS_5G_MASK;
			break;
		case 5:
			uliOut = LEDS_6G_MASK;
			break;
		case 6:
			uliOut = LEDS_7G_MASK;
			break;
		case 7:
			uliOut = LEDS_8G_MASK;
			break;
		default:
			uliOut = LEDS_G_ALL_MASK;
			break;
	}
	return uliOut;
}


void vLoadCtemp(void) {
	cTemp[0]="usiHkCcd1VodE";
	cTemp[1]="usiHkCcd1VodF";
	cTemp[2]="usiHkCcd1VrdMon";
	cTemp[3]="usiHkCcd2VodE";
	cTemp[4]="usiHkCcd2VodF";
	cTemp[5]="usiHkCcd2VrdMon";
	cTemp[6]="usiHkCcd3VodE";
	cTemp[7]="usiHkCcd3VodF";
	cTemp[8]="usiHkCcd3VrdMon";
	cTemp[9]="usiHkCcd4VodE";
	cTemp[10]="usiHkCcd4VodF";
	cTemp[11]="usiHkCcd4VrdMon";
	cTemp[12]="usiHkVccd";
	cTemp[13]="usiHkVrclk";
	cTemp[14]="usiHkViclk";
	cTemp[15]="usiHkVrclkLow";
	cTemp[16]="usiHk5vbPos";
	cTemp[17]="usiHk5vbNeg";
	cTemp[18]="usiHk33vbPos";
	cTemp[19]="usiHk25vaPos";
	cTemp[20]="usiHk33vdPos";
	cTemp[21]="usiHk25vdPos";
	cTemp[22]="usiHk15vdPos";
	cTemp[23]="usiHk5vref";
	cTemp[24]="usiHkVccdPosRaw";
	cTemp[25]="usiHkVclkPosRaw";
	cTemp[26]="usiHkVan1PosRaw";
	cTemp[27]="usiHkVan3NegRaw";
	cTemp[28]="usiHkVan2PosRaw";
	cTemp[29]="usiHkVdigFpgaRaw";
	cTemp[30]="usiHkVdigSpwRaw";
	cTemp[31]="usiHkViclkLow";
	cTemp[32]="usiHkAdcTempAE";
	cTemp[33]="usiHkAdcTempAF";
	cTemp[34]="usiHkCcd1Temp";
	cTemp[35]="usiHkCcd2Temp";
	cTemp[36]="usiHkCcd3Temp";
	cTemp[37]="usiHkCcd4Temp";
	cTemp[38]="usiHkWp605Spare";
	cTemp[39]="usiLowresPrtA0";
	cTemp[40]="usiLowresPrtA1";
	cTemp[41]="usiLowresPrtA2";
	cTemp[42]="usiLowresPrtA3";
	cTemp[43]="usiLowresPrtA4";
	cTemp[44]="usiLowresPrtA5";
	cTemp[45]="usiLowresPrtA6";
	cTemp[46]="usiLowresPrtA7";
	cTemp[47]="usiLowresPrtA8";
	cTemp[48]="usiLowresPrtA9";
	cTemp[49]="usiLowresPrtA10";
	cTemp[50]="usiLowresPrtA11";
	cTemp[51]="usiLowresPrtA12";
	cTemp[52]="usiLowresPrtA13";
	cTemp[53]="usiLowresPrtA14";
	cTemp[54]="usiLowresPrtA15";
	cTemp[55]="usiSelHiresPrt0";
	cTemp[56]="usiSelHiresPrt1";
	cTemp[57]="usiSelHiresPrt2";
	cTemp[58]="usiSelHiresPrt3";
	cTemp[59]="usiSelHiresPrt4";
	cTemp[60]="usiSelHiresPrt5";
	cTemp[61]="usiSelHiresPrt6";
	cTemp[62]="usiSelHiresPrt7";
	cTemp[63]="usiZeroHiresAmp";
}
