#ifndef __SENSE_H__
#define __SENSE_H__

#include "../../driver/power_spi/power_spi.h"
#include "../../driver/i2c/i2c.h"

bool POWER_Read(alt_u32 szVol[POWER_PORT_NUM]);
bool TEMP_Read(alt_8 *pFpgaTemp, alt_8 *pBoardTemp);
void sense_log(void);
bool sense_log_temp(alt_u8 *FpgaTemp, alt_u8 *BoardTemp);

#endif /*__SENSE.H__*/
