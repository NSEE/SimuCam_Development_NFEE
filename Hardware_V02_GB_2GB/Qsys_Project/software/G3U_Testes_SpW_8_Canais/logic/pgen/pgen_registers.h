/*
 * pgen_registers.h
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

#ifndef PGEN_REGISTERS_H_
#define PGEN_REGISTERS_H_

	#define PGEN_REGISTERS_ADDRESS_OFFSET                    0x00

	#define PGEN_GENERATOR_CONTROL_STATUS_REGISTER_ADDRESS   (0X00 + PGEN_REGISTERS_ADDRESS_OFFSET)
	#define PGEN_START_CONTROL_BIT_MASK                      (1 << 4)
	#define PGEN_STOP_CONTROL_BIT_MASK                       (1 << 3)
	#define PGEN_RESET_CONTROL_BIT_MASK                      (1 << 2)
	#define PGEN_RESETED_STATUS_BIT_MASK                     (1 << 1)
	#define PGEN_STOPPED_STATUS_BIT_MASK                     (1 << 0)

	#define PGEN_INITIAL_TRANSMISSION_STATE_REGISTER_ADDRESS (0X01 + PGEN_REGISTERS_ADDRESS_OFFSET)
	#define PGEN_INITIAL_CCD_ID_MASK                         (0B11 << 9)
	#define PGEN_INITIAL_CCD_SIDE_MASK                       (1 << 8)
	#define PGEN_INITIAL_TIMECODE_MASK                       (0B11111111 << 0)


#endif /* PGEN_REGISTERS_H_ */
