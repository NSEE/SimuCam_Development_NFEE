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

/* Definition of offset for each FEE in the DDR Memory */
/* Worksheet: ccd_logic_math.xlsx */
/* OFFESETs = [ 0, 224907824, 449815648, 674723472, 899631296, 1124539120, 1349446944, 1574354768  ] */

#define OFFSET_STEP_FEE         224907824
#define RESERVED_FEE_X          1048576
#define RESERVED_HALF_CCD_X     102400


/*  In the memory for each 64 pixels in the memory, that is 16 lines of a 64bits memory, will have 1 line for WindowMask. 
    One Block is 17 lines of a 64bits memory = 16 lines of pixels + 1 line for mask */

#define BLOCK_MEM_SIZE              16
#define BLOCK_MASK_MEM_SIZE         1
#define BLOCK_UNITY_SIZE            BLOCK_PIXELS_MEM_SIZE + BLOCK_MASK_MEM_SIZE

/*  For a 64 bits memory the value of bytes per line is 8. For a 32 bits memory the value will be 4*/
#define BYTES_PER_MEM_LINE          8


typedef struct FEEMemoryMap{
    unsigned long ulOffsetRoot;
    unsigned long ulTotalSizeBytes;
    unsigned long ulNMemLines;              /* Number of memory lines for pixels*/
    unsigned long ulNMaskMemLines;          /* Number of memory lines for the mask*/
    unsigned long ulNTotalMemLines;
    unsigned long ulNBlocks17;              /* Number of blocks pixels + mask (16+1) */
    unsigned char ucNofLeftBytes;
    unsigned char ucNofLeftLines;
} TFEEMemoryMap;


typedef struct FeeControl{
	unsigned char ucId; /* The id of the CCD will be 0..7 */
    TFEECcdDefinitions xCcdDefs;    /* Store the ccd configurations */
    TFEEMemoryMap xMemMaps;         /* Memory map control values */
} TFeeControl;



void vCalcMemoryDistribution( unsigned char ucFeeInst );

#endif /* FEE_H_ */
