/*
 * feeV2.h
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */

#ifndef UTILS_FEEV2_H_
#define UTILS_FEEV2_H_

#include "../simucam_definitions.h"
#include "ccd.h"
#include "../driver/comm/comm_channel.h"



/* Meb state is here to Data controller and NFEE controller use the same enum */
typedef enum { sMebInit  = 0, sMebConfig, sMebRun, sMebToConfig, sMebToRun } tSimucamStates;


/* Definition of offset for each FEE in the DDR Memory */
/* Worksheet: ccd_logic_math.xlsx */
/* OFFESETs = [ 0, 224907824, 449815648, 674723472, 899631296, 1124539120, 1349446944, 1574354768  ] */
#define OFFSET_STEP_FEE         224907840
#define LUT_SIZE                10485760
#define LUT_INITIAL_ADDR        ( OFFSET_STEP_FEE - LUT_SIZE )
#define RESERVED_FEE_X          1048576
#define RESERVED_HALF_CCD_X     102400

/*  In the memory for each 64 pixels in the memory, that is 16 lines of a 64bits memory, will have 1 line for WindowMask.
    One Block is 17 lines of a 64bits memory = 16 lines of pixels + 1 line for mask */
#define BLOCK_MEM_SIZE          16
#define BLOCK_MASK_MEM_SIZE     1
#define BLOCK_UNITY_SIZE        BLOCK_PIXELS_MEM_SIZE + BLOCK_MASK_MEM_SIZE

/*  For a 64 bits memory the value of bytes per line is 8. For a 32 bits memory the value will be 4*/
#define BYTES_PER_MEM_LINE      8
#define PIXEL_PER_MEM_LINE      (unsigned int)(BYTES_PER_MEM_LINE / BYTES_PER_PIXEL)

/* Number of CCDS per FEE */
#define N_OF_CCD                4


/*For TRAP Mode*/
#define CHARGE_TIME 			0.5 //Seconds
#define DEFAULT_SYNC_TIME 		6.25 //Seconds



/* FEE operation modes */
typedef enum { sInit = 0, sConfig, sOn, sStandBy, sFullPattern, sWinPattern, sFullImage, sWindowing, sParTrap1, sParTrap2, sSerialTrap1, sSerialTrap2,
	sConfig_Enter, sOn_Enter, sStandby_Enter,
	sFullPattern_Enter, sFullPattern_Out, sWinPattern_Enter, sWinPattern_Out,
	sFullImage_Enter, sFullImage_Out, sWindowing_Enter, sWindowing_Out,
	sParTrap1_Enter, sParTrap1_Out, sParTrap2_Enter, sParTrap2_Out,
	sSerialTrap1_Enter, sSerialTrap1_Out, sSerialTrap2_Enter, sSerialTrap2_Out,
	sWaitSync, redoutWaitSync,
	redoutCycle_Enter, redoutCycle_Out, redoutWaitBeforeSyncSignal, redoutCheckDTCUpdate, redoutCheckRestr, redoutConfigureTrans, redoutPreLoadBuffer,
	redoutTransmission, redoutEndSch, readoutWaitingFinishTransmission} tFEEStates;

typedef enum { dsPattern = 0, dsSSD, dsWindowStack } tDataSource;


 /* Error Injection Control Register Struct */
typedef struct DpktErrorCopy {
	volatile bool bEnabled;		/*Is error injection Enabled?*/
	volatile bool bTxDisabled; /* Error Injection Tx Disabled Enable */
	volatile bool bMissingPkts; /* Error Injection Missing Packets Enable */
	volatile bool bMissingData; /* Error Injection Missing Data Enable */
	volatile alt_u8 ucFrameNum; /* Error Injection Frame Number of Error */
	volatile alt_u16 usiSequenceCnt; /* Error Injection Sequence Counter of Error */
	volatile alt_u16 usiDataCnt; /* Error Injection Data Counter of Error */
	volatile alt_u16 usiNRepeat; /* Error Injection Number of Error Repeats */
} TDpktErrorCopy;


typedef struct FEEMemoryMap{
    unsigned long ulOffsetRoot;     /* Root Addr Ofset of the FEE*/
    unsigned long ulTotalBytes;     /* Total of bytes of the FEE in the memory */
    unsigned long ulLUTAddr;        /* Initial Addr of the Look Up Table */
    TCcdMemDef xCommon;             /* Common value of memory definitions for the 4 CCds */
    TFullCcdMemMap xCcd[N_OF_CCD];   /* Memory map of the four Full CCDs (xLeft,xRight) */
} TFEEMemoryMap;


typedef struct TrapModeControl{
	bool bEnabledSerial;
	bool bEnabled;
	bool bPumping;
	bool bEmiting;
	unsigned short ucICountSyncs;
	unsigned short usiNofSyncstoWait;
	double dTotalWait;
	alt_u32 uliDT;
	alt_u16 usiSH;
	TDpktPixelDelay xRestoreDelays;
} TTrapModeControl;

typedef enum { sLeft = 0, sRight, sBoth } tNFeeSide;
typedef struct FeeControl{
    bool bEnabled;
    bool bUsingDMA;
    bool bLogging;                      /* Log the RMAP Packets */
    bool bEchoing;                      /* Echo the RMAP Packets */
    bool bChannelEnable;                /* SPW Channel is enable? */
    bool bSimulating;                   /* Start at any running mode - needs sync */
    bool bWatingSync;
    bool bTransientMode;
    unsigned char *pActualMem;				/* Point to the actual memory in simulation */
    unsigned char ucTimeCode;               /* Timecode [NFEESIM-UR-488]*/
    unsigned char ucROutOrder[N_OF_CCD];/* CCD Readout Order  [<0..3>, <0..3>, <0..3>, <0..3>]*/
    tNFeeSide   eSide;                   /* Which side of the CCD is configured in the NFEE to be transmited */

    volatile tFEEStates eState;                   /* Real State of NFEE */
    volatile unsigned char ucTransmited;	/* Count how many sides was sent*/
    tFEEStates eLastMode;
    tFEEStates eMode;
    tFEEStates eNextMode;

    TTrapModeControl xTrap;
    TDpktErrorCopy	xErrorSWCtrl;

    tDataSource eDataSource;

} TFeeControl;

typedef struct RmapChanges{
    volatile bool 	bvStartvEnd;
    volatile bool 	bReadoutOrder;
    volatile bool 	bhEnd;
    volatile bool 	bPacketSize;
    volatile bool 	bSyncSenSelDigitase;
} TRmapChanges;

typedef struct RmapCopy{
	volatile TRmapChanges	xbRmapChanges;
	volatile TFEEMemoryMap 	xCopyMemMap;          	/* Memory map of the NFEE */
    volatile TFeeControl   	xCopyControl;         	/* Operation Control of the NFEE */
    volatile alt_u16 	  	usiCopyPacketLength; 	/* Data Packet Packet Length */
    volatile bool 		  	bCopyDigitaliseEn; 			/* FEE Digitalise Enable */
	volatile bool 			bCopyReadoutEn; 			/* FEE Readout Enable */
} TRmapCopy;

typedef struct NFee {
    unsigned char ucId;             /* ID of the NFEE instance */
    unsigned char ucSPWId;             /* ID of the SPW instance For This NFEE Instance */
    TFEEMemoryMap xMemMap;          /* Memory map of the NFEE */
    TFeeControl   xControl;         /* Operation Control of the NFEE */
    TCcdInfos xCcdInfo;             /* Pixel configuration of the NFEE */
    TCommChannel xChannel;
    TRmapCopy	 xCopyRmap;
} TNFee;

typedef struct FEETransmission{
	bool bFirstT;
	bool bDmaReturn[2];				/*Two half CCDs-> Left and Right*/
	bool bFinal[2];					/*Two half CCDs-> Left and Right*/
	unsigned long ulAddrIni;		/* (byte) Initial transmission data, calculated after */
	unsigned long ulAddrFinal;
	unsigned long ulTotalBlocks;
	unsigned long ulSMD_MAX_BLOCKS;
	tNFeeSide side;
	unsigned char ucMemory;
	unsigned char ucCcdNumber;
	TCcdMemMap *xCcdMapLocal[2]; 	/*Two half CCDs-> Left and Right*/
} TFEETransmission;

void vResetMemCCDFEE( TNFee *pxNfeeL );
void vNFeeStructureInit( TNFee *pxNfeeL, unsigned char ucIdNFEE );
void vUpdateMemMapFEE( TNFee *pxNfeeL );
bool bMemNewLimits( TNFee *pxNfeeL, unsigned short int usiVStart, unsigned short int usiVEnd );
void vResetMemCCDFEE( TNFee *pxNfeeL );

#endif /* UTILS_FEEV2_H_ */
