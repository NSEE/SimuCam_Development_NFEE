#include "pattern.h"

alt_u32 pattern_createPattern(alt_u8 mem_number, alt_u32 mem_offset, alt_u8 ccd_number, alt_u8 ccd_side, alt_u32 width_cols, alt_u32 height_rows)
{
	bDdr2SwitchMemory(mem_number); // Switch to the desired memory
	alt_u32 offset = mem_offset;
	alt_u8 i = 0;
	TSdmaPixelDataBlock *pxPixelData = (TSdmaPixelDataBlock *) (DDR2_EXT_ADDR_WINDOWED_BASE + offset); // Address the structure
	for (alt_u32 row = 0; row < height_rows; row++) // row sweep
	{
		for (alt_u32 col = 0; col < width_cols; col++) // column sweep
		{
			if (i == 64) // filled one block of memory, time to save full pattern and readress the structure
			{
				pxPixelData->ulliMask = PATTERN_MEMORY_FULLMASK;
				offset += sizeof(TSdmaPixelDataBlock);
				pxPixelData = (TSdmaPixelDataBlock *) (DDR2_EXT_ADDR_WINDOWED_BASE + offset);
				i = 0;
			}
			// Generate pattern pixel (16-bits)
			pxPixelData->usiPixel[i++] = PATTERN_MASK_TIMECODE(PATTERN_TIMECODE_VALUE) | PATTERN_MASK_CCDNUMBER(ccd_number) | PATTERN_MASK_CCDSIDE(ccd_side) | PATTERN_MASK_ROW(row) | PATTERN_MASK_COLUMN(col);
			//pxPixelData->usiPixel[i++] = 0xFFFF;
		}
	}
	//pxPixelData->ulliMask = xSimMeb.xFeeControl.xNfee[0].xMemMap.xCommon.ucPaddingMask.ullWord;
	pxPixelData->ulliMask = 0;
	for (alt_u8 j = 0; j < i; j++) // create the mask (i.e.: if i stops at block 3 , the mask will be 0b00...0111)
	{
		pxPixelData->ulliMask |= 0x8000000000000000 >> j;
	}

	offset += sizeof(TSdmaPixelDataBlock); // increment offset so we return the next available memory block
	return offset;
}
