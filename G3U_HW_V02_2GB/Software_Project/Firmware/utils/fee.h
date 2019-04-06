/*
 * fee.h
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */

#ifndef FEE_H_
#define FEE_H_

#include "../simucam_definitions.h"
#include "ccd.h"
#include "../driver/comm/comm_channel.h"

/* Meb state is here to Data controller and NFEE controller use the same enum */
typedef enum { sMebInit  = 0, sMebToConfig, sMebToRun, sMebConfig, sMebRun } tSimucamStates;


/* Definition of offset for each FEE in the DDR Memory */
/* Worksheet: ccd_logic_math.xlsx */
/* OFFESETs = [ 0, 224907824, 449815648, 674723472, 899631296, 1124539120, 1349446944, 1574354768  ] */
#define OFFSET_STEP_FEE         224907824
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


/* This struct will contain the pointer for the functions that manipulate all the double buffers pf all Channels SPW (8) */
/*typedef struct FuncDoubleBuffers{

} tFDbBuffer ;*/


/* FEE operation modes */
typedef enum { sFeeInit = 0, sFeeConfig, sFeeOn, sFeeStandBy, sFeeTestFullPattern, sToFeeConfig, sToFeeStandBy, sToTestFullPattern, sSIMFeeConfig, sSIMFeeStandBy, sNextPatternIteration, sEndTransmission ,sFeeWaitingSync} tFEEStates;

typedef struct FEEMemoryMap{
    unsigned long ulOffsetRoot;     /* Root Addr Ofset of the FEE*/
    unsigned long ulTotalBytes;     /* Total of bytes of the FEE in the memory */
    unsigned long ulLUTAddr;        /* Initial Addr of the Look Up Table */
    TCcdMemDef xCommon;             /* Common value of memory definitions for the 4 CCds */
    TFullCcdMemMap xCcd[N_OF_CCD];   /* Memory map of the four Full CCDs (xLeft,xRight) */
} TFEEMemoryMap;

typedef enum { sLeft = 0, sRight, sBoth } tNFeeSide;
typedef struct FeeControl{
    bool bEnabled;
    bool bDMALocked;					/* Is true while the FEee has the mutex of the DMA */
    bool bUsingDMA;
    bool bLogging;                      /* Log the RMAP Packets */
    bool bEchoing;                      /* Echo the RMAP Packets */
    bool bChannelEnable;                /* SPW Channel is enable? */
    bool bSimulating;                   /* Start at any running mode - needs sync */
    bool bWatingSync;
    unsigned char *pActualMem;				/* Point to the actual memory in simulation */
    unsigned char ucTimeCode;               /* Timecode [NFEESIM-UR-488]*/
    unsigned char ucROutOrder[N_OF_CCD];/* CCD Readout Order  [<0..3>, <0..3>, <0..3>, <0..3>]*/
    volatile tFEEStates eMode;                   /* Mode of NFEE */
    tFEEStates eNextMode;
    tNFeeSide   eSide;                   /* Which side of the CCD is configured in the NFEE to be transmited */
} TFeeControl;

typedef struct NFee {
    unsigned char ucId;             /* ID of the NFEE instance */
    unsigned char ucSPWId;             /* ID of the SPW instance For This NFEE Instance */
    TFEEMemoryMap xMemMap;          /* Memory map of the NFEE */
    TFeeControl   xControl;         /* Operation Control of the NFEE */
    TCcdInfos xCcdInfo;             /* Pixel configuration of the NFEE */
    TCommChannel xChannel;
} TNFee;

typedef struct FFee {
    /* To Be Defined */
} TFFee;

void vNFeeStructureInit( TNFee *pxNfeeL, unsigned char ucIdNFEE );
void vUpdateMemMapFEE( TNFee *pxNfeeL );
void vNFeeNotInUse( TNFee *pxNfeeL, unsigned char ucIdNFEE );
void vResetMemCCDFEE( TNFee *pxNfeeL );

#endif /* FEE_H_ */
