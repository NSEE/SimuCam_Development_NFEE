/*
 * rmap.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "rmap.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
const TRmapMemAreaConfig cxDefaultsRmapMemAreaConfig = {
	.usiVStart                    = 0x0000,
	.usiVEnd                      = 0x119D,
	.usiChargeInjectionWidth      = 0x0000,
	.usiChargeInjectionGap        = 0x0000,
	.usiParallelToiPeriod         = 0x0465,
	.usiParallelClkOverlap        = 0x00FA,
	.ucCcdReadoutOrder1stCcd      = 0x00,
	.ucCcdReadoutOrder2ndCcd      = 0x01,
	.ucCcdReadoutOrder3rdCcd      = 0x02,
	.ucCcdReadoutOrder4thCcd      = 0x03,
	.usiNFinalDump                = 0x0000,
	.usiHEnd                      = 0x08F6,
	.bChargeInjectionEn           = FALSE,
	.bTriLevelClkEn               = FALSE,
	.bImgClkDir                   = FALSE,
	.bRegClkDir                   = FALSE,
	.usiPacketSize                = 0x7D8C,
	.usiIntSyncPeriod             = 0x186A,
	.uliTrapPumpingDwellCounter   = 0x000030D4,
	.bSyncSel                     = FALSE,
	.ucSensorSel                  = 0x03,
	.bDigitiseEn                  = TRUE,
	.bDGEn                        = FALSE,
	.bCcdReadEn                   = TRUE,
	.ucConvDly                    = 0x0F,
	.bHighPrecisionHkEn           = FALSE,
	.uliCcd1WinListPtr            = 0x00000000,
	.uliCcd1PktorderListPtr       = 0x00000000,
	.usiCcd1WinListLength         = 0x0000,
	.ucCcd1WinSizeX               = 0x00,
	.ucCcd1WinSizeY               = 0x00,
	.ucReg8ConfigReserved         = 0x00,
	.uliCcd2WinListPtr            = 0x00000000,
	.uliCcd2PktorderListPtr       = 0x00000000,
	.usiCcd2WinListLength         = 0x0000,
	.ucCcd2WinSizeX               = 0x00,
	.ucCcd2WinSizeY               = 0x00,
	.ucReg11ConfigReserved        = 0x00,
	.uliCcd3WinListPtr            = 0x00000000,
	.uliCcd3PktorderListPtr       = 0x00000000,
	.usiCcd3WinListLength         = 0x0000,
	.ucCcd3WinSizeX               = 0x00,
	.ucCcd3WinSizeY               = 0x00,
	.ucReg14ConfigReserved        = 0x00,
	.uliCcd4WinListPtr            = 0x00000000,
	.uliCcd4PktorderListPtr       = 0x00000000,
	.usiCcd4WinListLength         = 0x0000,
	.ucCcd4WinSizeX               = 0x00,
	.ucCcd4WinSizeY               = 0x00,
	.ucReg17ConfigReserved        = 0x00,
	.usiCcdVodConfig              = 0x0CCC,
	.usiCcd1VrdConfig             = 0x0E65,
	.ucCcd2VrdConfig0             = 0x65,
	.ucCcd2VrdConfig1             = 0x0E,
	.usiCcd3VrdConfig             = 0x0E65,
	.usiCcd4VrdConfig             = 0x0E65,
	.ucCcdVgdConfig0              = 0x0E,
	.ucCcdVgdConfig1              = 0xCF,
	.usiCcdVogConfig              = 0x019A,
	.usiCcdIgHiConfig             = 0x0000,
	.usiCcdIgLoConfig             = 0x0000,
	.ucTrkHldHi                   = 0x04,
	.ucTrkHldLo                   = 0x0E,
	.ucReg21ConfigReserved0       = 0x00,
	.ucCcdModeConfig              = 0x00,
	.ucReg21ConfigReserved1       = 0x00,
	.bClearErrorFlag              = FALSE,
	.ucRCfg1                      = 0x07,
	.ucRCfg2                      = 0x0B,
	.ucCdsclpLo                   = 0x09,
	.uliReg22ConfigReserved       = 0x00000000,
	.usiCcd1LastEPacket           = 0x0000,
	.usiCcd1LastFPacket           = 0x0000,
	.usiCcd2LastEPacket           = 0x0000,
	.ucReg23ConfigReserved        = 0x00,
	.usiCcd2LastFPacket           = 0x0000,
	.usiCcd3LastEPacket           = 0x0000,
	.usiCcd3LastFPacket           = 0x0000,
	.ucReg24ConfigReserved        = 0x00,
	.usiCcd4LastEPacket           = 0x0000,
	.usiCcd4LastFPacket           = 0x0000,
	.usiSurfaceInversionCounter   = 0x0064,
	.ucReg25ConfigReserved        = 0x00,
	.usiReadoutPauseCounter       = 0x07D0,
	.usiTrapPumpingShuffleCounter = 0x03E8
};

const TRmapMemAreaHk cxDefaultsRmapMemAreaHk = {
	.usiTouSense1                                                       = 0xFFFF,
	.usiTouSense2                                                       = 0xFFFF,
	.usiTouSense3                                                       = 0xFFFF,
	.usiTouSense4                                                       = 0xFFFF,
	.usiTouSense5                                                       = 0xFFFF,
	.usiTouSense6                                                       = 0xFFFF,
	.usiCcd1Ts                                                          = 0xFFFF,
	.usiCcd2Ts                                                          = 0xFFFF,
	.usiCcd3Ts                                                          = 0xFFFF,
	.usiCcd4Ts                                                          = 0xFFFF,
	.usiPrt1                                                            = 0xFFFF,
	.usiPrt2                                                            = 0xFFFF,
	.usiPrt3                                                            = 0xFFFF,
	.usiPrt4                                                            = 0xFFFF,
	.usiPrt5                                                            = 0xFFFF,
	.usiZeroDiffAmp                                                     = 0xFFFF,
	.usiCcd1VodMon                                                      = 0xFFFF,
	.usiCcd1VogMon                                                      = 0xFFFF,
	.usiCcd1VrdMonE                                                     = 0xFFFF,
	.usiCcd2VodMon                                                      = 0xFFFF,
	.usiCcd2VogMon                                                      = 0xFFFF,
	.usiCcd2VrdMonE                                                     = 0xFFFF,
	.usiCcd3VodMon                                                      = 0xFFFF,
	.usiCcd3VogMon                                                      = 0xFFFF,
	.usiCcd3VrdMonE                                                     = 0xFFFF,
	.usiCcd4VodMon                                                      = 0xFFFF,
	.usiCcd4VogMon                                                      = 0xFFFF,
	.usiCcd4VrdMonE                                                     = 0xFFFF,
	.usiVccd                                                            = 0xFFFF,
	.usiVrclkMon                                                        = 0xFFFF,
	.usiViclk                                                           = 0xFFFF,
	.usiVrclkLow                                                        = 0xFFFF,
	.usi5vbPosMon                                                       = 0xFFFF,
	.usi5vbNegMon                                                       = 0xFFFF,
	.usi3v3bMon                                                         = 0xFFFF,
	.usi2v5aMon                                                         = 0xFFFF,
	.usi3v3dMon                                                         = 0xFFFF,
	.usi2v5dMon                                                         = 0xFFFF,
	.usi1v5dMon                                                         = 0xFFFF,
	.usi5vrefMon                                                        = 0xFFFF,
	.usiVccdPosRaw                                                      = 0xFFFF,
	.usiVclkPosRaw                                                      = 0xFFFF,
	.usiVan1PosRaw                                                      = 0xFFFF,
	.usiVan3NegMon                                                      = 0xFFFF,
	.usiVan2PosRaw                                                      = 0xFFFF,
	.usiVdigRaw                                                         = 0xFFFF,
	.usiVdigRaw2                                                        = 0xFFFF,
	.usiViclkLow                                                        = 0xFFFF,
	.usiCcd1VrdMonF                                                     = 0xFFFF,
	.usiCcd1VddMon                                                      = 0xFFFF,
	.usiCcd1VgdMon                                                      = 0xFFFF,
	.usiCcd2VrdMonF                                                     = 0xFFFF,
	.usiCcd2VddMon                                                      = 0xFFFF,
	.usiCcd2VgdMon                                                      = 0xFFFF,
	.usiCcd3VrdMonF                                                     = 0xFFFF,
	.usiCcd3VddMon                                                      = 0xFFFF,
	.usiCcd3VgdMon                                                      = 0xFFFF,
	.usiCcd4VrdMonF                                                     = 0xFFFF,
	.usiCcd4VddMon                                                      = 0xFFFF,
	.usiCcd4VgdMon                                                      = 0xFFFF,
	.usiIgHiMon                                                         = 0xFFFF,
	.usiIgLoMon                                                         = 0xFFFF,
	.usiTsenseA                                                         = 0xFFFF,
	.usiTsenseB                                                         = 0xFFFF,
	.ucSpwStatusTimecodeFromSpw                                         = 0x00,
	.ucSpwStatusRmapTargetStatus                                        = 0x00,
	.ucSpwStatusSpwStatusReserved                                       = 0x00,
	.bSpwStatusRmapTargetIndicate                                       = FALSE,
	.bSpwStatusStatLinkEscapeError                                      = FALSE,
	.bSpwStatusStatLinkCreditError                                      = FALSE,
	.bSpwStatusStatLinkParityError                                      = FALSE,
	.bSpwStatusStatLinkDisconnect                                       = FALSE,
	.bSpwStatusStatLinkRunning                                          = FALSE,
	.ucReg32HkReserved                                                  = 0x00,
	.usiFrameCounter                                                    = 0x0000,
	.usiReg33HkReserved                                                 = 0x0000,
	.ucOpMode                                                           = 0x00,
	.ucFrameNumber                                                      = 0x00,
	.bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongXCoordinate = FALSE,
	.bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongYCoordinate = FALSE,
	.bErrorFlagsESidePixelExternalSramBufferIsFull                      = FALSE,
	.bErrorFlagsFSidePixelExternalSramBufferIsFull                      = FALSE,
	.bErrorFlagsTooManyOverlappingWindows                               = FALSE,
	.bErrorFlagsSramEdacCorrectable                                     = FALSE,
	.bErrorFlagsSramEdacUncorrectable                                   = FALSE,
	.bErrorFlagsBlockRamEdacUncorrectable                               = FALSE,
	.uliErrorFlagsErrorFlagsReserved                                    = 0x00000000,
	.ucFpgaMinorVersion                                                 = 0x00,
	.ucFpgaMajorVersion                                                 = 0x00,
	.usiBoardId                                                         = 0x0000,
	.usiReg35HkReserved                                                 = 0x0000
};
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viCh1HoldContext;
static volatile int viCh2HoldContext;
static volatile int viCh3HoldContext;
static volatile int viCh4HoldContext;
static volatile int viCh5HoldContext;
static volatile int viCh6HoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
/* todo:Trigger not working right */
void vRmapCh1HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 0;
	const unsigned char cucIrqNumber = 0;
	const unsigned char cucChNumber = 0;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 1 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh2HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 1;
	const unsigned char cucIrqNumber = 1;
	const unsigned char cucChNumber = 1;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 2 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh3HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 2;
	const unsigned char cucIrqNumber = 2;
	const unsigned char cucChNumber = 2;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 3 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh4HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 3;
	const unsigned char cucIrqNumber = 3;
	const unsigned char cucChNumber = 3;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 4 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh5HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 4;
	const unsigned char cucIrqNumber = 4;
	const unsigned char cucChNumber = 4;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 5 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh6HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 5;
	const unsigned char cucIrqNumber = 5;
	const unsigned char cucChNumber = 5;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 6 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

alt_u32 uliRmapCh1WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh2WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh3WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh4WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh5WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh6WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

void vRmapCh1EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh2EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh3EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh4EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh5EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh6EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

bool bRmapChEnableCodec(alt_u8 ucCommCh, bool bEnable){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		bValidCh = TRUE;
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {
		vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
		bStatus = TRUE;
	}

	return (bStatus);
}

bool vRmapInitIrq(alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	volatile TCommChannel *vpxCommChannel;
	switch (ucCommCh) {
	case eCommSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_1_RMAP_IRQ, pvHoldContext, vRmapCh1HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_2_RMAP_IRQ, pvHoldContext, vRmapCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_3_RMAP_IRQ, pvHoldContext, vRmapCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_4_RMAP_IRQ, pvHoldContext, vRmapCh4HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_5_RMAP_IRQ, pvHoldContext, vRmapCh5HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_6_RMAP_IRQ, pvHoldContext, vRmapCh6HandleIrq);
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

bool bRmapSoftRstMemAreaConfig(alt_u8 ucCommCh){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TRmapMemArea *vpxRmapMemArea = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {

		vpxRmapMemArea->xRmapMemAreaConfig = cxDefaultsRmapMemAreaConfig;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bRmapSoftRstMemAreaHk(alt_u8 ucCommCh){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TRmapMemArea *vpxRmapMemArea = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {

		vpxRmapMemArea->xRmapMemAreaHk = cxDefaultsRmapMemAreaHk;

		bStatus = TRUE;
	}

	return (bStatus);
}

/*
bool bRmapDumpMemAreaConfig(alt_u8 ucCommCh){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TRmapMemArea *vpxRmapMemArea = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {

		fprintf(fp, "SpaceWire Channel %u RMAP Configuration Area Dump:\n", (ucCommCh + 1));
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiVStart                    = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiVStart                   );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiVEnd                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiVEnd                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiChargeInjectionWidth      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiChargeInjectionWidth     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiChargeInjectionGap        = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiChargeInjectionGap       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiParallelToiPeriod         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiParallelToiPeriod        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiParallelClkOverlap        = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiParallelClkOverlap       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd      = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd      = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd      = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd      = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiNFinalDump                = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiNFinalDump               );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiHEnd                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiHEnd                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bChargeInjectionEn           = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bChargeInjectionEn          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bTriLevelClkEn               = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bTriLevelClkEn              );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bImgClkDir                   = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bImgClkDir                  );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bRegClkDir                   = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bRegClkDir                  );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiPacketSize                = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiPacketSize               );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiIntSyncPeriod             = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiIntSyncPeriod            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliTrapPumpingDwellCounter   = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliTrapPumpingDwellCounter  );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bSyncSel                     = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bSyncSel                    );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucSensorSel                  = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucSensorSel                 );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bDigitiseEn                  = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bDigitiseEn                 );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bDGEn                        = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bDGEn                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bCcdReadEn                   = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bCcdReadEn                  );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucConvDly                    = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucConvDly                   );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bHighPrecisionHkEn           = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bHighPrecisionHkEn          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliCcd1WinListPtr            = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliCcd1WinListPtr           );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliCcd1PktorderListPtr       = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliCcd1PktorderListPtr      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd1WinListLength         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1WinListLength        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd1WinSizeX               = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd1WinSizeX              );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd1WinSizeY               = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd1WinSizeY              );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucReg8ConfigReserved         = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucReg8ConfigReserved        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliCcd2WinListPtr            = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliCcd2WinListPtr           );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliCcd2PktorderListPtr       = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliCcd2PktorderListPtr      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd2WinListLength         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2WinListLength        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd2WinSizeX               = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2WinSizeX              );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd2WinSizeY               = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2WinSizeY              );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucReg11ConfigReserved        = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucReg11ConfigReserved       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliCcd3WinListPtr            = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliCcd3WinListPtr           );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliCcd3PktorderListPtr       = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliCcd3PktorderListPtr      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd3WinListLength         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3WinListLength        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd3WinSizeX               = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd3WinSizeX              );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd3WinSizeY               = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd3WinSizeY              );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucReg14ConfigReserved        = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucReg14ConfigReserved       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliCcd4WinListPtr            = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliCcd4WinListPtr           );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliCcd4PktorderListPtr       = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliCcd4PktorderListPtr      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd4WinListLength         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4WinListLength        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd4WinSizeX               = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd4WinSizeX              );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd4WinSizeY               = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd4WinSizeY              );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucReg17ConfigReserved        = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucReg17ConfigReserved       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcdVodConfig              = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcdVodConfig             );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd1VrdConfig             = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1VrdConfig            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd2VrdConfig0             = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2VrdConfig0            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcd2VrdConfig1             = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2VrdConfig1            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd3VrdConfig             = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3VrdConfig            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd4VrdConfig             = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4VrdConfig            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcdVgdConfig0              = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcdVgdConfig0             );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcdVgdConfig1              = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcdVgdConfig1             );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcdVogConfig              = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcdVogConfig             );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcdIgHiConfig             = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcdIgHiConfig            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcdIgLoConfig             = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcdIgLoConfig            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucTrkHldHi                   = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucTrkHldHi                  );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucTrkHldLo                   = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucTrkHldLo                  );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucReg21ConfigReserved0       = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucReg21ConfigReserved0      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCcdModeConfig              = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCcdModeConfig             );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucReg21ConfigReserved1       = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucReg21ConfigReserved1      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.bClearErrorFlag              = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaConfig.bClearErrorFlag             );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucRCfg1                      = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucRCfg1                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucRCfg2                      = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucRCfg2                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucCdsclpLo                   = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucCdsclpLo                  );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.uliReg22ConfigReserved       = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaConfig.uliReg22ConfigReserved      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd1LastEPacket           = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1LastEPacket          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd1LastFPacket           = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1LastFPacket          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd2LastEPacket           = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2LastEPacket          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucReg23ConfigReserved        = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucReg23ConfigReserved       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd2LastFPacket           = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2LastFPacket          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd3LastEPacket           = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3LastEPacket          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd3LastFPacket           = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3LastFPacket          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucReg24ConfigReserved        = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucReg24ConfigReserved       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd4LastEPacket           = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4LastEPacket          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiCcd4LastFPacket           = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4LastFPacket          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiSurfaceInversionCounter   = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiSurfaceInversionCounter  );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.ucReg25ConfigReserved        = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaConfig.ucReg25ConfigReserved       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiReadoutPauseCounter       = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiReadoutPauseCounter      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaConfig.usiTrapPumpingShuffleCounter = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaConfig.usiTrapPumpingShuffleCounter);
		fprintf(fp, "\n");

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bRmapDumpMemAreaHk(alt_u8 ucCommCh){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TRmapMemArea *vpxRmapMemArea = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {

		fprintf(fp, "SpaceWire Channel %u RMAP Housekeeping Area Dump:\n"  , (ucCommCh + 1));
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiTouSense1                                                       = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiTouSense1                                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiTouSense2                                                       = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiTouSense2                                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiTouSense3                                                       = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiTouSense3                                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiTouSense4                                                       = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiTouSense4                                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiTouSense5                                                       = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiTouSense5                                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiTouSense6                                                       = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiTouSense6                                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd1Ts                                                          = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd1Ts                                                          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd2Ts                                                          = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd2Ts                                                          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd3Ts                                                          = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd3Ts                                                          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd4Ts                                                          = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd4Ts                                                          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiPrt1                                                            = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiPrt1                                                            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiPrt2                                                            = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiPrt2                                                            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiPrt3                                                            = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiPrt3                                                            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiPrt4                                                            = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiPrt4                                                            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiPrt5                                                            = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiPrt5                                                            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiZeroDiffAmp                                                     = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiZeroDiffAmp                                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd1VodMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VodMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd1VogMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VogMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd1VrdMonE                                                     = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VrdMonE                                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd2VodMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VodMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd2VogMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VogMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd2VrdMonE                                                     = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VrdMonE                                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd3VodMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VodMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd3VogMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VogMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd3VrdMonE                                                     = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VrdMonE                                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd4VodMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VodMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd4VogMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VogMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd4VrdMonE                                                     = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VrdMonE                                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVccd                                                            = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVccd                                                            );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVrclkMon                                                        = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVrclkMon                                                        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiViclk                                                           = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiViclk                                                           );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVrclkLow                                                        = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVrclkLow                                                        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usi5vbPosMon                                                       = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usi5vbPosMon                                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usi5vbNegMon                                                       = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usi5vbNegMon                                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usi3v3bMon                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usi3v3bMon                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usi2v5aMon                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usi2v5aMon                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usi3v3dMon                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usi3v3dMon                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usi2v5dMon                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usi2v5dMon                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usi1v5dMon                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usi1v5dMon                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usi5vrefMon                                                        = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usi5vrefMon                                                        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVccdPosRaw                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVccdPosRaw                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVclkPosRaw                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVclkPosRaw                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVan1PosRaw                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVan1PosRaw                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVan3NegMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVan3NegMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVan2PosRaw                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVan2PosRaw                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVdigRaw                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVdigRaw                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiVdigRaw2                                                        = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiVdigRaw2                                                        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiViclkLow                                                        = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiViclkLow                                                        );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd1VrdMonF                                                     = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VrdMonF                                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd1VddMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VddMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd1VgdMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VgdMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd2VrdMonF                                                     = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VrdMonF                                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd2VddMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VddMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd2VgdMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VgdMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd3VrdMonF                                                     = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VrdMonF                                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd3VddMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VddMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd3VgdMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VgdMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd4VrdMonF                                                     = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VrdMonF                                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd4VddMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VddMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiCcd4VgdMon                                                      = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VgdMon                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiIgHiMon                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiIgHiMon                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiIgLoMon                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiIgLoMon                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiTsenseA                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiTsenseA                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiTsenseB                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiTsenseB                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.ucSpwStatusSpwStatusReserved                                       = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaHk.ucSpwStatusSpwStatusReserved                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bSpwStatusRmapTargetIndicate                                       = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bSpwStatusRmapTargetIndicate                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bSpwStatusStatLinkEscapeError                                      = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bSpwStatusStatLinkEscapeError                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bSpwStatusStatLinkCreditError                                      = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bSpwStatusStatLinkCreditError                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bSpwStatusStatLinkParityError                                      = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bSpwStatusStatLinkParityError                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bSpwStatusStatLinkDisconnect                                       = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bSpwStatusStatLinkDisconnect                                       );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bSpwStatusStatLinkRunning                                          = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bSpwStatusStatLinkRunning                                          );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.ucReg32HkReserved                                                  = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaHk.ucReg32HkReserved                                                  );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiFrameCounter                                                    = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaHk.usiFrameCounter                                                    );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiReg33HkReserved                                                 = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiReg33HkReserved                                                 );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.ucOpMode                                                           = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaHk.ucOpMode                                                           );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.ucFrameNumber                                                      = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaHk.ucFrameNumber                                                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongXCoordinate = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongXCoordinate );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongYCoordinate = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongYCoordinate );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bErrorFlagsESidePixelExternalSramBufferIsFull                      = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bErrorFlagsESidePixelExternalSramBufferIsFull                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bErrorFlagsFSidePixelExternalSramBufferIsFull                      = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bErrorFlagsFSidePixelExternalSramBufferIsFull                      );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bErrorFlagsTooManyOverlappingWindows                               = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bErrorFlagsTooManyOverlappingWindows                               );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bErrorFlagsSramEdacCorrectable                                     = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bErrorFlagsSramEdacCorrectable                                     );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bErrorFlagsSramEdacUncorrectable                                   = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bErrorFlagsSramEdacUncorrectable                                   );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.bErrorFlagsBlockRamEdacUncorrectable                               = 0x%01X\n" , (ucCommCh + 1),    (bool) vpxRmapMemArea->xRmapMemAreaHk.bErrorFlagsBlockRamEdacUncorrectable                               );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.uliErrorFlagsErrorFlagsReserved                                    = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaHk.uliErrorFlagsErrorFlagsReserved                                    );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.ucFpgaMinorVersion                                                 = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaHk.ucFpgaMinorVersion                                                 );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.ucFpgaMajorVersion                                                 = 0x%02X\n" , (ucCommCh + 1),  (alt_u8) vpxRmapMemArea->xRmapMemAreaHk.ucFpgaMajorVersion                                                 );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.usiBoardId                                                         = 0x%04X\n" , (ucCommCh + 1), (alt_u16) vpxRmapMemArea->xRmapMemAreaHk.usiBoardId                                                         );
		fprintf(fp, "  SpwCh%u.xRmapMemAreaHk.uliReg35HkReserved                                                 = 0x%08lX\n", (ucCommCh + 1), (alt_u32) vpxRmapMemArea->xRmapMemAreaHk.uliReg35HkReserved                                                 );
		fprintf(fp, "\n");

		bStatus = TRUE;
	}

	return (bStatus);
}
*/

bool bRmapSetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapIrqControl = pxRmapCh->xRmapIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapIrqControl = vpxCommChannel->xRmap.xRmapIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqFlags(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapIrqFlag = vpxCommChannel->xRmap.xRmapIrqFlag;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetEchoingMode(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapEchoingModeConfig = pxRmapCh->xRmapEchoingModeConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetEchoingMode(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapEchoingModeConfig = vpxCommChannel->xRmap.xRmapEchoingModeConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapCodecConfig = pxRmapCh->xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecConfig = vpxCommChannel->xRmap.xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecStatus = vpxCommChannel->xRmap.xRmapCodecStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecError(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecError = vpxCommChannel->xRmap.xRmapCodecError;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetMemConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapMemConfig = pxRmapCh->xRmapMemConfig;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapMemConfig = vpxCommChannel->xRmap.xRmapMemConfig;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapMemStatus = vpxCommChannel->xRmap.xRmapMemStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetRmapMemCfgArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig = pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;
}

bool bRmapGetRmapMemCfgArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;
}

bool bRmapSetRmapMemHkArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk = pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;

}

bool bRmapGetRmapMemHkArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;
}

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bRmapGetIrqControl(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetCodecConfig(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetCodecStatus(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetMemConfig(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetMemStatus(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetRmapMemCfgArea(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetRmapMemHkArea(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetEchoingMode(pxRmapCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
alt_u32 uliRmapReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	volatile alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}

//! [private functions]
