/*
 * simucam_definitions.h
 *
 *  Created on: 06/12/2018
 *      Author: Tiago-Low
 */

#ifndef SIMUCAM_DEFINITIONS_H_
#define SIMUCAM_DEFINITIONS_H_

/*--Activate only during development fase--*/
#define STACK_MONITOR   1
#define QUERY_STACK     1
#define BY_PASS 		0
/**-----------------------------------------*/
#define DEBUG_ON    	1
#if defined(STACK_MONITOR) || defined(QUERY_STACK) || defined(BY_PASS)
    #define DEBUG_ON    1 /* This value should always be 1 when one of the above options is defined */
#endif
#define debug( fp, mensage )    if ( DEBUG_ON ) { fprintf( fp, mensage ); }



#ifndef bool
	//typedef short int bool;
	//typedef enum e_bool { false = 0, true = 1 } bool;
	//#define false   0
	//#define true    1
	#define FALSE   0
	#define TRUE    1
#endif


#include <altera_up_sd_card_avalon_interface.h>
#include <altera_msgdma.h>
#include <altera_avalon_pio_regs.h>
#include <errno.h>
#include "os_cpu.h"
#include "system.h"
#include <stdio.h>
#include <sys/alt_stdio.h>

/*---- initialization_simucam -----*/
#include "driver/eth/eth.h"
#include "driver/leds/leds.h"
#include "driver/seven_seg/seven_seg.h"
/*---------------------------------*/


/* Variable that will carry the debug JTAG device file descriptor*/
#ifdef DEBUG_ON
    extern FILE* fp;
#endif

#define min_sim( x , y ) ((x < y) ? x : y)

#include <altera_avalon_uart.h>


#endif /* SIMUCAM_DEFINITIONS_H_ */
