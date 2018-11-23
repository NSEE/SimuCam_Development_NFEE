  /**
  * @file   ftdi.h
  * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
  * @date   Junho, 2017
  * @brief  Header File para acesso ao módulo FTDI UMFT601A via Avalon
  *
  * Exemplo de utilização:
  *
  */
 
#ifndef FTDI_H_
#define FTDI_H_

/* includes */
#include "../../utils/meb_includes.h"
#include "../../utils/util.h"
#include "system.h"

/* address */
#define FTDI_BASE FTDI_0_BASE
#define FTDI_DATA_REG_OFFSET 0
#define FTDI_BE_REG_OFFSET 1
#define FTDI_TXE_N_REG_OFFSET 2
#define FTDI_RXF_N_REG_OFFSET 3
#define FTDI_SIWU_N_REG_OFFSET 4
#define FTDI_WR_N_REG_OFFSET 5
#define FTDI_RD_N_REG_OFFSET 6
#define FTDI_OE_N_REG_OFFSET 7
#define FTDI_RESET_N_REG_OFFSET 8
#define FTDI_WAKEUP_N_REG_OFFSET 9
#define FTDI_GPIO_REG_OFFSET 10
#define FTDI_OE_REG_ADDRESS_OFFSET 11
#define FTDI_DATA_OE_MASK_REG_OFFSET 12
#define FTDI_BE_OE_MASK_REG_OFFSET 13
#define FTDI_WAKEUP_OE_MASK_REG_OFFSET 14
#define FTDI_GPIO_OE_MASK_REG_OFFSET 15

/* defines */

/* prototype */
bool FTDI_WRITE_REG(alt_u8 RegisterOffset, alt_u32 RegisterValue);
alt_u32 FTDI_READ_REG(alt_u8 RegisterOffset);

#endif /* FTDI_H_ */
