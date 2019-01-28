/*
 * crc8.h
 *
 *  Created on: 12/12/2018
 *      Author: Tiago-Low
 */

#ifndef CRC8_H_
#define CRC8_H_

#include <stddef.h>
#include "../simucam_definitions.h"

unsigned char ucCrc8(unsigned crc, unsigned char const *data, size_t len);
unsigned char ucCrc8wInit(char const *data, size_t len);

#endif /* CRC8_H_ */
