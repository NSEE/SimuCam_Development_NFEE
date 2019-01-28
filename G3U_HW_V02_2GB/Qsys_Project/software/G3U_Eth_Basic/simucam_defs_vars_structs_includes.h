/*
 * simucam_defs_vars_structs_includes.h
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#ifndef SIMUCAM_DEFS_VARS_STRUCTS_INCLUDES_H_
#define SIMUCAM_DEFS_VARS_STRUCTS_INCLUDES_H_


#ifndef bool
	typedef short int bool;
	#define false 0
	#define true 1
	#define FALSE 0
	#define TRUE 1
#endif


/*+++++++++++++++++++++++ Includes +++++++++++++++++++++++ */
/*---- Main -----*/
	#include <stdio.h>
	#include <stdlib.h> // malloc, free
	#include <string.h>
	#include <stddef.h>
	#include <unistd.h>  // usleep (unix standard?)
	#include "system.h"
/*---------------*/

/*---- Simple_Socket_Server -----*/
	#include <ctype.h>
	/* MicroC/OS-II definitions */
	#include "includes.h"
	/* Simple Socket Server definitions */
	#include "alt_error_handler.h"
	/* Nichestack definitions */
	#include "ipport.h"
	#include "tcpport.h"
	#include "libport.h"
	#include "osport.h"
/*-------------------------------*/

/*---- initialization_simucam -----*/
	#include "logic/eth/eth.h"
	#include "driver/leds/leds.h"
	#include "driver/seven_seg/seven_seg.h"
/*---------------------------------*/

/*----- rtos_tasks -------------*/
	#include <altera_msgdma.h>
/*------------------------------*/

/*----- sdcard_file_manager -------------*/
	#include <altera_up_sd_card_avalon_interface.h>
/*------------------------------*/

/*----------- meb_includes --------------*/
	//#include "sys/alt_flash.h"
	//#include "sys/alt_flash_types.h"
	//#include "io.h"
	//#include "altera_avalon_pio_regs.h" //IOWR_ALTERA_AVALON_PIO_DATA
	//#include "sys/alt_irq.h"  // interrupt
	//#include "sys/alt_alarm.h" // time tick function (alt_nticks(), alt_ticks_per_second())
	//#include "sys/alt_timestamp.h"
	//#include "sys/alt_stdio.h"
	//#include <fcntl.h>
/*---------------------------------------*/


/*-------- led.c ---------*/
	/* Device driver accessor macros for peripherial I/O component
	 * (used for leds).) */
	#include <altera_avalon_pio_regs.h>
/*---------------------------*/

/*----- alt_error_handler -------------*/
	#include <errno.h>
/*------------------------------*/


/*----- network_utilities -------------*/
	#include <alt_types.h>
	#include <sys/alt_flash.h>
	#include <io.h>
	#include <alt_iniche_dev.h>
/*------------------------------*/


/*----- driver/leds/leds -------------*/
	//#include <altera_avalon_pio_regs.h>
/*------------------------------*/


/*----- utils/util -------------*/
	#include "os_cpu.h"
/*------------------------------*/

/*----- logic/dma/dma -------------*/
	#include <altera_msgdma.h>
/*------------------------------*/


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/








/* =============== From Simple_socket_server ==========================*/

/*
 * TX & RX buffer sizes for all socket sends & receives in our sss app
 */
#define SSS_RX_BUF_SIZE  1500
#define SSS_TX_BUF_SIZE  1500

/*
 * Here we structure to manage sss communication for a single connection
 */
typedef struct SSS_SOCKET
{
  enum { READY, COMPLETE, CLOSE } state;
  int       fd;
  int       close;
  INT8U     rx_buffer[SSS_RX_BUF_SIZE];
  INT8U     *rx_rd_pos; /* position we've read up to */
  INT8U     *rx_wr_pos; /* position we've written up to */
} SSSConn;
/*=====================================================================*/


#endif /* SIMUCAM_DEFS_VARS_STRUCTS_INCLUDES_H_ */
