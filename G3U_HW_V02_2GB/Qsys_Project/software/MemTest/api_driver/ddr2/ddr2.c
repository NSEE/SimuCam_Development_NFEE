/**
 * @file   ddr2.c
 * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
 * @date   Maio, 2017
 * @brief  Source File para testes e acesso as memórias DDR2 da DE4
 *
 */

#include "ddr2.h"

typedef alt_u32 TMyData;

TMyData xSZData[256];

alt_u32 uliInitialState;
alt_u32 uliXorshift32(alt_u32 *puliState);

char cDebugBuffer[256];

/**
 * @name    bDdr2EepromTest
 * @brief
 * @ingroup DDR2
 *
 * Realiza teste de leitura e escrita da EEPROM da memória escolhida.
 *
 * @param [in] MemoryId  ID da mémoria a ser testada
 *
 * @retval TRUE : Sucesso
 *
 */
bool bDdr2EepromTest(alt_u8 ucMemoryId) {

	printf("===== DE4 DDR2 EEPROM Test =====\n");

	const alt_u8 cucDeviceAddr = DDR2_EEPROM_I2C_ADDRESS;
	bool bSuccess = FALSE;
	alt_u32 uliI2cSclBase;
	alt_u32 uliI2cSdaBase;
	int iI;

	switch (ucMemoryId) {
	case DDR2_M1_ID:
		uliI2cSclBase = DDR2_M1_EEPROM_I2C_SCL_BASE;
		uliI2cSdaBase = DDR2_M1_EEPROM_I2C_SDA_BASE;
		bSuccess = TRUE;
		break;
	case DDR2_M2_ID:
		uliI2cSclBase = DDR2_M2_EEPROM_I2C_SCL_BASE;
		uliI2cSdaBase = DDR2_M2_EEPROM_I2C_SDA_BASE;
		bSuccess = TRUE;
		break;
	default:
		bSuccess = FALSE;

		printf("DR2 Memory ID not identified!! Aborting Test \n");

		return bSuccess;
	}

	alt_u8 ucControlAddr, ucValue;

	printf("DDR2 EEPROM Read Test\n");

	usleep(20 * 1000);
	for (iI = 0; iI < 256 && bSuccess; iI++) {
		ucControlAddr = iI;
		bSuccess = I2C_Read(uliI2cSclBase, uliI2cSdaBase, cucDeviceAddr,
				ucControlAddr, &ucValue);
		if (bSuccess) {

			printf("EEPROM[%03d]=%02Xh\n", ucControlAddr, ucValue);

		} else {

			printf("Failed to read EEPROM\n");

		}
	}
	if (bSuccess) {

		printf("DDR2 EEPROM Read Test Completed\n\n");

	} else {

		printf("DDR2 EEPROM Read Test Failed\n\n");

	}

	printf("DDR2 EEPROM Write Test\n");

	alt_u8 ucWriteData = 0x12, ucTestAddr = 128;
	alt_u8 ucReadData;
	usleep(20 * 1000);
	bSuccess = I2C_Write(uliI2cSclBase, uliI2cSdaBase, cucDeviceAddr,
			ucTestAddr, ucWriteData);
	if (!bSuccess) {

		printf("Failed to write EEPROM\n");

	} else {
		bSuccess = I2C_Read(uliI2cSclBase, uliI2cSdaBase, cucDeviceAddr,
				ucTestAddr, &ucReadData);
		if (!bSuccess) {

			printf("Failed to read EEPROM for verify\n");

		} else {
			if (ucReadData != ucWriteData) {
				bSuccess = FALSE;

				printf(
						"Verify EEPROM write fail, ReadData=%02Xh, WriteData=%02Xh\n",
						ucReadData, ucWriteData);

			}
		}
	}
	if (bSuccess) {

		printf("DDR2 EEPROM Write Test Completed\n\n");

	} else {

		printf("DDR2 EEPROM Write Test Failed\n\n");

	}

	printf("\n");

	return bSuccess;
}

/**
 * @name    bDdr2EepromDump
 * @brief
 * @ingroup DDR2
 *
 * Realiza o dump das informações da EEPROM da memória escolhida, com os nomes das informações.
 *
 * @param [in] MemoryId  ID da mémoria a ser testada
 *
 * @retval TRUE : Sucesso
 *
 */
bool bDdr2EepromDump(alt_u8 ucMemoryId) {

	printf("===== DE4 DDR2 EEPROM Dump =====\n");

	const alt_u8 cucDeviceAddr = DDR2_EEPROM_I2C_ADDRESS;
	bool bSuccess = FALSE;
	alt_u32 uliI2cSclBase;
	alt_u32 uliI2cSdaBase;
	int iByteCounter;

	switch (ucMemoryId) {
	case DDR2_M1_ID:
		uliI2cSclBase = DDR2_M1_EEPROM_I2C_SCL_BASE;
		uliI2cSdaBase = DDR2_M1_EEPROM_I2C_SDA_BASE;
		bSuccess = TRUE;
		break;
	case DDR2_M2_ID:
		uliI2cSclBase = DDR2_M2_EEPROM_I2C_SCL_BASE;
		uliI2cSdaBase = DDR2_M2_EEPROM_I2C_SDA_BASE;
		bSuccess = TRUE;
		break;
	default:
		bSuccess = FALSE;

		printf("DR2 Memory ID not identified!! Aborting Dump \n");

		return bSuccess;
	}

	alt_u8 ucEepromData[256];
	bSuccess = I2C_MultipleRead(uliI2cSclBase, uliI2cSdaBase, cucDeviceAddr,
			ucEepromData, sizeof(ucEepromData));
	if (bSuccess) {

		printf(
				"\n For more information, check the Annex J: Serial Presence Detects for DDR2 SDRAM (Revision 1.3), of the JEDEC Standard No. 21-C \n\n");

		for (iByteCounter = 0; iByteCounter < 256 && bSuccess; iByteCounter++) {

//			printf("DDR2 EEPROM[%03d] = %02Xh ", iByteCounter, ucEepromData[iByteCounter]);

			if (iByteCounter == 0) {

				printf(
						"Byte 0: Number of Bytes Utilized by Module Manufacturer [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%u", ucEepromData[iByteCounter]);
				}
				printf("\n");

			} else if (iByteCounter == 1) {

				printf(
						"Byte 1: Total Number of Bytes in Serial PD Device [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else if (0x0E >= ucEepromData[iByteCounter]) {
					printf("%u Bytes",
							(alt_u16) (0x0001 << ucEepromData[iByteCounter]));
				} else {
					printf("-");
				}
				printf("\n");

			} else if (iByteCounter == 2) {

				printf("Byte 2: Memory Type [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter]) {
				case 0x00:
					printf("Reserved");
					break;
				case 0x01:
					printf("Standard FPM DRAM");
					break;
				case 0x02:
					printf("EDO");
					break;
				case 0x03:
					printf("Pipelined Nibble");
					break;
				case 0x04:
					printf("SDRAM");
					break;
				case 0x05:
					printf("ROM");
					break;
				case 0x06:
					printf("DDR SGRAM");
					break;
				case 0x07:
					printf("DDR SDRAM");
					break;
				case 0x08:
					printf("DDR2 SDRAM");
					break;
				default:
					printf("TBD");
					break;
				}
				printf("\n");

			} else if (iByteCounter == 3) {

				printf("Byte 3: Number of Row Addresses [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else if (0x0F >= ucEepromData[iByteCounter]) {
					printf("%u", ucEepromData[iByteCounter]);
				} else {
					printf("Undefined");
				}
				printf("\n");

			} else if (iByteCounter == 4) {

				printf("Byte 4: Number of Column Addresses [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else if (0x1F >= ucEepromData[iByteCounter]) {
					printf("%u", ucEepromData[iByteCounter]);
				} else {
					printf("Undefined");
				}
				printf("\n");

			} else if (iByteCounter == 5) {

				printf(
						"Byte 5: Module Attributes - Number of Ranks, Package and Height [0x%02Xh] : ",
						ucEepromData[iByteCounter]);

				printf("\n  -- Module Height : ");
				switch (ucEepromData[iByteCounter] & 0xE0) {
				case 0x00:
					printf("less than 25.4 mm");
					break;
				case 0x20:
					printf("25.4 mm");
					break;
				case 0x40:
					printf("greater than 25.4 mm and less than 30 mm");
					break;
				case 0x60:
					printf("30.0 mm");
					break;
				case 0x80:
					printf("30.5 mm");
					break;
				case 0xA0:
					printf("greater than 30.5 mm");
					break;
				default:
					printf("Undefined");
					break;
				}
				printf("\n  -- DRAM Package : ");
				if (ucEepromData[iByteCounter] & 0x10) {
					printf("stack");
				} else {
					printf("planar");
				}
				printf("\n  -- Card on Card : ");
				if (ucEepromData[iByteCounter] & 0x08) {
					printf("yes");
				} else {
					printf("no");
				}
				printf("\n  -- # of Ranks : ");
				printf("%u", (ucEepromData[iByteCounter] & 0x07) + 1);
				printf("\n");

			} else if (iByteCounter == 6) {

				printf("Byte 6: Module Data Width [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%u", ucEepromData[iByteCounter]);
				}
				printf("\n");

			} else if (iByteCounter == 7) {

				printf("Byte 7: Reserved [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("Undefined");
				printf("\n");

			} else if (iByteCounter == 8) {

				printf(
						"Byte 8: Voltage Interface Level of this assembly [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter]) {
				case 0x00:
					printf("TTL/5 V tolerant");
					break;
				case 0x01:
					printf("LVTTL (not 5 V tolerant)");
					break;
				case 0x02:
					printf("HSTL 1.5 V");
					break;
				case 0x03:
					printf("SSTL 3.3 V");
					break;
				case 0x04:
					printf("SSTL 2.5 V");
					break;
				case 0x05:
					printf("SSTL 1.8 V");
					break;
				default:
					printf("TBD");
					break;
				}
				printf("\n");

			} else if (iByteCounter == 9) {

				printf("Byte 9: SDRAM Cycle Time [0x%02Xh] : ",
						ucEepromData[iByteCounter]);

				switch (ucEepromData[iByteCounter] & 0xF0) {
				case 0x00:
					printf("01");
					break;
				case 0x10:
					printf("02");
					break;
				case 0x20:
					printf("03");
					break;
				case 0x30:
					printf("04");
					break;
				case 0x40:
					printf("05");
					break;
				case 0x50:
					printf("06");
					break;
				case 0x60:
					printf("07");
					break;
				case 0x70:
					printf("08");
					break;
				case 0x80:
					printf("09");
					break;
				case 0x90:
					printf("10");
					break;
				case 0xA0:
					printf("11");
					break;
				case 0xB0:
					printf("12");
					break;
				case 0xC0:
					printf("13");
					break;
				case 0xD0:
					printf("14");
					break;
				case 0xE0:
					printf("15");
					break;
				default:
					printf("Undefined");
					break;
				}
				printf(".");
				switch (ucEepromData[iByteCounter] & 0x0F) {
				case 0x00:
					printf("00");
					break;
				case 0x01:
					printf("10");
					break;
				case 0x02:
					printf("20");
					break;
				case 0x03:
					printf("30");
					break;
				case 0x04:
					printf("40");
					break;
				case 0x05:
					printf("50");
					break;
				case 0x06:
					printf("60");
					break;
				case 0x07:
					printf("70");
					break;
				case 0x08:
					printf("80");
					break;
				case 0x09:
					printf("90");
					break;
				case 0x0A:
					printf("25");
					break;
				case 0x0B:
					printf("33");
					break;
				case 0x0C:
					printf("66");
					break;
				case 0x0D:
					printf("75");
					break;
				default:
					printf("Undefined");
					break;
				}
				printf(" ns");
				printf("\n");

			}			else if (iByteCounter == 10) {

				printf("Byte 10: SDRAM Access from Clock (tAC) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);

				switch (ucEepromData[iByteCounter] & 0xF0) {
				case 0x00:
					printf("Undefined");
					break;
				case 0x10:
					printf("0.1");
					break;
				case 0x20:
					printf("0.2");
					break;
				case 0x30:
					printf("0.3");
					break;
				case 0x40:
					printf("0.4");
					break;
				case 0x50:
					printf("0.5");
					break;
				case 0x60:
					printf("0.6");
					break;
				case 0x70:
					printf("0.7");
					break;
				case 0x80:
					printf("0.8");
					break;
				case 0x90:
					printf("0.9");
					break;
				case 0xA0:
					printf("RFU");
					break;
				default:
					printf("Undefined");
					break;
				}
				switch (ucEepromData[iByteCounter] & 0x0F) {
				case 0x00:
					printf("0");
					break;
				case 0x01:
					printf("1");
					break;
				case 0x02:
					printf("2");
					break;
				case 0x03:
					printf("3");
					break;
				case 0x04:
					printf("4");
					break;
				case 0x05:
					printf("5");
					break;
				case 0x06:
					printf("6");
					break;
				case 0x07:
					printf("7");
					break;
				case 0x08:
					printf("8");
					break;
				case 0x09:
					printf("9");
					break;
				case 0x0A:
					printf(".RFU");
					break;
				default:
					printf("Undefined");
					break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 11) {

				printf("Byte 11: DIMM Configuration Type [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- Address/Command Parity : ");
				if (0x04 & ucEepromData[iByteCounter]) {
					printf("Supported on this assembly");
				} else {
					printf("Not supported on this assembly");
				}
				printf("\n  -- Data ECC : ");
				if (0x02 & ucEepromData[iByteCounter]) {
					printf("Supported on this assembly");
				} else {
					printf("Not supported on this assembly");
				}
				printf("\n  -- Data Parity : ");
				if (0x01 & ucEepromData[iByteCounter]) {
					printf("Supported on this assembly");
				} else {
					printf("Not supported on this assembly");
				}
				printf("\n");

			} else if (iByteCounter == 12) {

				printf("Byte 12: Refresh Rate [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter]) {
					case 0x80: printf("Normal (15.625 us)"); break;
					case 0x81: printf("Reduced (.25x)...3.9 us"); break;
					case 0x82: printf("Reduced (.5x)...7.8 us"); break;
					case 0x83: printf("Extended (2x)...31.3 us"); break;
					case 0x84: printf("Extended (4x)...62.5 us"); break;
					case 0x85: printf("Extended (8x)...125 us"); break;
					case 0x86: printf("TBD"); break;
					case 0x87: printf("TBD"); break;
					default: printf("Undefined"); break;
				}
				printf("\n");

			} else if (iByteCounter == 13) {

				printf("Byte 13: Primary SDRAM Width [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%u", ucEepromData[iByteCounter]);
				}
				printf("\n");

			} else if (iByteCounter == 14) {

				printf("Byte 14: Error Checking SDRAM Width [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%u", ucEepromData[iByteCounter]);
				}
				printf("\n");

			} else if (iByteCounter == 15) {

				printf("Byte 15: Reserved [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
					printf("Undefined");
				printf("\n");

			} else if (iByteCounter == 16) {

				printf("Byte 16: SDRAM Device Attributes – Burst Lengths Supported [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- Burst Length = 8 : ");
				if (0x08 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- Burst Length = 4 : ");
				if (0x04 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n");

			} else if (iByteCounter == 17) {

				printf("Byte 17: SDRAM Device Attributes – Number of Banks on SDRAM Device [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%u", ucEepromData[iByteCounter]);
				}
				printf("\n");

			} else if (iByteCounter == 18) {

				printf("Byte 18: SDRAM Device Attributes – CASn Latency [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- CASn Latency = 7 : "); if (0x80 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- CASn Latency = 6 : "); if (0x40 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- CASn Latency = 5 : "); if (0x20 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- CASn Latency = 4 : "); if (0x10 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- CASn Latency = 3 : "); if (0x08 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- CASn Latency = 2 : "); if (0x04 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n");

			} else if (iByteCounter == 19) {

				printf("Byte 19: DIMM Mechanical Characteristics [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0x07) {
					case 0x00:
						printf("Undefined");
						break;
					case 0x01:
						switch (ucEepromData[iByteCounter+1]) {
							case 0x01: printf("x <= 4.10"); break;
							case 0x02: printf("x <= 4.10"); break;
							case 0x04: printf("x <= 3.80"); break;
							case 0x08: printf("x <= 3.80"); break;
							case 0x10: printf("x <= 3.85"); break;
							case 0x20: printf("x <= 3.85"); break;
							case 0x07: printf("x <= 3.80"); break;
							case 0x06: printf("x <= 3.80"); break;
							default: printf("Reserved"); break;
						}
						break;
					case 0x02:
						switch (ucEepromData[iByteCounter+1]) {
							case 0x01: printf("4.10 < x <= 6.75"); break;
							case 0x02: printf("4.10 < x <= 6.75"); break;
							case 0x04: printf("3.80 < x <= TBD"); break;
							case 0x08: printf("3.80 < x <= TBD"); break;
							case 0x10: printf("3.85 < x <= 6.45"); break;
							case 0x20: printf("3.85 < x <= 6.45"); break;
							case 0x07: printf("3.80 < x <= 7.10"); break;
							case 0x06: printf("3.80 < x <= 7.10"); break;
							default: printf("Reserved"); break;
						}
						break;
					case 0x03:
						switch (ucEepromData[iByteCounter+1]) {
							case 0x01: printf("6.75 < x <= 7.55"); break;
							case 0x02: printf("6.75 < x <= 7.55"); break;
							case 0x04: printf("TBD < x <= TBD"); break;
							case 0x08: printf("TBD < x <= TBD"); break;
							case 0x10: printf("6.45 < x <= 7.25"); break;
							case 0x20: printf("6.45 < x <= 7.25"); break;
							case 0x07: printf("7.10 < x"); break;
							case 0x06: printf("7.10 < x"); break;
							default: printf("Reserved"); break;
						}
						break;
					case 0x04:
						switch (ucEepromData[iByteCounter+1]) {
							case 0x01: printf("7.55 < x"); break;
							case 0x02: printf("7.55 < x"); break;
							case 0x04: printf("TBD < x"); break;
							case 0x08: printf("TBD < x"); break;
							case 0x10: printf("7.25 < x"); break;
							case 0x20: printf("7.25 < x"); break;
							default: printf("Reserved"); break;
						}
						break;
					default:
						printf("Reserved");
						break;
				}
				printf("\n");

			} else if (iByteCounter == 20) {

				printf("Byte 20: DIMM type information [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter]) {
					case 0x00: printf("Undefined"); break;
					case 0x01: printf("RDIMM (width = 133.35 mm nom)"); break;
					case 0x02: printf("UDIMM (width = 1333.35 mm nom)"); break;
					case 0x04: printf("SO-DIMM (width = 67.60 mm nom)"); break;
					case 0x06: printf("72b-SO-CDIMM (width = 67.60 mm nom)"); break;
					case 0x07: printf("72b-SO-RDIMM (width = 67.60 mm nom)"); break;
					case 0x08: printf("Micro-DIMM (width = 54.00 mm nom)"); break;
					case 0x10: printf("Mini-RDIMM (width = 82.00 mm nom)"); break;
					case 0x20: printf("Mini-UDIMM (width = 82.00 mm nom)"); break;
					default: printf("Reserved"); break;
				}
				printf("\n");

			} else if (iByteCounter == 21) {

				printf("Byte 21: SDRAM Modules Attributes [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- Analysis probe installed : "); if (0x40 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- FET Switch External Enable : "); if (0x10 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- Number of PLLs on the DIMM : "); if (0x0C & ucEepromData[iByteCounter]) { printf("Reserved for future use"); } else { printf("%u", (0x0C & ucEepromData[iByteCounter]) >> 2); }
				printf("\n  -- Number of Active Registers on the DIMM : "); printf("%u", (0x03 & ucEepromData[iByteCounter]));
				printf("\n");

			} else if (iByteCounter == 22) {

				printf("Byte 22: SDRAM Device Attributes – General [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- Supports PASR (Partial Array Self Refresh) : "); if (0x04 & ucEepromData[iByteCounter]) { printf("TRUE"); } else { printf("FALSE"); }
				printf("\n  -- Supports 50 ohm ODT : "); if (0x02 & ucEepromData[iByteCounter]) { printf("TRUE"); } else { printf("FALSE"); }
				printf("\n  -- Supports Weak Driver : "); if (0x01 & ucEepromData[iByteCounter]) { printf("TRUE"); } else { printf("FALSE"); }
				printf("\n");

			} else if (iByteCounter == 23) {

				printf("Byte 23: Minimum Clock Cycle Time at Reduced CAS Latency, X-1 [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0xF0) {
					case 0x00: printf("Undefined"); break;
					case 0x10: printf("1/16"); break;
					case 0x20: printf("2/17"); break;
					case 0x30: printf("3"); break;
					case 0x40: printf("4"); break;
					case 0x50: printf("5"); break;
					case 0x60: printf("6"); break;
					case 0x70: printf("7"); break;
					case 0x80: printf("8"); break;
					case 0x90: printf("9"); break;
					case 0xA0: printf("10"); break;
					case 0xB0: printf("11"); break;
					case 0xC0: printf("12"); break;
					case 0xD0: printf("13"); break;
					case 0xE0: printf("14"); break;
					case 0xF0: printf("15"); break;
				}
				printf(".");
				switch (ucEepromData[iByteCounter] & 0x0F) {
					case 0x00: printf("00"); break;
					case 0x01: printf("10"); break;
					case 0x02: printf("20"); break;
					case 0x03: printf("30"); break;
					case 0x04: printf("40"); break;
					case 0x05: printf("50"); break;
					case 0x06: printf("60"); break;
					case 0x07: printf("70"); break;
					case 0x08: printf("80"); break;
					case 0x09: printf("90"); break;
					case 0x0A: printf("25"); break;
					case 0x0B: printf("33"); break;
					case 0x0C: printf("66"); break;
					case 0x0D: printf("75"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 24) {

				printf("Byte 24: Maximum Data Access Time (tAC) from Clock at CL X-1 [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0xF0) {
					case 0x00: printf("Undefined"); break;
					case 0x10: printf("0.1"); break;
					case 0x20: printf("0.2"); break;
					case 0x30: printf("0.3"); break;
					case 0x40: printf("0.4"); break;
					case 0x50: printf("0.5"); break;
					case 0x60: printf("0.6"); break;
					case 0x70: printf("0.7"); break;
					case 0x80: printf("0.8"); break;
					case 0x90: printf("0.9"); break;
					case 0xA0: printf("RFU"); break;
					default: printf("Undefined"); break;
				}
				switch (ucEepromData[iByteCounter] & 0x0F) {
					case 0x00: printf("0"); break;
					case 0x01: printf("1"); break;
					case 0x02: printf("2"); break;
					case 0x03: printf("3"); break;
					case 0x04: printf("4"); break;
					case 0x05: printf("5"); break;
					case 0x06: printf("6"); break;
					case 0x07: printf("7"); break;
					case 0x08: printf("8"); break;
					case 0x09: printf("9"); break;
					case 0x0A: printf(".RFU"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 25) {

				printf("Byte 25: Minimum Clock Cycle Time at CL X-2 [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0xF0) {
									case 0x00: printf("Undefined"); break;
									case 0x10: printf("1/16"); break;
									case 0x20: printf("2/17"); break;
									case 0x30: printf("3"); break;
									case 0x40: printf("4"); break;
									case 0x50: printf("5"); break;
									case 0x60: printf("6"); break;
									case 0x70: printf("7"); break;
									case 0x80: printf("8"); break;
									case 0x90: printf("9"); break;
									case 0xA0: printf("10"); break;
									case 0xB0: printf("11"); break;
									case 0xC0: printf("12"); break;
									case 0xD0: printf("13"); break;
									case 0xE0: printf("14"); break;
									case 0xF0: printf("15"); break;
								}
								printf(".");
								switch (ucEepromData[iByteCounter] & 0x0F) {
									case 0x00: printf("00"); break;
									case 0x01: printf("10"); break;
									case 0x02: printf("20"); break;
									case 0x03: printf("30"); break;
									case 0x04: printf("40"); break;
									case 0x05: printf("50"); break;
									case 0x06: printf("60"); break;
									case 0x07: printf("70"); break;
									case 0x08: printf("80"); break;
									case 0x09: printf("90"); break;
									case 0x0A: printf("25"); break;
									case 0x0B: printf("33"); break;
									case 0x0C: printf("66"); break;
									case 0x0D: printf("75"); break;
									default: printf("Undefined"); break;
								}
								printf(" ns");
								printf("\n");

			} else if (iByteCounter == 26) {

				printf("Byte 26: Maximum Data Access Time (tAC) from Clock at CL X-2 [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0xF0) {
					case 0x00: printf("Undefined"); break;
					case 0x10: printf("0.1"); break;
					case 0x20: printf("0.2"); break;
					case 0x30: printf("0.3"); break;
					case 0x40: printf("0.4"); break;
					case 0x50: printf("0.5"); break;
					case 0x60: printf("0.6"); break;
					case 0x70: printf("0.7"); break;
					case 0x80: printf("0.8"); break;
					case 0x90: printf("0.9"); break;
					case 0xA0: printf("RFU"); break;
					default: printf("Undefined"); break;
				}
				switch (ucEepromData[iByteCounter] & 0x0F) {
					case 0x00: printf("0"); break;
					case 0x01: printf("1"); break;
					case 0x02: printf("2"); break;
					case 0x03: printf("3"); break;
					case 0x04: printf("4"); break;
					case 0x05: printf("5"); break;
					case 0x06: printf("6"); break;
					case 0x07: printf("7"); break;
					case 0x08: printf("8"); break;
					case 0x09: printf("9"); break;
					case 0x0A: printf(".RFU"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 27) {

				printf("Byte 27: Minimum Row Precharge Time (tRP) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0xFC & ucEepromData[iByteCounter]) {
					printf("%02u", (0xFC & ucEepromData[iByteCounter]) >> 2);
				} else {
					printf("Undefined");
				}
				printf(".");
				switch (0x03 & ucEepromData[iByteCounter]) {
					case 0x00: printf("00"); break;
					case 0x01: printf("25"); break;
					case 0x02: printf("50"); break;
					case 0x03: printf("75"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 28) {

				printf("Byte 28: Minimum Row Active to Row Active Delay (tRRD) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0xFC & ucEepromData[iByteCounter]) {
					printf("%02u", (0xFC & ucEepromData[iByteCounter]) >> 2);
				} else {
					printf("Undefined");
				}
				printf(".");
				switch (0x03 & ucEepromData[iByteCounter]) {
					case 0x00: printf("00"); break;
					case 0x01: printf("25"); break;
					case 0x02: printf("50"); break;
					case 0x03: printf("75"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 29) {

				printf("Byte 29: Minimum RASn to CASn Delay (tRCD) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0xFC & ucEepromData[iByteCounter]) {
					printf("%02u", (0xFC & ucEepromData[iByteCounter]) >> 2);
				} else {
					printf("Undefined");
				}
				printf(".");
				switch (0x03 & ucEepromData[iByteCounter]) {
					case 0x00: printf("00"); break;
					case 0x01: printf("25"); break;
					case 0x02: printf("50"); break;
					case 0x03: printf("75"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 30) {

				printf("Byte 30: Minimum Active to Precharge Time (tRAS) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%03u", ucEepromData[iByteCounter]);
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 31) {

				printf("Byte 31: Module Rank Density [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- 512 MB : "); if (0x80 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- 256 MB : "); if (0x40 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- 128 MB : "); if (0x20 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- 16 GB : "); if (0x10 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- 8 GB : "); if (0x08 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- 4 GB : "); if (0x04 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- 2 GB : "); if (0x02 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n  -- 1 GB : "); if (0x01 & ucEepromData[iByteCounter]) { printf("Supported on this assembly"); } else { printf("Not supported on this assembly"); }
				printf("\n");

			} else if (iByteCounter == 32) {

				printf("Byte 32: Address and Command Setup Time Before Clock (tIS) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0xF0) {
					case 0x00: printf("Undefined"); break;
					case 0x10: printf("0.1"); break;
					case 0x20: printf("0.2"); break;
					case 0x30: printf("0.3"); break;
					case 0x40: printf("0.4"); break;
					case 0x50: printf("0.5"); break;
					case 0x60: printf("0.6"); break;
					case 0x70: printf("0.7"); break;
					case 0x80: printf("0.8"); break;
					case 0x90: printf("0.9"); break;
					case 0xA0: printf("1.0"); break;
					case 0xB0: printf("1.1"); break;
					case 0xC0: printf("1.2"); break;
					case 0xD0: printf("RFU"); break;
					default: printf("Undefined"); break;
				}
				switch (ucEepromData[iByteCounter] & 0x0F) {
					case 0x00: printf("0"); break;
					case 0x01: printf("1"); break;
					case 0x02: printf("2"); break;
					case 0x03: printf("3"); break;
					case 0x04: printf("4"); break;
					case 0x05: printf("5"); break;
					case 0x06: printf("6"); break;
					case 0x07: printf("7"); break;
					case 0x08: printf("8"); break;
					case 0x09: printf("9"); break;
					case 0x0A: printf(".RFU"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 33) {

				printf("Byte 33: Address and Command Hold Time After Clock (tIH) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0xF0) {
					case 0x00: printf("Undefined"); break;
					case 0x10: printf("0.1"); break;
					case 0x20: printf("0.2"); break;
					case 0x30: printf("0.3"); break;
					case 0x40: printf("0.4"); break;
					case 0x50: printf("0.5"); break;
					case 0x60: printf("0.6"); break;
					case 0x70: printf("0.7"); break;
					case 0x80: printf("0.8"); break;
					case 0x90: printf("0.9"); break;
					case 0xA0: printf("1.0"); break;
					case 0xB0: printf("1.1"); break;
					case 0xC0: printf("1.2"); break;
					case 0xD0: printf("RFU"); break;
					default: printf("Undefined"); break;
				}
				switch (ucEepromData[iByteCounter] & 0x0F) {
					case 0x00: printf("0"); break;
					case 0x01: printf("1"); break;
					case 0x02: printf("2"); break;
					case 0x03: printf("3"); break;
					case 0x04: printf("4"); break;
					case 0x05: printf("5"); break;
					case 0x06: printf("6"); break;
					case 0x07: printf("7"); break;
					case 0x08: printf("8"); break;
					case 0x09: printf("9"); break;
					case 0x0A: printf(".RFU"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 34) {

				printf("Byte 34: Data Input Setup Time Before Strobe (tDS) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0xF0) {
					case 0x00: printf("Undefined"); break;
					case 0x10: printf("0.1"); break;
					case 0x20: printf("0.2"); break;
					case 0x30: printf("0.3"); break;
					case 0x40: printf("0.4"); break;
					case 0x50: printf("0.5"); break;
					case 0x60: printf("0.6"); break;
					case 0x70: printf("0.7"); break;
					case 0x80: printf("0.8"); break;
					case 0x90: printf("0.9"); break;
					case 0xA0: printf("RFU"); break;
					default: printf("Undefined"); break;
				}
				switch (ucEepromData[iByteCounter] & 0x0F) {
					case 0x00: printf("0"); break;
					case 0x01: printf("1"); break;
					case 0x02: printf("2"); break;
					case 0x03: printf("3"); break;
					case 0x04: printf("4"); break;
					case 0x05: printf("5"); break;
					case 0x06: printf("6"); break;
					case 0x07: printf("7"); break;
					case 0x08: printf("8"); break;
					case 0x09: printf("9"); break;
					case 0x0A: printf(".RFU"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 35) {

				printf("Byte 35: Data Input Hold Time After Strobe (tDH) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0xF0) {
					case 0x00: printf("Undefined"); break;
					case 0x10: printf("0.1"); break;
					case 0x20: printf("0.2"); break;
					case 0x30: printf("0.3"); break;
					case 0x40: printf("0.4"); break;
					case 0x50: printf("0.5"); break;
					case 0x60: printf("0.6"); break;
					case 0x70: printf("0.7"); break;
					case 0x80: printf("0.8"); break;
					case 0x90: printf("0.9"); break;
					case 0xA0: printf("RFU"); break;
					default: printf("Undefined"); break;
				}
				switch (ucEepromData[iByteCounter] & 0x0F) {
					case 0x00: printf("0"); break;
					case 0x01: printf("1"); break;
					case 0x02: printf("2"); break;
					case 0x03: printf("3"); break;
					case 0x04: printf("4"); break;
					case 0x05: printf("5"); break;
					case 0x06: printf("6"); break;
					case 0x07: printf("7"); break;
					case 0x08: printf("8"); break;
					case 0x09: printf("9"); break;
					case 0x0A: printf(".RFU"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 36) {

				printf("Byte 36: Write Recovery Time (tWR) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0xFC & ucEepromData[iByteCounter]) {
					printf("%02u", (0xFC & ucEepromData[iByteCounter]) >> 2);
				} else {
					printf("Undefined");
				}
				printf(".");
				switch (0x03 & ucEepromData[iByteCounter]) {
					case 0x00: printf("00"); break;
					case 0x01: printf("25"); break;
					case 0x02: printf("50"); break;
					case 0x03: printf("75"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 37) {

				printf("Byte 37: Internal write to read command delay (tWTR) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0xFC & ucEepromData[iByteCounter]) {
					printf("%02u", (0xFC & ucEepromData[iByteCounter]) >> 2);
				} else {
					printf("Undefined");
				}
				printf(".");
				switch (0x03 & ucEepromData[iByteCounter]) {
					case 0x00: printf("00"); break;
					case 0x01: printf("25"); break;
					case 0x02: printf("50"); break;
					case 0x03: printf("75"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 38) {

				printf("Byte 38: Internal read to precharge command delay (tRTP) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0xFC & ucEepromData[iByteCounter]) {
					printf("%02u", (0xFC & ucEepromData[iByteCounter]) >> 2);
				} else {
					printf("Undefined");
				}
				printf(".");
				switch (0x03 & ucEepromData[iByteCounter]) {
					case 0x00: printf("00"); break;
					case 0x01: printf("25"); break;
					case 0x02: printf("50"); break;
					case 0x03: printf("75"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 39) {

				printf("Byte 39: Memory Analysis Probe Characteristics [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%u", ucEepromData[iByteCounter]);
				}
				printf("\n");

			} else if (iByteCounter == 40) {

				printf("Byte 40: Extension of Byte 41 tRC and Byte 42 tRFC [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n");

			} else if (iByteCounter == 41) {

				printf("Byte 41: SDRAM Device Minimum Activate to Activate/Refresh Time (tRC) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else if (0xFF == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%03u", ucEepromData[iByteCounter]);
				}
				printf(".");
				switch (0xF0 & ucEepromData[iByteCounter]) {
					case 0x00: printf("00"); break;
					case 0x10: printf("25"); break;
					case 0x20: printf("33"); break;
					case 0x30: printf("50"); break;
					case 0x40: printf("66"); break;
					case 0x50: printf("75"); break;
					case 0x60: printf("RFU"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 42) {

				printf("Byte 42: SDRAM Device Minimum Refresh to Activate/Refresh Command Period (tRFC) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {

					if (0x00 == (ucEepromData[iByteCounter-2] & 0x01)) {
						printf("%03u", (alt_u16)ucEepromData[iByteCounter] + 256);
					} else {
						printf("%03u", ucEepromData[iByteCounter]);
					}
				}
				printf(".");
				switch (0x0E & ucEepromData[iByteCounter]) {
					case 0x00: printf("00"); break;
					case 0x02: printf("25"); break;
					case 0x04: printf("33"); break;
					case 0x06: printf("50"); break;
					case 0x08: printf("66"); break;
					case 0x0A: printf("75"); break;
					case 0x0C: printf("RFU"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 43) {

				printf("Byte 43: SDRAM Device Maximum Device Cycle Time (tCK max) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter] & 0xF0) {
					case 0x00: printf("Undefined"); break;
					case 0x10: printf("1"); break;
					case 0x20: printf("2"); break;
					case 0x30: printf("3"); break;
					case 0x40: printf("4"); break;
					case 0x50: printf("5"); break;
					case 0x60: printf("6"); break;
					case 0x70: printf("7"); break;
					case 0x80: printf("8"); break;
					case 0x90: printf("9"); break;
					case 0xA0: printf("10"); break;
					case 0xB0: printf("11"); break;
					case 0xC0: printf("12"); break;
					case 0xD0: printf("13"); break;
					case 0xE0: printf("14"); break;
					case 0xF0: printf("15"); break;
				}
				printf(".");
				switch (ucEepromData[iByteCounter] & 0x0F) {
					case 0x00: printf("00"); break;
					case 0x01: printf("10"); break;
					case 0x02: printf("20"); break;
					case 0x03: printf("30"); break;
					case 0x04: printf("40"); break;
					case 0x05: printf("50"); break;
					case 0x06: printf("60"); break;
					case 0x07: printf("70"); break;
					case 0x08: printf("80"); break;
					case 0x09: printf("90"); break;
					case 0x0A: printf("25"); break;
					case 0x0B: printf("33"); break;
					case 0x0C: printf("66"); break;
					case 0x0D: printf("75"); break;
					default: printf("Undefined"); break;
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 44) {

				printf("Byte 44: SDRAM Device DQS-DQ Skew for DQS and associated DQ signals (tDQSQ max) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%.2f", (float)ucEepromData[iByteCounter] * 0.01);
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 45) {

				printf("Byte 45: SDRAM Device Read Data Hold Skew Factor (tQHS) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%.2f", (float)ucEepromData[iByteCounter] * 0.01);
				}
				printf(" ns");
				printf("\n");

			} else if (iByteCounter == 46) {

				printf("Byte 46: PLL Relock Time [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Undefined");
				} else {
					printf("%u", ucEepromData[iByteCounter]);
				}
				printf(" us");
				printf("\n");

			} else if (iByteCounter == 47) {

				printf("Byte 47: Tcasemax [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- Tcasemax : ");
				switch (ucEepromData[iByteCounter] & 0xF0) {
					case 0x00: printf("00"); break;
					case 0x10: printf("02"); break;
					case 0x20: printf("04"); break;
					case 0x30: printf("06"); break;
					case 0x40: printf("08"); break;
					case 0x50: printf("10"); break;
					case 0x60: printf("12"); break;
					case 0x70: printf("14"); break;
					case 0x80: printf("16"); break;
					case 0x90: printf("18"); break;
					case 0xA0: printf("20"); break;
					case 0xB0: printf("22"); break;
					case 0xC0: printf("24"); break;
					case 0xD0: printf("26"); break;
					case 0xE0: printf("28"); break;
					case 0xF0: printf("Exceed 30"); break;
				}
				printf(" 0C");
				printf("\n  -- DT4R4W Delta : ");
				switch (ucEepromData[iByteCounter] & 0x0F) {
					case 0x00: printf("0.0"); break;
					case 0x01: printf("0.4"); break;
					case 0x02: printf("0.8"); break;
					case 0x03: printf("1.2"); break;
					case 0x04: printf("1.6"); break;
					case 0x05: printf("2.0"); break;
					case 0x06: printf("2.4"); break;
					case 0x07: printf("2.8"); break;
					case 0x08: printf("3.2"); break;
					case 0x09: printf("3.6"); break;
					case 0x0A: printf("4.0"); break;
					case 0x0B: printf("4.4"); break;
					case 0x0C: printf("4.8"); break;
					case 0x0D: printf("5.2"); break;
					case 0x0E: printf("5.6"); break;
					case 0x0F: printf("Exceed 6.0"); break;
				}
				printf(" 0C");
				printf("\n");

			} else if (iByteCounter == 48) {

				printf("Byte 48: Thermal Resistance of DRAM Package from Top (Case) to Ambient ( Psi T-A DRAM ) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Defined");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 127.5");
				} else {
					printf("%.1f", (float)ucEepromData[iByteCounter] * 0.5);
				}
				printf(" 0C/W");
				printf("\n");

			} else if (iByteCounter == 49) {

				printf("Byte 49: DRAM Case Temperature Rise from Ambient due to Activate-Precharge/Mode Bits (DT0/Mode Bits) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- DT0 : ");
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Defined");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 18.9");
				} else {
					printf("%.1f", (float)ucEepromData[iByteCounter] * 0.3);
				}
				printf(" 0C");
				printf("\n  -- Subfield B : ");
				if (0x02 & ucEepromData[iByteCounter]) {
					printf("Requires double refresh rate for the proper operation at the DRAM maximum case temperature above 85 0C. The DRAM maximum case temperature is specified at Byte 47.");
				} else {
					printf("Do not need double refresh rate for the proper operation at the DRAM maximum case temperature above 85 0C. The DRAM maximum case temperature is specified at Byte 47.");
				}
				printf("\n  -- Subfield A : ");
				if (0x01 & ucEepromData[iByteCounter]) {
					printf("DRAM high temperature self-refresh entry supported. When needed, controller may set DRAM in high temperature self-refresh mode via EMRS(2) [A7] and be able to enter self-refresh above 85 0C Tcase temperature");
				} else {
					printf("DRAM does not support high temperature self-refresh entry. Controller must ensure DRAM cools down to Tcase < 85 0C before entering self-refresh");
				}
				printf("\n");

			} else if (iByteCounter == 50) {

				printf("Byte 50: DRAM Case Temperature Rise from Ambient due to Precharge/Quiet Standby (DT2N/DT2Q) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 25.5 oC");
				} else {
					printf("%.1f oC", (float)ucEepromData[iByteCounter] * 0.1);
				}
				printf("\n");

			} else if (iByteCounter == 51) {

				printf("Byte 51: DRAM Case Temperature Rise from Ambient due to Precharge Power-Down (DT2P) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 3.825 oC");
				} else {
					printf("%.3f oC", (float)ucEepromData[iByteCounter] * 0.015);
				}
				printf("\n");

			} else if (iByteCounter == 52) {

				printf("Byte 52: DRAM Case Temperature Rise from Ambient due to Active Standby (DT3N) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 38.25 oC");
				} else {
					printf("%.2f oC", (float)ucEepromData[iByteCounter] * 0.15);
				}
				printf("\n");

			} else if (iByteCounter == 53) {

				printf("Byte 53: DRAM Case temperature Rise from Ambient due to Active Power-Down with Fast PDN Exit (DT3Pfast) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 12.75 oC");
				} else {
					printf("%.2f oC", (float)ucEepromData[iByteCounter] * 0.05);
				}
				printf("\n");

			} else if (iByteCounter == 54) {

				printf("Byte 54: DRAM Case temperature Rise from Ambient due to Active Power-Down with Slow PDN Exit (DT3Pslow) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 6.375 oC");
				} else {
					printf("%.3f oC", (float)ucEepromData[iByteCounter] * 0.025);
				}
				printf("\n");

			} else if (iByteCounter == 55) {

				printf("Byte 55: DRAM Case Temperature Rise from Ambient due to Page Open Burst Read/DT4R4W Mode Bit (DT4R/DT4R4W Mode Bit) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- DT4R : ");
				if (0x00 == ((ucEepromData[iByteCounter] & 0xFE) >> 1)) {
					printf("Not Supported");
				} else if (0x7F == ucEepromData[iByteCounter]){
					printf("Exceed 50.8 oC");
				} else {
					printf("%.1f oC", (float)ucEepromData[iByteCounter] * 0.4);
				}
				printf("\n  -- DT4R4W Mode Bit : ");
				if (ucEepromData[iByteCounter] & 0x01) {
					printf("DT4W is less than DT4R");
				} else {
					printf("DT4W is greater than or equal to DT4R");
				}
				printf("\n");

			} else if (iByteCounter == 56) {

				printf("Byte 56: DRAM Case Temperature Rise from Ambient due to Burst Refresh (DT5B) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 127.5 oC");
				} else {
					printf("%.1f oC", (float)ucEepromData[iByteCounter] * 0.5);
				}
				printf("\n");

			} else if (iByteCounter == 57) {

				printf("Byte 57: DRAM Case Temperature Rise from Ambient due to Bank Interleave Reads with Auto-Precharge (DT7) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 127.5 oC");
				} else {
					printf("%.1f oC", (float)ucEepromData[iByteCounter] * 0.5);
				}
				printf("\n");

			} else if (iByteCounter == 58) {

				printf("Byte 58: Thermal Resistance of PLL Package from Top (Case) to Ambient ( Psi T-A PLL ) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 127.5 oC");
				} else {
					printf("%.1f oC", (float)ucEepromData[iByteCounter] * 0.5);
				}
				printf("\n");

			} else if (iByteCounter == 59) {

				printf("Byte 59: Thermal Resistance of Register Package from Top (Case) to Ambient ( Psi T-A Register) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 127.5 oC");
				} else {
					printf("%.1f oC", (float)ucEepromData[iByteCounter] * 0.5);
				}
				printf("\n");

			} else if (iByteCounter == 60) {

				printf("Byte 60: PLL Case Temperature Rise from Ambient due to PLL Active (DT PLL Active) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				if (0x00 == ucEepromData[iByteCounter]) {
					printf("Not Supported");
				} else if (0xFF == ucEepromData[iByteCounter]){
					printf("Exceed 63.75 oC");
				} else {
					printf("%.2f oC", (float)ucEepromData[iByteCounter] * 0.25);
				}
				printf("\n");

			} else if (iByteCounter == 61) {

				printf("Byte 61: Register Case Temperature Rise from Ambient due to Register Active/Mode Bit (DT Register Active/Mode Bit) [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n  -- Subfield A : ");
				if (0x01 & ucEepromData[iByteCounter]) {
					printf("100p register data output toggle");
					printf("\n  -- Subfield B : ");
					if (0x00 == ucEepromData[iByteCounter]) {
						printf("Not Supported");
					} else if (0xFF == ucEepromData[iByteCounter]){
						printf("Exceed 78.75 oC");
					} else {
						printf("%.2f oC", (float)ucEepromData[iByteCounter] * 1.25);
					}
				} else {
					printf("50p register data output toggle");
					printf("\n  -- Subfield B : ");
					if (0x00 == ucEepromData[iByteCounter]) {
						printf("Not Supported");
					} else if (0xFF == ucEepromData[iByteCounter]){
						printf("Exceed 47.25 oC");
					} else {
						printf("%.2f oC", (float)ucEepromData[iByteCounter] * 0.75);
					}
				}
				printf("\n");

			} else if (iByteCounter == 62) {

				printf("Byte 62: SPD Revision [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				switch (ucEepromData[iByteCounter]) {
					case 0x00: printf("Revision 0.0"); break;
					case 0x10: printf("Revision 1.0"); break;
					case 0x11: printf("Revision 1.1"); break;
					case 0x12: printf("Revision 1.2"); break;
					case 0x13: printf("Revision 1.3"); break;
					default: printf("Undefined"); break;
				}
				printf("\n");

			} else if (iByteCounter == 63) {

				printf("Byte 63: Checksum for Bytes 0-62 [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				alt_u16 uiCRC = 0;
				alt_u16 uiCnt = 0;
				for (uiCnt = 0; uiCnt < 63; uiCnt++) {
					uiCRC += ucEepromData[iByteCounter];
				}
				printf("Calculated CRC = 0x%02X", (alt_u8)(uiCRC & 0x00FF));
				printf("\n");

			} else if (iByteCounter == 64) {

				printf("Bytes 64-71: Module Manufacturer’s JEDEC ID Code [0x");
				alt_u16 uiCnt = 0;
				for (uiCnt = 64; uiCnt < 72; uiCnt++) {
					printf("%02X", ucEepromData[uiCnt]);
				}
				printf("] : ");
				printf("\n");

			} else if (iByteCounter == 72) {

				printf("Byte 72: Module Manufacturing Location [0x%02Xh] : ",
						ucEepromData[iByteCounter]);
				printf("\n");

			} else if (iByteCounter == 73) {

				printf("Bytes 73-90: Module Part Number [0x");
				alt_u16 uiCnt = 0;
				for (uiCnt = 73; uiCnt < 91; uiCnt++) {
					printf("%02X", ucEepromData[uiCnt]);
				}
				printf("] : ");
				for (uiCnt = 73; uiCnt < 91; uiCnt++) {
					printf("%c", (char)ucEepromData[uiCnt]);
				}
				printf("\n");

			} else if (iByteCounter == 91) {

				printf("Bytes 91-92: Module Revision Code [0x");
				alt_u16 uiCnt = 0;
				for (uiCnt = 91; uiCnt < 93; uiCnt++) {
					printf("%02X", ucEepromData[uiCnt]);
				}
				printf("] : ");
				printf("\n");

			} else if (iByteCounter == 93) {

				printf("Bytes 93-94: Module Manufacturing Date [0x");
				alt_u16 uiCnt = 0;
				for (uiCnt = 93; uiCnt < 95; uiCnt++) {
					printf("%02X", ucEepromData[uiCnt]);
				}
				printf("] : ");
				printf("year 20%02u, week %02u", ucEepromData[iByteCounter], ucEepromData[iByteCounter+1]);
				printf("\n");

			} else if (iByteCounter == 95) {

				printf("Bytes 95-98: Module Serial Numb [0x");
				alt_u16 uiCnt = 0;
				for (uiCnt = 95; uiCnt < 99; uiCnt++) {
					printf("%02X", ucEepromData[uiCnt]);
				}
				printf("] : ");
				printf("\n");

			} else if (iByteCounter == 99) {

				printf("Bytes 99-127: Manufacturer’s Specific Data [0x");
				alt_u16 uiCnt = 0;
				for (uiCnt = 99; uiCnt < 128; uiCnt++) {
					printf("%02X", ucEepromData[uiCnt]);
				}
				printf("] : ");
				printf("\n");

			} else if (iByteCounter == 128) {

				printf("Bytes 128-255: Open for Customer Use [0x");
				alt_u16 uiCnt = 0;
				for (uiCnt = 128; uiCnt < 256; uiCnt++) {
					printf("%02X", ucEepromData[uiCnt]);
					if ((159 == uiCnt) || (191 == uiCnt) || (223 == uiCnt)) {
						printf("\n");
					}
				}
				printf("] : ");
				printf("\n");

			} else {

//				printf("\n");

			}
		}
	} else {

		printf("Failed to dump EEPROM\n");

	}

	printf("\n");

	return bSuccess;
}

bool bDdr2SwitchMemory(alt_u8 ucMemoryId) {

	bool bSuccess = FALSE;
	alt_u32 *puliDdr2MemAddr = (alt_u32 *) DDR2_EXT_ADDR_CONTROL_BASE;

	switch (ucMemoryId) {
	case DDR2_M1_ID:
		*(puliDdr2MemAddr) = (alt_u32) DDR2_M1_MEMORY_WINDOWED_OFFSET;
		bSuccess = TRUE;
		break;
	case DDR2_M2_ID:
		*(puliDdr2MemAddr) = (alt_u32) DDR2_M2_MEMORY_WINDOWED_OFFSET;
		bSuccess = TRUE;
		break;
	default:
		bSuccess = FALSE;

		printf("DR2 Memory ID not identified!! Error switching memories!! \n");

	}

	return bSuccess;
}

/**
 * @name    bDdr2MemoryWriteTest
 * @brief
 * @ingroup DDR2
 *
 * Teste de escrita na memória, baseados em um vetor de dados aleatórios.
 *
 * @param [in] MemoryId  ID da mémoria a ser testada
 *
 * @retval TRUE : Sucesso
 *
 */
bool bDdr2MemoryWriteTest(alt_u8 ucMemoryId) {

	printf("===== DE4 DDR2 Memory Write Test =====\n");

	bool bSuccess = FALSE;
	alt_u32 uliDdr2Base;
	alt_u32 uliByteLen;

	switch (ucMemoryId) {
	case DDR2_M1_ID:
		bDdr2SwitchMemory(ucMemoryId);
		uliDdr2Base = DDR2_EXT_ADDR_WINDOWED_BASE;
		uliByteLen = DDR2_M1_MEMORY_SIZE;
		bSuccess = TRUE;
		break;
	case DDR2_M2_ID:
		bDdr2SwitchMemory(ucMemoryId);
		uliDdr2Base = DDR2_EXT_ADDR_WINDOWED_BASE;
		uliByteLen = DDR2_M2_MEMORY_SIZE;
		bSuccess = TRUE;
		break;
	default:
		bSuccess = FALSE;

		printf("DR2 Memory ID not identified!! Aborting Test \n");

		return bSuccess;
	}

	printf("DDR2 Size: %ld MBytes\n", uliByteLen / 1024 / 1024);

	int iI, iNRemainedLen, iNAccessLen;
	TMyData *pxDes;

	int iNItemNum, iNPos;
	const int ciMyDataSize = sizeof(TMyData);
	int iNProgressIndex = 0;
	alt_u32 uliInitValue;
	alt_u32 uliSZProgress[10];
	int iTimeStart, iTimeElapsed = 0;

	for (iI = 0; iI < 10; iI++) {
		uliSZProgress[iI] = uliByteLen / 10 * (iI + 1);
	}
	uliInitValue = alt_nticks();
	iNItemNum = sizeof(xSZData) / sizeof(xSZData[0]);
	for (iI = 0; iI < iNItemNum; iI++) {
		if (iI == 0) {
			xSZData[iI] = uliInitValue;
		} else {
			xSZData[iI] = xSZData[iI - 1] * 13;
		}
	}
	xSZData[iNItemNum - 1] = 0xAAAAAAAA;
	xSZData[iNItemNum - 2] = 0x55555555;
	xSZData[iNItemNum - 3] = 0x00000000;
	xSZData[iNItemNum - 4] = 0xFFFFFFFF;

	printf("Writing data...\n");

	iTimeStart = alt_nticks();
	pxDes = (TMyData *) uliDdr2Base;
	iNAccessLen = sizeof(xSZData);
	iNItemNum = iNAccessLen / ciMyDataSize;
	iNPos = 0;
	while (iNPos < uliByteLen) {
		iNRemainedLen = uliByteLen - iNPos;
		if (iNAccessLen > iNRemainedLen) {
			iNAccessLen = iNRemainedLen;
			iNItemNum = iNAccessLen / ciMyDataSize;
		}
		memcpy(pxDes, xSZData, iNAccessLen);
		pxDes += iNItemNum;
		iNPos += iNAccessLen;
		if (iNProgressIndex <= 9 && iNPos >= uliSZProgress[iNProgressIndex]) {
			iNProgressIndex++;

			printf("%02d%% ", iNProgressIndex * 10);

		}
	}
	alt_dcache_flush_all();

	printf("\n");

	iTimeElapsed = alt_nticks() - iTimeStart;
	if (bSuccess) {

		printf("DDR2 write test pass, size=%lu bytes, %.3f sec\n", uliByteLen,
				(float) iTimeElapsed / (float) alt_ticks_per_second());

	} else {

		printf("DDR2 write test fail\n");

	}

	printf("\n");

	return bSuccess;
}

/**
 * @name    bDdr2MemoryReadTest
 * @brief
 * @ingroup DDR2
 *
 * Teste de escrita na memória, baseados em um vetor de dados aleatórios.
 *
 * @param [in] MemoryId  ID da mémoria a ser testada
 *
 * @retval TRUE : Sucesso
 *
 */
bool bDdr2MemoryReadTest(alt_u8 ucMemoryId) {

	printf("===== DE4 DDR2 Memory Read Test =====\n");

	bool bSuccess = FALSE;
	alt_u32 uliDdr2Base;
	alt_u32 uliByteLen;

	switch (ucMemoryId) {
	case DDR2_M1_ID:
		bDdr2SwitchMemory(ucMemoryId);
		uliDdr2Base = DDR2_EXT_ADDR_WINDOWED_BASE;
		uliByteLen = DDR2_M1_MEMORY_SIZE;
		bSuccess = TRUE;
		break;
	case DDR2_M2_ID:
		bDdr2SwitchMemory(ucMemoryId);
		uliDdr2Base = DDR2_EXT_ADDR_WINDOWED_BASE;
		uliByteLen = DDR2_M2_MEMORY_SIZE;
		bSuccess = TRUE;
		break;
	default:
		bSuccess = FALSE;

		printf("DR2 Memory ID not identified!! Aborting Test \n");

		return bSuccess;
	}

	printf("DDR2 Size: %lu MBytes\n", uliByteLen / 1024 / 1024);

	int iI, iNRemainedLen, iNAccessLen;
	TMyData *pxDes, *pxSrc;
	int iNItemNum, iNPos;
	iNItemNum = sizeof(xSZData) / sizeof(xSZData[0]);
	const int ciMyDataSize = sizeof(TMyData);
	iNAccessLen = iNItemNum * ciMyDataSize;
	int iNProgressIndex = 0;
	alt_u32 uliSZProgress[10];
	int iTimeStart, iTimeElapsed = 0;

	for (iI = 0; iI < 10; iI++) {
		uliSZProgress[iI] = uliByteLen / 10 * (iI + 1);
	}

	iNProgressIndex = 0;

	printf("Reading/Verifying Data...\n");

	iTimeStart = alt_nticks();

	pxSrc = (TMyData *) uliDdr2Base;
	iNAccessLen = sizeof(xSZData);
	iNItemNum = iNAccessLen / ciMyDataSize;
	iNPos = 0;
	while (bSuccess && iNPos < uliByteLen) {
		iNRemainedLen = uliByteLen - iNPos;
		if (iNAccessLen > iNRemainedLen) {
			iNAccessLen = iNRemainedLen;
			iNItemNum = iNAccessLen / ciMyDataSize;
		}
		pxDes = xSZData;
		for (iI = 0; iI < iNItemNum && bSuccess; iI++) {
			if (*pxSrc++ != *pxDes++) {

				printf("verify ng, read=%08Xh, expected=%08Xh, WordIndex=%Xh\n",
						(int) *(pxSrc - 1), (int) xSZData[iI],
						(iNPos / ciMyDataSize) + iI);

				bSuccess = FALSE;
			}
		}
		iNPos += iNAccessLen;
		if (iNProgressIndex <= 9 && iNPos >= uliSZProgress[iNProgressIndex]) {
			iNProgressIndex++;

			printf("%02d%% ", iNProgressIndex * 10);

		}
	}

	printf("\n");

	iTimeElapsed = alt_nticks() - iTimeStart;
	if (bSuccess) {

		printf("DDR2 read test pass, size=%ld bytes, %.3f sec\n", uliByteLen,
				(float) iTimeElapsed / (float) alt_ticks_per_second());

	} else {

		printf("DDR2 read test fail\n");

	}

	printf("\n");

	return bSuccess;
}

/**
 * @name    bDdr2MemoryRandomWriteTest
 * @brief
 * @ingroup DDR2
 *
 * Teste de escrita na memória, baseados nos valores gerados por um RNG.
 *
 * @param [in] MemoryId  ID da mémoria a ser testada
 * @param [in] bVerbose  Controle o modo verbose da função
 * @param [in] bTime  Controla se a duração da função será medida
 *
 * @retval TRUE : Sucesso
 *
 */
bool bDdr2MemoryRandomWriteTest(alt_u8 ucMemoryId, bool bVerbose, bool bTime) {

	printf("===== DE4 DDR2 Memory Random Write Test =====\n");

	bool bSuccess = FALSE;
	alt_u32 uliDdr2Base;
	alt_u32 uliByteLen;

	switch (ucMemoryId) {
	case DDR2_M1_ID:
		bDdr2SwitchMemory(ucMemoryId);
		uliDdr2Base = DDR2_EXT_ADDR_WINDOWED_BASE;
		uliByteLen = DDR2_M1_MEMORY_SIZE;
		bSuccess = TRUE;
		break;
	case DDR2_M2_ID:
		bDdr2SwitchMemory(ucMemoryId);
		uliDdr2Base = DDR2_EXT_ADDR_WINDOWED_BASE;
		uliByteLen = DDR2_M2_MEMORY_SIZE;
		bSuccess = TRUE;
		break;
	default:
		bSuccess = FALSE;

		printf("DR2 Memory ID not identified!! Aborting Test \n");

		return bSuccess;
	}

	printf("DDR2 Size: %ld MBytes\n", uliByteLen / 1024 / 1024);

	alt_u32 *puliDestination;
	alt_u32 uliCurrentState;
	alt_u32 uliMemoryEndAddress;
	alt_u32 uliNextMilestone;
	alt_u8 ucPercentage;

	uliInitialState = alt_nticks();
	uliCurrentState = uliInitialState;
	uliMemoryEndAddress = uliDdr2Base + uliByteLen;
	uliNextMilestone = uliDdr2Base + uliByteLen / 20;
	ucPercentage = 5;

	printf("Writing to memory...\n");

	if (bVerbose == DDR2_VERBOSE) {

		printf("00%%..");

	}
	int TimeStart, TimeElapsed = 0;

	TimeStart = alt_nticks();
	for (puliDestination = (alt_u32*) uliDdr2Base;
			(alt_u32) puliDestination < uliMemoryEndAddress;
			puliDestination++) {
		*puliDestination = uliXorshift32(&uliCurrentState);
		if ((bVerbose == DDR2_VERBOSE)
				& ((alt_u32) puliDestination > uliNextMilestone)) {

			printf("..%02d%%..", ucPercentage);

			uliNextMilestone += uliByteLen / 20;
			ucPercentage += 5;
		}
	}
	alt_dcache_flush_all();
	if (bVerbose == DDR2_VERBOSE) {

		printf("..100%%\n");

	}

	if (bSuccess) {
		if (bTime == TRUE) {
			TimeElapsed = alt_nticks() - TimeStart;

			printf("DDR2 write test pass, size=%ld bytes, %.3f sec\n",
					uliByteLen,
					(float) TimeElapsed / (float) alt_ticks_per_second());

		} else {

			printf("DDR2 write test pass, size=%ld bytes\n", uliByteLen);

		}
	} else {

		printf("DDR2 write test fail\n");

	}

	printf("\n");

	return bSuccess;
}

/**
 * @name    bDdr2MemoryRandomReadTest
 * @brief
 * @ingroup DDR2
 *
 * Teste de leitura da memória, baseados nos valores gerados por um RNG.
 *
 * @param [in] MemoryId  ID da mémoria a ser testada
 * @param [in] bVerbose  Controle o modo verbose da função
 * @param [in] bTime  Controla se a duração da função será medida
 *
 * @retval TRUE : Sucesso
 *
 */
bool bDdr2MemoryRandomReadTest(alt_u8 ucMemoryId, bool bVerbose, bool bTime) {

	printf("===== DE4 DDR2 Memory Random Read Test =====\n");

	bool bSuccess = FALSE;
	alt_u32 uliDdr2Base;
	alt_u32 uliByteLen;

	switch (ucMemoryId) {
	case DDR2_M1_ID:
		bDdr2SwitchMemory(ucMemoryId);
		uliDdr2Base = DDR2_EXT_ADDR_WINDOWED_BASE;
		uliByteLen = DDR2_M1_MEMORY_SIZE;
		bSuccess = TRUE;
		break;
	case DDR2_M2_ID:
		bDdr2SwitchMemory(ucMemoryId);
		uliDdr2Base = DDR2_EXT_ADDR_WINDOWED_BASE;
		uliByteLen = DDR2_M2_MEMORY_SIZE;
		bSuccess = TRUE;
		break;
	default:
		bSuccess = FALSE;

		printf("DR2 Memory ID not identified!! Aborting Test \n");

		return bSuccess;
	}

	printf("DDR2 Size: %ld MBytes\n", uliByteLen / 1024 / 1024);

	alt_u32 *puliSource;
	alt_u32 uliCurrentState;
	alt_u32 uliMemoryEndAddress;
	alt_u32 uliNextMilestone;
	alt_u8 ucPercentage;

	uliCurrentState = uliInitialState;
	uliMemoryEndAddress = uliDdr2Base + uliByteLen;
	uliNextMilestone = uliDdr2Base + uliByteLen / 20;
	ucPercentage = 5;

	printf("Reading from memory...\n");

	if (bVerbose == DDR2_VERBOSE) {

		printf("00%%..");

	}

	int TimeStart, TimeElapsed = 0;

	TimeStart = alt_nticks();
	for (puliSource = (alt_u32*) uliDdr2Base;
			(alt_u32) puliSource < uliMemoryEndAddress; puliSource++) {
		if (uliXorshift32(&uliCurrentState) != *puliSource) {
			bSuccess = FALSE;
			if (bVerbose == DDR2_VERBOSE) {

				printf("Failed to read adress 0x%08lX\n", (alt_u32) puliSource);

			}
		}
		if ((bVerbose == DDR2_VERBOSE)
				&& ((alt_u32) puliSource > uliNextMilestone)) {

			printf("..%02d%%..", ucPercentage);

			uliNextMilestone += uliByteLen / 20;
			ucPercentage += 5;
		}
	}
	if (bVerbose == DDR2_VERBOSE) {

		printf("..100%%\n");

	}

	if (bSuccess) {
		if (bTime == TRUE) {
			TimeElapsed = alt_nticks() - TimeStart;

			printf("DDR2 read test pass, size=%lu bytes, %.3f sec\n",
					uliByteLen,
					(float) TimeElapsed / (float) alt_ticks_per_second());

		} else {

			printf("DDR2 read test pass, size=%lu bytes\n", uliByteLen);

		}
	} else {

		printf("DDR2 read test fail\n");

	}

	printf("\n");

	return bSuccess;
}

/**
 * @name    uliXorshift32
 * @brief
 * @ingroup DDR2
 *
 * Helper function para gerar valores aleatórios para teste de memória (RNG)
 *
 * @param [in] bDRIVE  Estado atual do RNG
 *
 * @retval Número aleatório resultate do RNG
 *
 */
alt_u32 uliXorshift32(alt_u32 *puliState) {

	alt_u32 uliX = *puliState;
	uliX ^= uliX << 13;
	uliX ^= uliX >> 17;
	uliX ^= uliX << 5;
	*puliState = uliX;

	return uliX;
}
