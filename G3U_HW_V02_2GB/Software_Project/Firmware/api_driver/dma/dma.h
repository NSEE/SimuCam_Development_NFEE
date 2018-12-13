 /**
  * @file   dma.h
  * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
  * @date   Junho, 2017
  * @brief  Header File para testes e acesso ao módulo DMA
  *
  * Exemplo de utilização:
  *  
  *  
  *
  */

#ifndef __DMA_H__
#define __DMA_H__

/* includes */
#include "../../simucam_definitions.h"
#include "../../utils/util.h"


/* address */

/* defines */
#define DMA_WAIT TRUE
#define DMA_NO_WAIT FALSE
#define DMA_DEFAULT_WAIT_PERIOD 0

/* prototype */
bool DMA_OPEN_DEVICE(alt_msgdma_dev **DmaDevice, const char* DmaName);
bool DMA_CONFIG(alt_msgdma_dev *DmaDevice, alt_u32 ConfigMask);
bool DMA_BUSY(alt_msgdma_dev *DmaDevice);
bool DMA_DESCRIPTOR_BUFFER_FULL(alt_msgdma_dev *DmaDevice);
bool DMA_DESCRIPTOR_BUFFER_EMPTY(alt_msgdma_dev *DmaDevice);
bool DMA_DISPATCHER_STOP(alt_msgdma_dev *DmaDevice, bool bWait, alt_32 WaitPeriodUs);
bool DMA_DISPATCHER_RESET(alt_msgdma_dev *DmaDevice, bool bWait, alt_32 WaitPeriodUs);
bool DMA_SINGLE_TRANSFER(alt_msgdma_dev *DmaDevice, alt_u32 SourceAddress, alt_u32 DestinationAddress, alt_u32 TransferSize, alt_u32 ControlBits, bool bWait, alt_32 WaitPeriodUs);
bool DMA_MULTIPLE_TRANSFER(alt_msgdma_dev *DmaDevice, alt_u32 SourceAddressArray[], alt_u32 DestinationAddressArray[], alt_u8 TransferNumber, alt_u32 TransferSize, alt_u32 ControlBits, bool bWait, alt_32 WaitPeriodUs);
bool DMA_EXTENDED_SINGLE_TRANSFER(alt_msgdma_dev *DmaDevice, alt_u32 SourceAddressHigh, alt_u32 SourceAddressLow, alt_u32 DestinationAddressHigh, alt_u32 DestinationAddressLow, alt_u32 TransferSizeBytes, alt_u32 ControlBits, bool bWait, alt_32 WaitPeriodUs);

#endif /*__DMA_H__ */
