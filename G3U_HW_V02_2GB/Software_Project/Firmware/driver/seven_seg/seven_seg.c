/**
 * @file   seven_seg.c
 * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
 * @date   Fevereiro, 2017
 * @brief  Source File para acesso ao modulo controlador de display de sete segmentos via Avalon
 *
 */

#include "seven_seg.h"

alt_u8 SspdConfigControl = 0x00;

/**
 * @name    SSDP_CONFIG
 * @brief
 * @ingroup SSDP
 *
 * Configura o Controlador de diplays de sete segmentos (Normal/Test, Lock/Unlock, Off)
 *   Normal: Exibe o valor enviado pelo SSDP_UPDATE;
 *   Test: Acende todo o display;
 *   Lock: Trava a atualização do display (continua podendo receber novos dados);
 *   Unlock: Destrava a atualização do display;
 *   Off: Desliga o display (desconfigura o Lock/Unlock);
 *
 * @param [in] SsdpConfig Configurações do display (SSDP_NORMAL_MODE, SSDP_TEST_MODE, SSDP_LOCK, SSDP_UNLOCK, SSDP_OFF)
 *
 * @retval TRUE : Sucesso
 * @retval FALSE : Configuração não especificada
 *
 */
bool bSSDisplayConfig(alt_u8 SsdpConfig) {

	switch (SsdpConfig) {
	case SSDP_NORMAL_MODE:
		SspdConfigControl = (SSDP_ON_MASK | SSDP_UNLOCK_MASK);
		break;

	case SSDP_TEST_MODE:
		SspdConfigControl = (SSDP_ON_MASK | SSDP_TEST_MASK);
		break;

	case SSDP_LOCK:
		SspdConfigControl &= (~SSDP_UNLOCK_MASK);
		break;

	case SSDP_UNLOCK:
		SspdConfigControl |= SSDP_UNLOCK_MASK;
		break;

	case SSDP_OFF:
		SspdConfigControl = SSDP_OFF_MASK;
		break;

	default:
		return FALSE;
	}

	alt_u32 *pSsdpAddr = (alt_u32 *) SSDP_BASE;
	*(pSsdpAddr + SSDP_CONTROL_REG_OFFSET) = (alt_u32) SspdConfigControl;

	return TRUE;
}

/**
 * @name    SSDP_UPDATE
 * @brief
 * @ingroup SSDP
 *
 * Configura dados no controlador de diplays de sete segmentos (apenas últimos dois digitos)
 *
 * @param [in] SsdpData Dado a ser colocado no display de sete segmentos, do tipo unsigned char (alt_u8)
 *
 * @retval TRUE : Sucesso
 *
 */
bool bSSDisplayUpdate(alt_u8 SsdpData) {

	alt_u32 *pSsdpAddr = (alt_u32 *) SSDP_BASE;
	*(pSsdpAddr + SSDP_DATA_REG_OFFSET) = (alt_u32) SsdpData;

	return TRUE;
}

