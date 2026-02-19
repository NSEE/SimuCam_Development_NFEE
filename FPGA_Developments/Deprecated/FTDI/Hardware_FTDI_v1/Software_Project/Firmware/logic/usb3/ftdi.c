  /**
  * @file   ftdi.c
  * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
  * @date   Junho, 2017
  * @brief  Source File para acesso ao módulo FTDI UMFT601A via Avalon
  *
  */

#include "ftdi.h"
  
/**
 * @name    FTDI_WRITE_REG
 * @brief
 * @ingroup FTDI
 *
 * Escreve em um dos registradores do componente FTDI (escreve nos pinos do módulo FTDI UMFT601A)
 *
 * @param [in] RegisterOffset Offset do registrator do componente FTDI
 * @param [in] RegisterValue Valor a ser colocado no registrador definido por RegisterOffset
 *
 * @retval TRUE : Sucesso
 *
 */
bool FTDI_WRITE_REG(alt_u8 RegisterOffset, alt_u32 RegisterValue){

	alt_u8 bSuccess = TRUE;
	alt_u32 *pFtdiAddr = FTDI_BASE;
	
	if ((RegisterOffset <= 1) || (RegisterOffset >= 4)){
		*(pFtdiAddr + (alt_u32)RegisterOffset) = (alt_u32) RegisterValue;
	} else {
		bSuccess = FALSE;
	}

	return bSuccess;
}

/**
 * @name    FTDI_READ_REG
 * @brief
 * @ingroup FTDI
 *
 * Lê o valor de um dos registradores do componente FTDI (lê o valor dos pinos do módulo FTDI UMFT601A)
 *
 * @param [in] RegisterOffset Offset do registrator do componente FTDI
 *
 * @retval Valor do registrador definido por RegisterOffset
 *
 */
alt_u32 FTDI_READ_REG(alt_u8 RegisterOffset){

	alt_u32 *pFtdiAddr = FTDI_BASE;
	alt_u32 RegisterValue = 0;
	
	if (RegisterOffset <= 11){
		RegisterValue = *(pFtdiAddr + (alt_u32)RegisterOffset);
	}
	
	return RegisterValue;
}
