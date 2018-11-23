 /**
  * @file   dma.c
  * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
  * @date   Junho, 2017
  * @brief  Source File para testes e acesso ao módulo DMA
  *
  */

#include "dma.h"

/**
 * @name    DMA_OPEN_DEVICE
 * @brief
 * @ingroup DMA
 *
 * Localiza e abre o Device de DMA, baseado no nome
 *
 * @param [in] DmaDevice  Ponteiro para o pnteiro do Device do DMA a ser utilizado
 * @param [in] DmaName  String com o nome do DMA (XXX_CSR_NAME)
 *
 * @retval TRUE : Sucesso
 *
 */
bool DMA_OPEN_DEVICE(alt_msgdma_dev **DmaDevice, const char* DmaName){
  bool bSuccess = TRUE;
  
  //Open DMA based on name

  *DmaDevice = alt_msgdma_open((char *)DmaName);
  
  //Check if DMA opened correctly;
  if(*DmaDevice == NULL){
    bSuccess = FALSE;
  }
  
  return bSuccess;
}

/**
 * @name    DMA_CONFIG
 * @brief
 * @ingroup DMA
 *
 * Escreve no Registro de Controle (CSR_CONTROL), do DMA
 *
 * @param [in] DmaDevice  Ponteiro para o Device do DMA a ser utilizado
 * @param [in] ConfigMask  Mascara com as configurações do DMA (overwrite)
 *
 * @retval TRUE : Sucesso
 *
 */
bool DMA_CONFIG(alt_msgdma_dev *DmaDevice, alt_u32 ConfigMask){
  bool bSuccess = TRUE;
  IOWR_ALTERA_MSGDMA_CSR_CONTROL(DmaDevice->csr_base, ConfigMask);
  return bSuccess;
}

/**
 * @name    DMA_BUSY
 * @brief
 * @ingroup DMA
 *
 * Verifica se o DMA está executando alguma operação (ocupado);
 *
 * @param [in] DmaDevice  Ponteiro para o Device do DMA a ser utilizado
 *
 * @retval TRUE : DMA Ocupado
 *
 */
bool DMA_BUSY(alt_msgdma_dev *DmaDevice){
  bool bBusy = FALSE;
  if (IORD_ALTERA_MSGDMA_CSR_STATUS (DmaDevice->csr_base) & ALTERA_MSGDMA_CSR_BUSY_MASK){
    bBusy = TRUE;
  }
  return bBusy;
}

/**
 * @name    DMA_DESCRIPTOR_BUFFER_FULL
 * @brief
 * @ingroup DMA
 *
 * Verifica se o buffer (read/write) do Descriptor está cheio;
 *
 * @param [in] DmaDevice  Ponteiro para o Device do DMA a ser utilizado
 *
 * @retval TRUE : Buffer Cheio
 *
 */
bool DMA_DESCRIPTOR_BUFFER_FULL(alt_msgdma_dev *DmaDevice){
  bool bFull = FALSE;
  if (IORD_ALTERA_MSGDMA_CSR_STATUS (DmaDevice->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK){
    bFull = TRUE;
  }
  return bFull;
}

/**
 * @name    DMA_DESCRIPTOR_BUFFER_EMPTY
 * @brief
 * @ingroup DMA
 *
 * Verifica se o buffer (read/write) do Descriptor está vazio;
 *
 * @param [in] DmaDevice  Ponteiro para o Device do DMA a ser utilizado
 *
 * @retval TRUE : Buffer Vazio
 *
 */
bool DMA_DESCRIPTOR_BUFFER_EMPTY(alt_msgdma_dev *DmaDevice){
  bool bEmpty = FALSE;
  if (IORD_ALTERA_MSGDMA_CSR_STATUS (DmaDevice->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_EMPTY_MASK){
    bEmpty = TRUE;
  }
  return bEmpty;
}

/**
 * @name    DMA_DISPATCHER_STOP
 * @brief
 * @ingroup DMA
 *
 * Para o Dispatcher do DMA
 *
 * @param [in] DmaDevice  Ponteiro para o Device do DMA a ser utilizado
 * @param [in] bWait  Define se a função irá aguardar o final da transferencia antes de retornar
 * @param [in] WaitPeriodUs  Define em qual intervalo de tempo a função irá verificar se a transferencia foi concluida
 *
 * @retval TRUE : Sucesso
 *
 */
bool DMA_DISPATCHER_STOP(alt_msgdma_dev *DmaDevice, bool bWait, alt_32 WaitPeriodUs){
  bool bSuccess = TRUE;
  
  //Send stop command
  IOWR_ALTERA_MSGDMA_CSR_CONTROL(DmaDevice->csr_base, ALTERA_MSGDMA_CSR_STOP_MASK);
  
  if (bWait == DMA_WAIT) {
    //Wait stop to be finished
    while (IORD_ALTERA_MSGDMA_CSR_STATUS (DmaDevice->csr_base) & ALTERA_MSGDMA_CSR_STOP_STATE_MASK) {
      if (WaitPeriodUs == DMA_DEFAULT_WAIT_PERIOD){
        usleep(1);
      } else {
        usleep(WaitPeriodUs);
      }
    }
  } else {
    return bSuccess;
  }
  
  return bSuccess;
}

/**
 * @name    DMA_DISPATCHER_RESET
 * @brief
 * @ingroup DMA
 *
 * Reinicia o Dispatcher do DMA
 *
 * @param [in] DmaDevice  Ponteiro para o Device do DMA a ser utilizado
 * @param [in] bWait  Define se a função irá aguardar o final da transferencia antes de retornar
 * @param [in] WaitPeriodUs  Define em qual intervalo de tempo a função irá verificar se a transferencia foi concluida
 *
 * @retval TRUE : Sucesso
 *
 */
bool DMA_DISPATCHER_RESET(alt_msgdma_dev *DmaDevice, bool bWait, alt_32 WaitPeriodUs){
  bool bSuccess = TRUE;
  
  //Send reset command
  IOWR_ALTERA_MSGDMA_CSR_CONTROL(DmaDevice->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
  
  if (bWait == DMA_WAIT) {
    //Wait reset to be finished
    while (IORD_ALTERA_MSGDMA_CSR_STATUS (DmaDevice->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
      if (WaitPeriodUs == DMA_DEFAULT_WAIT_PERIOD){
        usleep(1);
      } else {
        usleep(WaitPeriodUs);
      }
    }
  } else {
    return bSuccess;
  }
  
  return bSuccess;
}

/**
 * @name    DMA_SINGLE_TRANSFER
 * @brief
 * @ingroup DMA
 *
 * Realiza o agendamento de uma transferências pelo DMA
 *
 * @param [in] DmaDevice  Ponteiro para o Device do DMA a ser utilizado
 * @param [in] SourceAddress Endereço de início
 * @param [in] DestinationAddress  Endereço de destino
 * @param [in] TransferSize  Quantidade de dados a ser transferida (em bytes)
 * @param [in] ControlBits  Bits de controle do DMA
 * @param [in] bWait  Define se a função irá aguardar o final da transferencia antes de retornar
 * @param [in] WaitPeriodUs  Define em qual intervalo de tempo a função irá verificar se a transferencia foi concluida
 *
 * @retval TRUE : Sucesso
 *
 */
bool DMA_SINGLE_TRANSFER(alt_msgdma_dev *DmaDevice, alt_u32 SourceAddress, alt_u32 DestinationAddress, alt_u32 TransferSize, alt_u32 ControlBits, bool bWait, alt_32 WaitPeriodUs){
  bool bSuccess = TRUE;
  alt_msgdma_standard_descriptor DmaDescriptor;

  if (alt_msgdma_construct_standard_mm_to_mm_descriptor(DmaDevice, &DmaDescriptor, (alt_u32 *)SourceAddress, (alt_u32 *)DestinationAddress, TransferSize, ControlBits) != 0){
    bSuccess = FALSE;
    return bSuccess;
  } else {
    if (alt_msgdma_standard_descriptor_async_transfer(DmaDevice, &DmaDescriptor) != 0) {
      bSuccess = FALSE;
      return bSuccess;
    }
  }
  
  if ((bSuccess == TRUE) & (bWait == DMA_WAIT)) {
    while (IORD_ALTERA_MSGDMA_CSR_STATUS (DmaDevice->csr_base) & ALTERA_MSGDMA_CSR_BUSY_MASK) {
      if (WaitPeriodUs == DMA_DEFAULT_WAIT_PERIOD){
        usleep(1000);
      } else {
        usleep(WaitPeriodUs);
      }
    }
  }
  
  return bSuccess;
}

/**
 * @name    DMA_MULTIPLE_TRANSFER
 * @brief
 * @ingroup DMA
 *
 * Realiza o agendamento de múltiplas transferências pelo DMA
 *
 * @param [in] DmaDevice  Ponteiro para o Device do DMA a ser utilizado
 * @param [in] SourceAddressArray  Vetor com os endereços de início
 * @param [in] DestinationAddressArray  Vetor com os endereços de destino
 * @param [in] TransferNumber  Quantidade de transferencias a ser agendada
 * @param [in] TransferSize  Quantidade de dados a ser transferida (em bytes)
 * @param [in] ControlBits  Bits de controle do DMA
 * @param [in] bWait  Define se a função irá aguardar o final da transferencia antes de retornar
 * @param [in] WaitPeriodUs  Define em qual intervalo de tempo a função irá verificar se a transferencia foi concluida
 *
 * @retval TRUE : Sucesso
 *
 */
bool DMA_MULTIPLE_TRANSFER(alt_msgdma_dev *DmaDevice, alt_u32 SourceAddressArray[], alt_u32 DestinationAddressArray[], alt_u8 TransferNumber, alt_u32 TransferSize, alt_u32 ControlBits, bool bWait, alt_32 WaitPeriodUs){
  bool bSuccess = TRUE;
  alt_msgdma_standard_descriptor DmaDescriptor;
  alt_u8 i = 0;

  while ((bSuccess == TRUE) & (i < (TransferNumber - 1))){
    if (alt_msgdma_construct_standard_mm_to_mm_descriptor(DmaDevice, &DmaDescriptor, (alt_u32 *)SourceAddressArray[i], (alt_u32 *)DestinationAddressArray[i], TransferSize, (ControlBits | ALTERA_MSGDMA_DESCRIPTOR_CONTROL_EARLY_DONE_ENABLE_MASK)) != 0){
      bSuccess = FALSE;
    } else {
      if (alt_msgdma_standard_descriptor_async_transfer(DmaDevice, &DmaDescriptor) != 0) {
        bSuccess = FALSE;
      }
    }
	i++;
  }
  if (bSuccess == TRUE){
    if (alt_msgdma_construct_standard_mm_to_mm_descriptor(DmaDevice, &DmaDescriptor, (alt_u32 *)SourceAddressArray[i], (alt_u32 *)DestinationAddressArray[i], TransferSize, ControlBits) != 0){
      bSuccess = FALSE;
    } else {
      if (alt_msgdma_standard_descriptor_async_transfer(DmaDevice, &DmaDescriptor) != 0) {
        bSuccess = FALSE;
      }
    }
  }

  if ((bSuccess == TRUE) & (bWait == DMA_WAIT)) {
    while (IORD_ALTERA_MSGDMA_CSR_STATUS (DmaDevice->csr_base) & ALTERA_MSGDMA_CSR_BUSY_MASK) {
      if (WaitPeriodUs == DMA_DEFAULT_WAIT_PERIOD){
    	usleep(1000);
      } else {
    	usleep(WaitPeriodUs);
      }
    }
  }
  
  return bSuccess;
}

//bool DMA_EXTENDED_SINGLE_TRANSFER(alt_msgdma_dev *DmaDevice, alt_u32 SourceAddressHigh, alt_u32 SourceAddressLow, alt_u32 DestinationAddressHigh, alt_u32 DestinationAddressLow, alt_u32 TransferSizeBytes, alt_u32 ControlBits, bool bWait, alt_32 WaitPeriodUs){
//  bool bSuccess = TRUE;
//  alt_msgdma_extended_descriptor DmaExtendedDescriptor;
//
//
//  if (alt_msgdma_construct_extended_mm_to_mm_descriptor (DmaDevice,
//  		                                                 &DmaExtendedDescriptor,
//  		                                                 (alt_u32 *)SourceAddressLow,
//  		                                                 (alt_u32 *)DestinationAddressLow,
//  		                                                 TransferSizeBytes,
//  		                                                 0,
//  		                                                 0,
//  		                                                 0,
//  		                                                 1,
//  		                                                 0,
//  		                                                 (alt_u32 *)SourceAddressHigh,
//  		                                                 (alt_u32 *)DestinationAddressHigh,
//  		                                                 ControlBits) != 0){
//	bSuccess = FALSE;
//	return bSuccess;
//  } else {
//	if (alt_msgdma_extended_descriptor_async_transfer(DmaDevice, &DmaExtendedDescriptor) != 0) {
//	  bSuccess = FALSE;
//	  return bSuccess;
//	}
//  }
//
//  if ((bSuccess == TRUE) & (bWait == DMA_WAIT)) {
//	while (IORD_ALTERA_MSGDMA_CSR_STATUS (DmaDevice->csr_base) & ALTERA_MSGDMA_CSR_BUSY_MASK) {
//	  if (WaitPeriodUs == DMA_DEFAULT_WAIT_PERIOD){
//		usleep(1000);
//	  } else {
//		usleep(WaitPeriodUs);
//	  }
//	}
//  }
//
//  return bSuccess;
//}
