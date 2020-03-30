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

#define M_LUT_H_ADDR        	0x40
/* -------------------------------------------------------------------------------------------*/


/* General command to sync */
#define M_MASTER_SYNC               0xE0    /* Command send byt the Sync Interrupt */
#define M_SYNC                      0xE1    /* Command send byt the Sync Interrupt */
#define M_PRE_MASTER                0xE2    /* Command send byt the Sync Interrupt */

#define M_BEFORE_SYNC               0xE4    /* Indicate that a sync will occours soon, will be used to prepare the double buffer */
#define M_BEFORE_MASTER             0xE8


/*=====================================================================================================================*/
/*==================================  MEB  COMMAND   LIST   --   QUEUE (Second Byte) ==================================*/
/*=====================================================================================================================*/
/* These list of commands is used in the xMebQ to send message the Meb task */
#define Q_MEB_PUS 		0x01 /* Indicates that income a PUS command and it should check the xPus array */

#define Q_MEB_DATA_MEM_IN_USE   		 0x11 	/* DTC Updating memory*/
#define Q_MEB_DATA_MEM_UPD_FIN   		 0x12 	/* DTC Indicates That finish the load of the data in the RAM memory Q_MEB_DATA_MEM_UPDATE_FINISHED*/

#define Q_MEB_FEE_MEM_IN_USE				0x21 	/* FEE Using memory */
#define Q_MEB_FEE_MEM_TRAN_FIN 				0x22 	/* FEE CCD transmitted Q_MEB_FEE_MEM_TRANSMISSION_FINISHED*/
#define Q_MEB_FEE_DIS                       0x24 	/* FEE Instance Inactive todo: decide if will be used*/
/*=====================================================================================================================*/
/*=====================================================================================================================*/



/*=====================================================================================================================*/
/*=============================  FEE CONTROLLER  COMMAND   LIST   --   QUEUE  (Second Byte) ===========================*/
/*=====================================================================================================================*/
/* FORMAT: 32 bits MASK ()    0x BB BB */
#define M_NFC_CONFIG 		0x01 /* Indicates that should go to Config Mode */
#define M_NFC_RUN 		    0x02 /* Indicates that should go to Run Mode */
#define M_NFC_CONFIG_FORCED 0xA1 /* Indicates that should go to Config Mode - Forced */
#define M_NFC_RUN_FORCED    0xA2 /* Indicates that should go to Run Mode - Forced */

#define M_NFC_CONFIG_RESET    0xA3 /* Indicates that should go to Run Mode - Forced */

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
#define M_DATA_CONFIG_FORCED 0xA1 /* Indicates that should go to Config Mode - Forced */
#define M_DATA_RUN_FORCED    0xA2 /* Indicates that should go to Run Mode - Forced */

#define M_DATA_FTDI_BUFFER_FULL    0xB1 /* Indicates IRQ ftdi buffer full */
#define M_DATA_FTDI_BUFFER_LAST    0xB2 /* Indicates IRQ last packet */
#define M_DATA_FTDI_BUFFER_EMPTY   0xB4 /* Indicates IRQ buffer empty */

#define M_DATA_FTDI_ERROR   0xC1 	/* Indicates IRQ Communication error */

/*=====================================================================================================================*/
/*=====================================================================================================================*/



/*=====================================================================================================================*/
/*=============================  FEE Instances  COMMAND   LIST   --   QUEUE  (Second Byte) ============================*/
/*=====================================================================================================================*/
/* FORMAT: 32 bits MASK ()    0x BB BB */
#define M_FEE_CONFIG 		0x01 /* Indicates that should go to Config Mode */
#define M_FEE_RUN 		    0x02 /* Indicates that should go to Run Mode - Mode On -> StandBy */
#define M_FEE_ON            0x03
#define M_FEE_STANDBY	    0x04
#define M_FEE_FULL_PATTERN  0x05
#define M_FEE_WIN_PATTERN   0x06
#define M_FEE_FULL          0x07
#define M_FEE_WIN           0x08
#define M_FEE_PAR_TRAP_1    0x09
#define M_FEE_PAR_TRAP_2    0x0A
#define M_FEE_SERIAL_TRAP_1 0x0B
#define M_FEE_SERIAL_TRAP_2 0x0C
#define M_FEE_TRANS_FINISHED_L 0x0D
#define M_FEE_TRANS_FINISHED_D 0x0E

#define M_FEE_DMA_ACCESS    0x8F    /* This Command should be sent by the ISR of the Empty Buffer */

#define M_FEE_CONFIG_FORCED		    0xA1 /* Indicates that should go to Config Mode */
#define M_FEE_RUN_FORCED            0xA2 /* Indicates that should go to Run Mode - Mode On -> StandBy */
#define M_FEE_ON_FORCED             0xA3
#define M_FEE_STANDBY_FORCED        0xA4
#define M_FEE_FULL_PATTERN_FORCED   0xA5
#define M_FEE_WIN_PATTERN_FORCED    0xA6
#define M_FEE_FULL_FORCED           0xA7
#define M_FEE_WIN_FORCED            0xA8
#define M_FEE_PAR_TRAP_1_FORCED     0xA9
#define M_FEE_PAR_TRAP_2_FORCED     0xAA
#define M_FEE_SERIAL_TRAP_1_FORCED  0xAB
#define M_FEE_SERIAL_TRAP_2_FORCED  0xAC

#define M_FEE_RMAP                  0xF0 /* RMAP command received */

#define M_FEE_CAN_ACCESS_NEXT_MEM   0x71 /* Meb send this message to inform FEE instances that already can access the data in the memory that DTC is updating, after DTC finishes the job */
/*=====================================================================================================================*/
/*=====================================================================================================================*/



/*=====================================================================================================================*/
/*=============================  LUT HANDLER  COMMAND   LIST   --   QUEUE  (Second Byte) ==========================*/
/*=====================================================================================================================*/
/* FORMAT: 32 bits MASK ()    0x BB BB */
#define M_LUT_UPDATE 				0xF0 /* Indicates that there's LUT update */

#define M_LUT_FTDI_BUFFER_FINISH    0xB2 /* Indicates IRQ last packet */
#define M_LUT_FTDI_ERROR   			0xC1 	/* Indicates IRQ Communication error */
/*=====================================================================================================================*/
/*=====================================================================================================================*/


#endif /* QUEUE_COMMANDS_LIST_H_ */
