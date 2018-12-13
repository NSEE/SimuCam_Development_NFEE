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
#define BY_PASS 		1
/**-----------------------------------------*/
#define DEBUG_ON    	1
#if defined(STACK_MONITOR) || defined(QUERY_STACK) || defined(BY_PASS)
    #define DEBUG_ON    1 /* This value should always be 1 when one of the above options is defined */
#endif
#define debug( fp, mensage )    if ( DEBUG_ON ) { fprintf( fp, mensage ); }



#ifndef bool
	typedef short int bool;
	#define false   0
	#define true    1
	#define FALSE   0
	#define TRUE    1
#endif



/* Variable that will carry the debug JTAG device file descriptor*/
#ifdef DEBUG_ON
    extern FILE* fp;
#endif

#define min_sim( x , y ) ((x < y) ? x : y)

#include <altera_avalon_uart.h>


#endif /* SIMUCAM_DEFINITIONS_H_ */
