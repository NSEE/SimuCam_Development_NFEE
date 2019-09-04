/* BoF */
/*
crc.h
Created on: 06/11/2017
Author:  Thiago Pereira Ricciardi
*/

#ifndef CRC_H_
#define CRC_H_

#include <stdio.h>

// CRC8 startup value
#define CRC_START_8 (0x00);

// CRC8/KOOP startup value
#define CRC_START_8_KOOP (0x00);

// CRC16 startup value
#define CRC_START_16 (0x0000);

// CRC16-CCITT startup value
#define CRC_START_16_CCITT (0xFFFF);

// CRC32 startup value
#define CRC_START_32 (0xFFFFFFFF);

#ifdef __cplusplus
extern "C" {
#endif

// CRC-8
// Check: 0xF4 | Poly: 0x07 | Init: 0x00 | RefIn: false | RefOut: false | XorOut: 0x00
extern unsigned char	crc__CRC8U			(unsigned char crc8, unsigned char value);
extern unsigned char	crc__CRC8			(unsigned char const data[], unsigned long length);

// CRC-8/KOOP
// Check: 0xD8 | Poly: 0x4D | Init: 0xFF | RefIn: true | RefOut: true | XorOut: 0xFF
extern unsigned char	crc__CRC8KOOPU		(unsigned char crc8koop, unsigned char value);
extern unsigned char	crc__CRC8KOOP		(unsigned char const data[], unsigned long length);

// CRC16/ARC
// Check: 0xBB3D | Poly: 0x8005 | Init: 0x0000 | RefIn: true | RefOut: true | XorOut: 0x0000
extern unsigned short	crc__CRC16U			(unsigned short crc16, unsigned char value);
extern unsigned short	crc__CRC16			(unsigned char const data[], unsigned long length);

// CRC16/CCITT-FALSE
// Check: 0x29B1 | Poly: 0x1021 | Init: 0xFFFF | RefIn: false | RefOut: false | XorOut: 0x0000
extern unsigned short	crc__CRC16CCITTU	(unsigned short crc16ccitt, unsigned char value);
extern unsigned short	crc__CRC16CCITT		(unsigned char const data[], unsigned long length);

// CRC-32
// Check: 0xCBF43926 | Poly: 0x04C11DB7 | Init: 0xFFFFFFFF | RefIn: true | RefOut: true | XorOut: 0xFFFFFFFF
extern unsigned long	crc__CRC32U			(unsigned long crc32, unsigned char value);
extern unsigned long	crc__CRC32			(unsigned char const data[], unsigned long length);

#ifdef __cplusplus
}
#endif


#endif /* CRC_H_ */

/* EoF */
