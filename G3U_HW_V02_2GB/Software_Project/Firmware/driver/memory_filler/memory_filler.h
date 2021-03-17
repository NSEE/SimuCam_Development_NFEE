/*
 * memory_filler.h
 *
 *  Created on: 16 de mar de 2021
 *      Author: rfranca
 */

#ifndef DRIVER_MEMORY_FILLER_MEMORY_FILLER_H_
#define DRIVER_MEMORY_FILLER_MEMORY_FILLER_H_

#include "../../simucam_definitions.h"
#include "../../api_driver/ddr2/ddr2.h"

//! [constants definition]
#define MFIL_MODULE_BASE_ADDR            MEMORY_FILLER_BASE

#define MFIL_TRANSFER_MIN_BYTES          (alt_u32)32
#define MFIL_TRANSFER_MAX_BYTES          (alt_u32)2147483648
#define MFIL_DATA_ACCESS_WIDTH_BYTES     (alt_u32)32
#define MFIL_DATA_TRANSFER_SIZE_MASK     (alt_u32)0xFFFFFFE0

/* Timeout scale is 0.5 ms. Timeout = 20000 = 10s */
#define MFIL_WRITE_TIMEOUT               20000

//! [constants definition]

//! [public module structs definition]

/* MFIL Data Control Register Struct */
typedef struct MfilDataControl {
	alt_u32 uliWrInitAddrHighDword; /* Initial Write Address [High Dword] */
	alt_u32 uliWrInitAddrLowDword; /* Initial Write Address [Low Dword] */
	alt_u32 uliWrDataLenghtBytes; /* Write Data Length [Bytes] */
	alt_u32 uliWrData_ValDword7; /* Write Data Value [Dword 7] */
	alt_u32 uliWrData_ValDword6; /* Write Data Value [Dword 6] */
	alt_u32 uliWrData_ValDword5; /* Write Data Value [Dword 5] */
	alt_u32 uliWrData_ValDword4; /* Write Data Value [Dword 4] */
	alt_u32 uliWrData_ValDword3; /* Write Data Value [Dword 3] */
	alt_u32 uliWrData_ValDword2; /* Write Data Value [Dword 2] */
	alt_u32 uliWrData_ValDword1; /* Write Data Value [Dword 1] */
	alt_u32 uliWrData_ValDword0; /* Write Data Value [Dword 0] */
	alt_u32 usiWrTimeout; /* Write Timeout */
	bool bWrStart; /* Data Write Start */
	bool bWrReset; /* Data Write Reset */
} TMfilDataControl;

/* MFIL Data Status Register Struct */
typedef struct MfilDataStatus {
	bool bWrBusy; /* Data Write Busy */
	bool bWrTimeoutErr; /* Write Timeout Error */
} TMfilDataStatus;

/* General Struct for Registers Access */
typedef struct MfilModule {
	TMfilDataControl xMfilDataControl;
	TMfilDataStatus xMfilDataStatus;
} TMfilModule;

//! [public module structs definition]

//! [public function prototypes]

bool bMfilGetWrBusy(void);
bool bMfilGetWrTimeoutErr(void);

bool bMfilSetWrData(const alt_u32 culiWriteData[8]);

bool bMfilResetDma(bool bWait);
bool bMfilDmaTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DRIVER_MEMORY_FILLER_MEMORY_FILLER_H_ */
