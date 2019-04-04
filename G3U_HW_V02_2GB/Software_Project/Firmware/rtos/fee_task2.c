/*
 * fee_task2.c
 *
 *  Created on: 29/03/2019
 *      Author: TiagoLow
 */

#include "fee_task2.h"


static unsigned char ucIterationSide;

void vFeeTask2(void *task_data) {
	static TNFee *pxNFee;
	INT8U error_code;
	unsigned char ucMemUsing;
	static alt_u32 tCodFeeTask;
	alt_u32 tCodeNext;
	static unsigned long incrementador; /* remover*/
	tQMask uiCmdFEE;
	TCcdMemMap *xCcdMapLocal;
	unsigned char ucReadout;
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
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = 32768;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = 0; /* 32 KB */
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucProtocolId = xDefaults.usiDataProtId; /* 0xF0 ou  0x02*/
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xDefaults.usiDpuLogicalAddr + 2;
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

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x06; /*Off*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Disable the link SPW */
				bDisableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = FALSE;

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

				/* Cleaning other syncs that maybe in the queue */
				pxNFee->xControl.bWatingSync = FALSE;
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
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x00; /*sToFeeStandBy*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				/* Disable RMAP interrupts */
				bEnableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucId);

				/* Disable the link SPW */
				bEnableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = TRUE;

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
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = ucReadout;
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
