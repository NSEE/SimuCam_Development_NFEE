/*
 * queue_commands_list.h
 *
 *  Created on: 23/01/2019
 *      Author: Tiago-note
 */

#ifndef QUEUE_COMMANDS_LIST_H_
#define QUEUE_COMMANDS_LIST_H_

/*
    MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL

    This protocol is for fast communication between Meb task, Fee Controller, Data Controller and Fee tasks During the Running Mode
    Will be used Queues to send the Commands, so we have 32 bits WORD

    - 0xFF FF FF FF
    - (Addr) (Type) (SubType) (Parameter)

    The first Byte will indicate the addr, if the command is for NFEE Controller, Data Controller, Meb or Fee Instances
    - MEB:              0x01
    - FEE CONTROLLER:   0x10
    - NFEE INSTANCE-0:  0x11
    - NFEE INSTANCE-1:  0x12
    - NFEE INSTANCE-2:  0x13
    - NFEE INSTANCE-3:  0x14
    - NFEE INSTANCE-4:  0x15
    - NFEE INSTANCE-5:  0x16
    - DATA CONTROLLER:  0x20

    The second byte will be used to specify the command;

    The third byte will be used to specify the sub-command if necessary;

    The fourth is reserved for any parameter if needed;


    MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL       MASK PROTOCOL
*/

/* Data structure to easy and fast parser */
typedef union qMask{
    unsigned char ucByte[4];
    unsigned int ulWord;
} tQMask;


/* -------------------------------- ADDRs (First Byte) ---------------------------------------*/
#define M_MEB_ADDR              0x01

#define M_FEE_CTRL_ADDR         0x10
#define M_NFEE_BASE_ADDR        0x11   /* 0x11, 0x12, 0x13, 0x14, 0x15, 0x16 */

#define M_DATA_CTRL_ADDR        0x20
/* -------------------------------------------------------------------------------------------*/





/*=====================================================================================================================*/
/*==================================  MEB  COMMAND   LIST   --   QUEUE (Second Byte) ==================================*/
/*=====================================================================================================================*/
/* These list of commands is used in the xMebQ to send message the Meb task */
#define Q_MEB_PUS 		0x01 /* Indicates that income a PUS command and it should check the xPus array */

/*=====================================================================================================================*/
/*=====================================================================================================================*/



/*=====================================================================================================================*/
/*=============================  FEE CONTROLLER  COMMAND   LIST   --   QUEUE  (Second Byte) ===========================*/
/*=====================================================================================================================*/
/* FORMAT: 32 bits MASK ()    0x BB BB */
#define M_NFC_CONFIG 		0x01 /* Indicates that should go to Config Mode */
#define M_NFC_RUN 		    0x02 /* Indicates that should go to Run Mode */

#define M_NFC_DMA_GIVEBACK  0x81
#define M_NFC_DMA_REQUEST   0x80 /* DO NOT ATTRIBUTE 0x80 TO ANY OTHER COMMAND */
/*=====================================================================================================================*/
/*=====================================================================================================================*/




/*=====================================================================================================================*/
/*=============================  DATA CONTROLLER  COMMAND   LIST   --   QUEUE  (Second Byte) ==========================*/
/*=====================================================================================================================*/
/* FORMAT: 32 bits MASK ()    0x BB BB */
#define M_DATA_CONFIG 		0x01 /* Indicates that should go to Config Mode */
#define M_DATA_RUN 		    0x02 /* Indicates that should go to Run Mode */

/*=====================================================================================================================*/
/*=====================================================================================================================*/



/*=====================================================================================================================*/
/*=============================  FEE Instances  COMMAND   LIST   --   QUEUE  (Second Byte) ============================*/
/*=====================================================================================================================*/
/* FORMAT: 32 bits MASK ()    0x BB BB */
#define M_FEE_CONFIG 		0x01 /* Indicates that should go to Config Mode */
#define M_FEE_RUN 		    0x02 /* Indicates that should go to Run Mode - Mode On -> StandBy */
#define M_FEE_STANDBY	    0x04
#define M_FEE_FULL_PATTERN  0x08

#define M_FEE_DMA_ACCESS    0x8F    /* This Command should be sent by the ISR of the Empty Buffer */


/*=====================================================================================================================*/
/*=====================================================================================================================*/





#endif /* QUEUE_COMMANDS_LIST_H_ */