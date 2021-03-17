/*
 * memory_filler.c
 *
 *  Created on: 16 de mar de 2021
 *      Author: rfranca
 */

#include "memory_filler.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

ALT_INLINE bool ALT_ALWAYS_INLINE bMfilGetWrBusy(void) {
	volatile TMfilModule *vpxTfilModule = (TMfilModule *) (MFIL_MODULE_BASE_ADDR);
	return (vpxTfilModule->xMfilDataStatus.bWrBusy);
}

ALT_INLINE bool ALT_ALWAYS_INLINE bMfilGetWrTimeoutErr(void) {
	volatile TMfilModule *vpxTfilModule = (TMfilModule *) (MFIL_MODULE_BASE_ADDR);
	return (vpxTfilModule->xMfilDataStatus.bWrTimeoutErr);
}

bool bMfilSetWrData(const alt_u32 culiWriteData[8]) {
	bool bStatus = FALSE;

	volatile TMfilModule *vpxTfilModule = (TMfilModule *) (MFIL_MODULE_BASE_ADDR);

	vpxTfilModule->xMfilDataControl.uliWrData_ValDword7 = culiWriteData[7];
	vpxTfilModule->xMfilDataControl.uliWrData_ValDword6 = culiWriteData[6];
	vpxTfilModule->xMfilDataControl.uliWrData_ValDword5 = culiWriteData[5];
	vpxTfilModule->xMfilDataControl.uliWrData_ValDword4 = culiWriteData[4];
	vpxTfilModule->xMfilDataControl.uliWrData_ValDword3 = culiWriteData[3];
	vpxTfilModule->xMfilDataControl.uliWrData_ValDword2 = culiWriteData[2];
	vpxTfilModule->xMfilDataControl.uliWrData_ValDword1 = culiWriteData[1];
	vpxTfilModule->xMfilDataControl.uliWrData_ValDword0 = culiWriteData[0];

	bStatus = TRUE;

	return (bStatus);
}

bool bMfilResetDma(bool bWait) {
	bool bStatus = FALSE;

	volatile TMfilModule *vpxTfilModule = (TMfilModule *) (MFIL_MODULE_BASE_ADDR);

	vpxTfilModule->xMfilDataControl.bWrReset = TRUE;
	if (bWait) {
		// wait for the avm controller to be free
		while (vpxTfilModule->xMfilDataStatus.bWrBusy) {
			alt_busy_sleep(1); /* delay 1us */
		}
	}
	bStatus = TRUE;

	return (bStatus);
}

bool bMfilDmaTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes) {
	bool bStatus = FALSE;

	volatile TMfilModule *vpxTfilModule = (TMfilModule *) (MFIL_MODULE_BASE_ADDR);

	union Ddr2MemoryAddress unMemoryAddress;

	bool bMemoryFlag = FALSE;
	bool bAddressFlag = FALSE;
	bool bNotBusyFlag = FALSE;
	bool bTransferSizeFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucDdrMemId) {
	case eDdr2Memory1:
		unMemoryAddress.ulliMemAddr64b = DDR2_M1_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	case eDdr2Memory2:
		unMemoryAddress.ulliMemAddr64b = DDR2_M2_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	default:
		bMemoryFlag = FALSE;
		break;
	}

	/* Verify if the base address is a multiple o MFIL_DATA_ACCESS_WIDTH_BYTES (DSCH_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
	if (unMemoryAddress.ulliMemAddr64b % MFIL_DATA_ACCESS_WIDTH_BYTES) {
		/* Address is not a multiple of MFIL_DATA_ACCESS_WIDTH_BYTES */
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	bNotBusyFlag = !(vpxTfilModule->xMfilDataStatus.bWrBusy);

	if ((MFIL_TRANSFER_MIN_BYTES <= uliTransferSizeInBytes) && (MFIL_TRANSFER_MAX_BYTES >= uliTransferSizeInBytes)) {
		bTransferSizeFlag = TRUE;
		/* Rounding up the size to the nearest multiple of MFIL_DATA_ACCESS_WIDTH_BYTES (MFIL_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
		if (uliTransferSizeInBytes % MFIL_DATA_ACCESS_WIDTH_BYTES) {
			/* Transfer size is not a multiple of MFIL_DATA_ACCESS_WIDTH_BYTES */
			uliRoundedTransferSizeInBytes = (alt_u32) ((uliTransferSizeInBytes & MFIL_DATA_TRANSFER_SIZE_MASK ) + MFIL_DATA_ACCESS_WIDTH_BYTES );
		} else {
			uliRoundedTransferSizeInBytes = uliTransferSizeInBytes;
		}
	}

	if ((bMemoryFlag) && (bAddressFlag) && (bNotBusyFlag) && (bTransferSizeFlag)) {

		// reset the avm controller
		bMfilResetDma(TRUE);

		// start new transfer
		vpxTfilModule->xMfilDataControl.uliWrInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
		vpxTfilModule->xMfilDataControl.uliWrInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
		/* HW use zero as reference for transfer size, need to decrement one word from the total transfer size */
		vpxTfilModule->xMfilDataControl.uliWrDataLenghtBytes = uliRoundedTransferSizeInBytes - MFIL_DATA_ACCESS_WIDTH_BYTES;
		vpxTfilModule->xMfilDataControl.usiWrTimeout = MFIL_WRITE_TIMEOUT;
		vpxTfilModule->xMfilDataControl.bWrStart = TRUE;
		bStatus = TRUE;

	}

	return (bStatus);
}

//! [public functions]

//! [private functions]
//! [private functions]
