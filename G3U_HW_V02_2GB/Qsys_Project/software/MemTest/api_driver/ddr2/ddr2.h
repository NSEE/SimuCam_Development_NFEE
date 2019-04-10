/**
 * @file   ddr2.h
 * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
 * @date   Maio, 2017
 * @brief  Header File para testes e acesso as memórias DDR2 da DE4
 *
 * Exemplo de utilização:
 *
 *
 *
 */

#ifndef DDR2_H_
#define DDR2_H_

#include <altera_up_sd_card_avalon_interface.h>
#include <altera_msgdma.h>
#include <altera_avalon_pio_regs.h>
#include <errno.h>
#include "system.h"
#include <stdio.h>
#include <sys/alt_stdio.h>
#include <unistd.h>  // usleep (unix standard?)
#include <sys/alt_flash.h>
#include <sys/alt_flash_types.h>
#include <sys/alt_alarm.h> // time tick function (alt_nticks(), alt_ticks_per_second())
#include <sys/alt_timestamp.h>
#include <sys/alt_irq.h>  // interrupt
#include <priv/alt_legacy_irq.h>
#include <priv/alt_busy_sleep.h>

#ifndef bool
	//typedef short int bool;
	//typedef enum e_bool { false = 0, true = 1 } bool;
	//#define false   0
	//#define true    1
	#define FALSE   0
	#define TRUE    1
#endif

/* includes */
#include "../../driver/i2c/i2c.h"

/* address */
#define DDR2_EXT_ADDR_WINDOWED_BASE     DDR2_ADDRESS_SPAN_EXTENDER_WINDOWED_SLAVE_BASE
#define DDR2_EXT_ADDR_CONTROL_BASE      DDR2_ADDRESS_SPAN_EXTENDER_CNTL_BASE
#define DDR2_M1_MEMORY_BASE             0x00000000
#define DDR2_M1_EEPROM_I2C_SCL_BASE     M1_DDR2_I2C_SCL_BASE
#define DDR2_M1_EEPROM_I2C_SDA_BASE     M1_DDR2_I2C_SDA_BASE
#define DDR2_M2_MEMORY_BASE             0x80000000
#define DDR2_M2_EEPROM_I2C_SCL_BASE     M2_DDR2_I2C_SCL_BASE
#define DDR2_M2_EEPROM_I2C_SDA_BASE     M2_DDR2_I2C_SDA_BASE

/* defines */
#define DDR2_EXT_ADDR_WINDOWED_SPAN     (2 ^ DDR2_ADDRESS_SPAN_EXTENDER_WINDOWED_SLAVE_SLAVE_ADDRESS_WIDTH)
#define DDR2_EXT_ADDR_WINDOWED_MASK     (DDR2_EXT_ADDR_WINDOWED_SPAN - 1)
#define DDR2_M1_MEMORY_WINDOWED_OFFSET  0x00000000
#define DDR2_M1_ID                      0x00
#define DDR2_M1_MEMORY_SIZE             2147483648
#define DDR2_M2_MEMORY_WINDOWED_OFFSET  0x80000000
#define DDR2_M2_ID                      0x01
#define DDR2_M2_MEMORY_SIZE             2147483648
#define DDR2_EEPROM_I2C_ADDRESS         0xA0
#define DDR2_VERBOSE                    TRUE
#define DDR2_NO_VERBOSE                 FALSE
#define DDR2_TIME                       TRUE
#define DDR2_NO_TIME                    FALSE

/* prototype */
bool bDdr2EepromTest(alt_u8 ucMemoryId);
bool bDdr2EepromDump(alt_u8 ucMemoryId);
//bool bDdr2SwitchMemory(alt_u8 ucMemoryId);
//bool bDdr2MemoryWriteTest(alt_u8 ucMemoryId);
//bool bDdr2MemoryReadTest(alt_u8 ucMemoryId);
//bool bDdr2MemoryRandomWriteTest(alt_u8 ucMemoryId, bool bVerbose, bool bTime);
//bool bDdr2MemoryRandomReadTest(alt_u8 ucMemoryId, bool bVerbose, bool bTime);

#endif /* DDR2_H_ */
