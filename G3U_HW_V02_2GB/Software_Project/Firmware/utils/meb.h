/*
 * meb.h
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */

#ifndef MEB_H_
#define MEB_H_

#include "../simucam_definitions.h"
#include "fee.h"
#include "ccd.h"

#define N_OF_NFEE   6

/* Simucam operation modes */
typedef enum { sConfig = 0, sRun } tSimucamStates;

typedef struct Simucam {
    tSimucamStates  eMode;              /* Mode of operation for the Simucam */
    TNFee   xNfee[N_OF_NFEE];           /* All instances of control for the NFEE */
    unsigned char ucActualDDR;          /* Control the swap mechanism of DDRs ( 0: DDR0 or 1: DDR1 ) */
    bool    *pbEnabledNFEEs[N_OF_NFEE]; /* Which are the NFEEs that are enabled */
    bool    *pbRunningDmaNFEEs[N_OF_NFEE]; /* This array will be used for optimization propurses, mark all the NFEE that need access to DMA */
    /*todo: estruturas de controle para o simucam*/
}


#endif /* MEB_H_ */
