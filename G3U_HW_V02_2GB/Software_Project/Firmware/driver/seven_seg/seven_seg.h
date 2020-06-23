/**
 * @file   seven_seg.h
 * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
 * @date   Fevereiro, 2017
 * @brief  Header File para acesso ao modulo controlador de display de sete segmentos via Avalon
 *
 * Exemplo de utilização:
 *  SSDP_CONFIG(SSDP_NORMAL_MODE);
 *  SSDP_UPDATE(8BitVal);
 *
 */

#ifndef __SEVEN_SEG_H__
#define __SEVEN_SEG_H__

/* includes */
#include "../../simucam_definitions.h"

/* address */
#define SSDP_BASE                       SEVEN_SEGMENT_CONTROLLER_BASE
#define SSDP_CONTROL_REG_OFFSET         0
#define SSDP_DATA_REG_OFFSET            1

/* defines */
#define SSDP_NORMAL_MODE                0
#define SSDP_TEST_MODE                  1
#define SSDP_LOCK                       2
#define SSDP_UNLOCK                     3
#define SSDP_OFF                        4

#define SSDP_ON_MASK                    0x11
#define SSDP_TEST_MASK                  0x44
#define SSDP_UNLOCK_MASK                0x22
#define SSDP_OFF_MASK                   0x00

/* prototype */
extern alt_u8 SspdConfigControl;

bool bSSDisplayConfig(alt_u8 SsdpConfig);
bool bSSDisplayUpdate(alt_u8 SsdpData);

#endif /* SEVEN_SEG */
