#ifndef PATTERN_LIBRARY_H
#define PATTERN_LIBRARY_H

#ifdef  __cplusplus
extern "C" {
#endif

// include necessário para trabalhar com as ddr
#include "../api_driver/ddr2/ddr2.h"
#include "../api_driver/simucam_dma/simucam_dma.h"
#include "../simucam_definitions.h"
#include "meb.h"

#define PATTERN_MEMORY_FULLMASK 0xFFFFFFFFFFFFFFFF
#define PATTERN_TIMECODE_VALUE 0xFF

#define PATTERN_MASK_TIMECODE(timecode) ((timecode & 0x07) << 13)
#define PATTERN_MASK_CCDNUMBER(ccdnumber) ((ccdnumber & 0x03) << 11)
#define PATTERN_MASK_CCDSIDE(ccdside) ((ccdside & 0x01) << 10)
#define PATTERN_MASK_ROW(row) ((row & 0x1F) << 5)
#define PATTERN_MASK_COLUMN(column) (column & 0x1F)

// struct de um bloco de pixels (64 px + 64b de mascaras = 128 bytes de pixels + 8 bytes de mascaras)
/*typedef struct SdmaPixelDataBlock {
	alt_u16 usiPixel[64];
	alt_u64 ulliMask;
} TSdmaPixelDataBlock;*/

#ifdef  __cplusplus
}
#endif

alt_u32 pattern_createPattern(alt_u8 mem_number, alt_u32 mem_offset, alt_u8 ccd_number, alt_u8 ccd_side, alt_u32 width_cols, alt_u32 height_rows);

#endif
