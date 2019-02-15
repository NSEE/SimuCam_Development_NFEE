
 /**
  *  @file   util.h
  * @Author Rafael Corsi (corsiferrao@gmail.com)
  * @date   Mar??o, 2015
  * @brief  Utilidades
  *
  */

#ifndef __UTIL_H__
#define __UTIL_H__

#include "../simucam_definitions.h"
#include "../utils/configs_simucam.h"


#define DEBUG_HIGH
#define DEBUG_MID

/* Defines */
#define CPU_FREQ_MH 50000000


/* share memory */
alt_u32 pnt_memory;

/* prototype */
alt_32 _reg_write(int BASE_ADD, alt_32 REG_ADD, alt_32 REG_Dado );
alt_32 _reg_read(int BASE_ADD, alt_32 REG_ADD, alt_32* REG_Dado );
void _split_codec_status(int codec_status, int *started, int *connecting, int *running);
void _print_codec_status(int codec_status);
//void _print_link_config(LinkConfig *link);

alt_u8 aatoh(alt_u8 *buffer);
alt_u8 toint(alt_u8 ascii);
alt_u8 Verif_Error(alt_u8 error_code);

/**
 * @brief Set the High level log file
 */


/**git pul
 * @brief Set the Mid level log file
 */


/**
 * @brief Set the low level log file
 */


#endif /*UTIL */

