#include "sense.h"

#if DEBUG_ON
char cDebugBuffer[256];
#endif

bool POWER_Read(alt_u32 szVol[POWER_PORT_NUM]) {
	bool bSuccess = TRUE;
	int i, c, nPortIndex = 0;
	int szPortNum[] = { POWER_DEVICE0_PORT_NUM, POWER_DEVICE1_PORT_NUM };
	alt_u32 Value32;
//	alt_u8 NextChannel, Channel, HEAD, SIGN, SGL, PARITY;
	alt_u8 NextChannel, Channel, HEAD, SIGN, SGL;
	const bool bEN = TRUE; // alwasy update next conversion channel
	const bool bSIGN = TRUE; // VolDrop = CH1-CH0
	const bool bSGL = FALSE; // GSGL=FALSE: Diff
	for (c = 0; c < POWER_DEVICE_NUM && bSuccess; c++) {
		NextChannel = 0;
		bSuccess = POWER_SPI_RW(c, NextChannel, bEN, bSIGN, bSGL, &szVol[0]); // set conversion channel: 0
		for (i = 0; i < szPortNum[c] && bSuccess; i++) {
			NextChannel = i + 1;
			bSuccess = POWER_SPI_RW(c, NextChannel, bEN, bSIGN, bSGL, &Value32);
			if (bSuccess) {
				HEAD = (Value32 >> 30) & 0x03;
				Channel = (Value32 >> 1) & 0x07;
				SIGN = (Value32 >> 4) & 0x01;
				SGL = (Value32 >> 5) & 0x01;
//				PARITY = Value32 & 0x01;
				if (HEAD != 0) {
#if DEBUG_ON
					sprintf(cDebugBuffer, "[%d]Unexpected HEAD\r\n", i);
					debug(fp, cDebugBuffer);
#endif
					bSuccess = FALSE;
				} else if (Channel != i) {
#if DEBUG_ON
					sprintf(cDebugBuffer,
							"[%d]Unexpected Channel. Expected:%d, Read:%d\r\n",
							i, i, Channel);
					debug(fp, cDebugBuffer);
#endif
					bSuccess = FALSE;
				} else if (SIGN ^ bSIGN) {
#if DEBUG_ON
					sprintf(cDebugBuffer, "[%d]Unexpected SIGN\r\n", i);
					debug(fp, cDebugBuffer);
#endif
					bSuccess = FALSE;
				} else if (SGL ^ SGL) {
#if DEBUG_ON
					sprintf(cDebugBuffer, "[%d]Unexpected SGL\r\n", i);
					debug(fp, cDebugBuffer);
#endif
					bSuccess = FALSE;
				}
				if (bSuccess)
					szVol[nPortIndex++] = Value32; //(Value32 >> 6) & 0xFFFFFF; // 24 bits
			} else {
#if DEBUG_ON
				sprintf(cDebugBuffer, "SPI Read Error\r\n");
				debug(fp, cDebugBuffer);
#endif
			}
		} // for i
	} // for c
	return bSuccess;
}

bool TEMP_Read(alt_8 *pFpgaTemp, alt_8 *pBoardTemp) {
	bool bSuccess;
	const alt_u8 DeviceAddr = 0x30;
	alt_8 FpgaTemp, BoardTemp;
	char Data;

	// read local temp
	bSuccess = I2C_Read(TEMP_SCL_BASE, TEMP_SDA_BASE, DeviceAddr, 0x00,
			(alt_u8 *) &Data);
	if (bSuccess)
		BoardTemp = Data;

	// read remote temp
	if (bSuccess) {
		bSuccess = I2C_Read(TEMP_SCL_BASE, TEMP_SDA_BASE, DeviceAddr, 0x01,
				(alt_u8 *) &Data);
		if (bSuccess)
			FpgaTemp = Data;
	}
	//
	if (bSuccess) {
		*pFpgaTemp = FpgaTemp;
		*pBoardTemp = BoardTemp;
	}

	return bSuccess;
}

bool sense_log_temp(alt_u8 *FpgaTemp, alt_u8 *BoardTemp) {
	bool bSuccess;

	// show temp
	bSuccess = TEMP_Read((alt_8*) FpgaTemp, (alt_8*) BoardTemp);

	return (bSuccess);
}

void sense_log(void) {
	bool bSuccess;
	int i;
	const float fRef = 5.0; // 5.0V
	float fVolDrop, fCurrent, fPower, fVol;
	alt_u32 szVol[POWER_PORT_NUM];
	alt_u32 SIG, MSB, RESULT;
	float szRes[] = { 0.003, 0.001, 0.003, 0.003, 0.003, 0.003, 0.003, 0.003,
			0.003, 0.003, 0.003, 0.003 };
	float szRefVol[] = { 0.9, 0.9, 3.0, 0.9, 1.8, 2.5, 1.8, 2.5, 1.1, 1.4, 3.3,
			2.5 };
	char szName[][64] = { "VCCD_PLL", "VCC0P9", "GPIO_VCCIOPD", "VCCHIP",
			"VCC1P8_34R", "HSMA_VCCIO", "VCC1P8_78R", "VCCA_PLL", "VCCL_GXB",
			"VCCH_GXB", "VCC3P3_HSMC", "HSMB_VCCIO", };

	// show power
	bSuccess = POWER_Read(szVol);
	if (bSuccess) {
		for (i = 0; i < POWER_PORT_NUM && bSuccess; i++) {
			SIG = (szVol[i] >> 29) & 0x01;
			MSB = (szVol[i] >> 28) & 0x01;
			RESULT = (szVol[i] >> 6) & 0x3FFFFF; // 22 bits
			if (MSB == 0)
				fVolDrop = (float) (RESULT) / (float) 0x400000;
			else
				fVolDrop = 0.0; //always be positive in schematic // -(float)(0x400000-RESULT)/(float)0x400000;
			if (SIG && MSB) {
				fVol = fRef * 0.5;
#if DEBUG_ON
				sprintf(cDebugBuffer, "[%s:%06XH,Over]\r\n  VolDrop:%f(V)\r\n",
						szName[i], (int) szVol[i], fVol);
				debug(fp, cDebugBuffer);
#endif
			} else if (SIG && !MSB) {
				fVol = fRef * 0.5 * fVolDrop;
				fCurrent = fVolDrop / szRes[i];
				fPower = szRefVol[i] * fCurrent;
#if DEBUG_ON
				sprintf(cDebugBuffer,
						"[%s:%06XH,Pos]\r\n  VolDrop:%f(V), Current:%f(A), Power:%f(W)\r\n",
						szName[i], (int) szVol[i], fVolDrop, fCurrent, fPower);
				debug(fp, cDebugBuffer);
#endif
			} else if (!SIG && MSB) {
				fVol = fRef * 0.5 * fVolDrop;
				fCurrent = fVolDrop / szRes[i];
				fPower = szRefVol[i] * fCurrent;
#if DEBUG_ON
				sprintf(cDebugBuffer,
						"[%s:%06XH,Neg]\r\n  VolDrop:%f(V), Current:%f(A), Power:%f(W)\r\n",
						szName[i], (int) szVol[i], fVolDrop, fCurrent, fPower);
				debug(fp, cDebugBuffer);
#endif
			} else if (!SIG && !MSB) {
				fVol = -fRef * 0.5;
#if DEBUG_ON
				sprintf(cDebugBuffer, "[%s:%06XH,Under]\r\n  VolDrop:%f(V)\r\n",
						szName[i], (int) szVol[i], fVol);
				debug(fp, cDebugBuffer);
#endif
			}
		}
#if DEBUG_ON
		sprintf(cDebugBuffer, "\r\n");
		debug(fp, cDebugBuffer);
#endif
	} else {
#if DEBUG_ON
		sprintf(cDebugBuffer, "Error\r\n");
		debug(fp, cDebugBuffer);
#endif
	}
}
