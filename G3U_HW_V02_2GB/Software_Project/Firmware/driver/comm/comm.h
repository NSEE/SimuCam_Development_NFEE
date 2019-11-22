/*
 * comm.h
 *
 *  Created on: 18/12/2018
 *      Author: rfranca
 */

#ifndef COMM_H_
#define COMM_H_

#include "../../simucam_definitions.h"

//! [constants definition]
// irq numbers
#define COMM_CH_1_RMAP_IRQ              15
#define COMM_CH_1_BUFFERS_IRQ           5
#define COMM_CH_2_RMAP_IRQ              16
#define COMM_CH_2_BUFFERS_IRQ           6
#define COMM_CH_3_RMAP_IRQ              17
#define COMM_CH_3_BUFFERS_IRQ           7
#define COMM_CH_4_RMAP_IRQ              18
#define COMM_CH_4_BUFFERS_IRQ           8
#define COMM_CH_5_RMAP_IRQ              19
#define COMM_CH_5_BUFFERS_IRQ           9
#define COMM_CH_6_RMAP_IRQ              20
#define COMM_CH_6_BUFFERS_IRQ           10
#define COMM_CH_7_RMAP_IRQ              -1
#define COMM_CH_7_BUFFERS_IRQ           -1
#define COMM_CH_8_RMAP_IRQ              -1
#define COMM_CH_8_BUFFERS_IRQ           -1
// address
#define COMM_CHANNEL_1_BASE_ADDR        COMM_PEDREIRO_V1_01_A_BASE
#define COMM_CHANNEL_2_BASE_ADDR        COMM_PEDREIRO_V1_01_B_BASE
#define COMM_CHANNEL_3_BASE_ADDR        COMM_PEDREIRO_V1_01_C_BASE
#define COMM_CHANNEL_4_BASE_ADDR        COMM_PEDREIRO_V1_01_D_BASE
#define COMM_CHANNEL_5_BASE_ADDR        COMM_PEDREIRO_V1_01_E_BASE
#define COMM_CHANNEL_6_BASE_ADDR        COMM_PEDREIRO_V1_01_F_BASE
#define COMM_CHANNEL_7_BASE_ADDR        COMM_PEDREIRO_V1_01_A_BASE
#define COMM_CHANNEL_8_BASE_ADDR        COMM_PEDREIRO_V1_01_B_BASE
// offsets
#define COMM_RMAP_MEMAREA_CONFIG_OFST   0x00000080
#define COMM_RMAP_MEMAREA_HK_OFST       0x000000A7
// RMAP config addr
#define COMM_RMAP_CCD_SEQ_1_CFG_REG_OFST 0x40
#define COMM_RMAP_CCD_SEQ_2_CFG_REG_OFST 0x41
#define COMM_RMAP_SPW_PKT_1_CFG_REG_OFST 0x42
#define COMM_RMAP_SPW_PKT_2_CFG_REG_OFST 0x43
#define COMM_RMAP_CCD_1_W_1_CFG_REG_OFST 0x44
#define COMM_RMAP_CCD_1_W_2_CFG_REG_OFST 0x45
#define COMM_RMAP_CCD_2_W_1_CFG_REG_OFST 0x46
#define COMM_RMAP_CCD_2_W_2_CFG_REG_OFST 0x47
#define COMM_RMAP_CCD_3_W_1_CFG_REG_OFST 0x48
#define COMM_RMAP_CCD_3_W_2_CFG_REG_OFST 0x49
#define COMM_RMAP_CCD_4_W_1_CFG_REG_OFST 0x4A
#define COMM_RMAP_CCD_4_W_2_CFG_REG_OFST 0x4B
#define COMM_RMAP_OP_MODE_CFG_REG_OFST   0x4C
#define COMM_RMAP_SYNC_CFG_REG_OFST      0x4D
#define COMM_RMAP_DAC_CTRL_REG_OFST      0x4E
#define COMM_RMAP_CLK_SRCE_CTRL_REG_OFST 0x4F
#define COMM_RMAP_FRAME_NUMBER_REG_OFST  0x50
#define COMM_RMAP_CURRENT_MODE_REG_OFST  0x51
// rmap hk addr
#define COMM_RMAP_HK_0_REG_OFST          0xA0
#define COMM_RMAP_HK_1_REG_OFST          0xA1
#define COMM_RMAP_HK_2_REG_OFST          0xA2
#define COMM_RMAP_HK_3_REG_OFST          0xA3
#define COMM_RMAP_HK_4_REG_OFST          0xA4
#define COMM_RMAP_HK_5_REG_OFST          0xA5
#define COMM_RMAP_HK_6_REG_OFST          0xA6
#define COMM_RMAP_HK_7_REG_OFST          0xA7
#define COMM_RMAP_HK_8_REG_OFST          0xA8
#define COMM_RMAP_HK_9_REG_OFST          0xA9
#define COMM_RMAP_HK_10_REG_OFST         0xAA
#define COMM_RMAP_HK_11_REG_OFST         0xAB
#define COMM_RMAP_HK_12_REG_OFST         0xAC
#define COMM_RMAP_HK_13_REG_OFST         0xAD
#define COMM_RMAP_HK_14_REG_OFST         0xAE
#define COMM_RMAP_HK_15_REG_OFST         0xAF
#define COMM_RMAP_HK_16_REG_OFST         0xB0
#define COMM_RMAP_HK_17_REG_OFST         0xB1
#define COMM_RMAP_HK_18_REG_OFST         0xB2
#define COMM_RMAP_HK_19_REG_OFST         0xB3
#define COMM_RMAP_HK_20_REG_OFST         0xB4
#define COMM_RMAP_HK_21_REG_OFST         0xB5
#define COMM_RMAP_HK_22_REG_OFST         0xB6
#define COMM_RMAP_HK_23_REG_OFST         0xB7
#define COMM_RMAP_HK_24_REG_OFST         0xB8
#define COMM_RMAP_HK_25_REG_OFST         0xB9
#define COMM_RMAP_HK_26_REG_OFST         0xBA
#define COMM_RMAP_HK_27_REG_OFST         0xBB
#define COMM_RMAP_HK_28_REG_OFST         0xBC
#define COMM_RMAP_HK_29_REG_OFST         0xBD
#define COMM_RMAP_HK_30_REG_OFST         0xBE
#define COMM_RMAP_HK_31_REG_OFST         0xBF

// rmap config bit masks
#define COMM_RMAP_TRI_LV_CLK_CTRL_MSK    (1 << 1)
#define COMM_RMAP_IMGCLK_DIR_CTRL_MSK    (1 << 2)
#define COMM_RMAP_REGCLK_DIR_CTRL_MSK    (1 << 3)
#define COMM_RMAP_IMGCLK_TRCNT_CTRL_MSK  (0xFFFF << 4)
#define COMM_RMAP_REGCLK_TRCNT_CTRL_MSK  (0xFFF << 20)

#define COMM_RMAP_SL_RDOUT_PAUSE_CNT_MSK (0xFFFFF << 0)

#define COMM_RMAP_DIGITISE_CTRL_MSK      (1 << 1)
#define COMM_RMAP_CCD_DTRAN_SEL_CTRL_MSK (0b11 << 2)
#define COMM_RMAP_PACKET_SIZE_CTRL_MSK   (0xFFFF << 4)

#define COMM_RMAP_WLIST_P_IADDR_CCD1_MSK (0xFFFFFFFF << 0)

#define COMM_RMAP_WINDOW_WIDTH_CCD1_MSK  (0b111111 << 0)
#define COMM_RMAP_WINDOW_HEIGHT_CCD1_MSK (0b111111 << 6)
#define COMM_RMAP_WLIST_LENGTH_CCD1_MSK  (0xFFFF << 16)

#define COMM_RMAP_WLIST_P_IADDR_CCD2_MSK (0xFFFFFFFF << 0)

#define COMM_RMAP_WINDOW_WIDTH_CCD2_MSK  (0b111111 << 0)
#define COMM_RMAP_WINDOW_HEIGHT_CCD2_MSK (0b111111 << 6)
#define COMM_RMAP_WLIST_LENGTH_CCD2_MSK  (0xFFFF << 16)

#define COMM_RMAP_WLIST_P_IADDR_CCD3_MSK (0xFFFFFFFF << 0)

#define COMM_RMAP_WINDOW_WIDTH_CCD3_MSK  (0b111111 << 0)
#define COMM_RMAP_WINDOW_HEIGHT_CCD3_MSK (0b111111 << 6)
#define COMM_RMAP_WLIST_LENGTH_CCD3_MSK  (0xFFFF << 16)

#define COMM_RMAP_WLIST_P_IADDR_CCD4_MSK (0xFFFFFFFF << 0)

#define COMM_RMAP_WINDOW_WIDTH_CCD4_MSK  (0b111111 << 0)
#define COMM_RMAP_WINDOW_HEIGHT_CCD4_MSK (0b111111 << 6)
#define COMM_RMAP_WLIST_LENGTH_CCD4_MSK  (0xFFFF << 16)

#define COMM_RMAP_MODE_SEL_CTRL_MSK      (0xF << 4)

#define COMM_RMAP_SYNC_CFG_MSK           (0b11 << 0)
#define COMM_RMAP_SELF_TRIGGER_CTRL_MSK  (1 << 2)

#define COMM_RMAP_FRAME_NUMBER_MSK       (0b11 << 0)

#define COMM_RMAP_CURRENT_MODE_MSK       (0xF << 0)

// rmap hk bit masks
#define COMM_RMAP_HK_CCD1_VOD_E_MSK      (0xFFFF << 0)
#define COMM_RMAP_HK_CCD1_VOD_F_MSK      (0xFFFF << 16)
#define COMM_RMAP_HK_CCD1_VRD_MON_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_CCD2_VOD_E_MSK      (0xFFFF << 16)
#define COMM_RMAP_HK_CCD2_VOD_F_MSK      (0xFFFF << 0)
#define COMM_RMAP_HK_CCD2_VRD_MON_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_CCD3_VOD_E_MSK      (0xFFFF << 0)
#define COMM_RMAP_HK_CCD3_VOD_F_MSK      (0xFFFF << 16)
#define COMM_RMAP_HK_CCD3_VRD_MON_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_CCD4_VOD_E_MSK      (0xFFFF << 16)
#define COMM_RMAP_HK_CCD4_VOD_F_MSK      (0xFFFF << 0)
#define COMM_RMAP_HK_CCD4_VRD_MON_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_VCCD_MSK            (0xFFFF << 0)
#define COMM_RMAP_HK_VRCLK_MSK           (0xFFFF << 16)
#define COMM_RMAP_HK_VICLK_MSK           (0xFFFF << 0)
#define COMM_RMAP_HK_VRCLK_LOW_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_5VB_POS_MSK         (0xFFFF << 0)
#define COMM_RMAP_HK_5VB_NEG_MSK         (0xFFFF << 16)
#define COMM_RMAP_HK_3_3VB_POS_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_2_5VA_POS_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_3_3VD_POS_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_2_5VD_POS_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_1_5VD_POS_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_5VREF_MSK           (0xFFFF << 16)
#define COMM_RMAP_HK_VCCD_POS_RAW_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_VCLK_POS_RAW_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_VAN1_POS_RAW_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_VAN3_NEG_RAW_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_VAN2_POS_RAW_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_VDIG_FPGA_RAW_MSK   (0xFFFF << 16)
#define COMM_RMAP_HK_VDIG_SPW_RAW_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_VICLK_LOW_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_ADC_TEMP_A_E_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_ADC_TEMP_A_F_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_CCD1_TEMP_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_CCD2_TEMP_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_CCD3_TEMP_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_CCD4_TEMP_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_WP605_SPARE_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_0_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_1_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_2_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_3_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_4_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_5_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_6_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_7_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_8_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_9_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_10_MSK    (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_11_MSK    (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_12_MSK    (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_13_MSK    (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_14_MSK    (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_15_MSK    (0xFFFF << 0)
#define COMM_RMAP_SEL_HIRES_PRT0_MSK     (0xFFFF << 16)
#define COMM_RMAP_SEL_HIRES_PRT1_MSK     (0xFFFF << 0)
#define COMM_RMAP_SEL_HIRES_PRT2_MSK     (0xFFFF << 16)
#define COMM_RMAP_SEL_HIRES_PRT3_MSK     (0xFFFF << 0)
#define COMM_RMAP_SEL_HIRES_PRT4_MSK     (0xFFFF << 16)
#define COMM_RMAP_SEL_HIRES_PRT5_MSK     (0xFFFF << 0)
#define COMM_RMAP_SEL_HIRES_PRT6_MSK     (0xFFFF << 16)
#define COMM_RMAP_SEL_HIRES_PRT7_MSK     (0xFFFF << 0)
#define COMM_RMAP_ZERO_HIRES_AMP_MSK     (0xFFFF << 16)
//! [constants definition]

//! [public module structs definition]
enum CommBufferSide {
	eCommLeftBuffer = 0, eCommRightBuffer = 1
} ECommBufferSide;

enum CommSpwCh {
	eCommSpwCh1 = 0,
	eCommSpwCh2,
	eCommSpwCh3,
	eCommSpwCh4,
	eCommSpwCh5,
	eCommSpwCh6,
	eCommSpwCh7,
	eCommSpwCh8
} ECommSpwCh;

 /* Comm Device Address Register Struct */
typedef struct CommDevAddr {
  alt_u32 uliDevBaseAddr; /* Comm Device Base Address */
} TCommDevAddr;

 /* Comm IRQ Control Register Struct */
typedef struct CommIrqControl {
  bool bGlobalIrqEn; /* Comm Global IRQ Enable */
} TCommIrqControl;

 /* SpaceWire Device Address Register Struct */
typedef struct SpwcDevAddr {
  alt_u32 uliSpwcBaseAddr; /* SpaceWire Device Base Address */
} TSpwcDevAddr;

 /* SpaceWire Link Config Register Struct */
typedef struct SpwcLinkConfig {
  bool bDisconnect; /* SpaceWire Link Config Disconnect */
  bool bLinkStart; /* SpaceWire Link Config Linkstart */
  bool bAutostart; /* SpaceWire Link Config Autostart */
  alt_u8 ucTxDivCnt; /* SpaceWire Link Config TxDivCnt */
} TSpwcLinkConfig;

 /* SpaceWire Link Status Register Struct */
typedef struct SpwcLinkStatus {
  bool bRunning; /* SpaceWire Link Running */
  bool bConnecting; /* SpaceWire Link Connecting */
  bool bStarted; /* SpaceWire Link Started */
} TSpwcLinkStatus;

 /* SpaceWire Link Status Register Struct */
typedef struct SpwcLinkError {
  bool bDisconnect; /* SpaceWire Error Disconnect */
  bool bParity; /* SpaceWire Error Parity */
  bool bEscape; /* SpaceWire Error Escape */
  bool bCredit; /* SpaceWire Error Credit */
} TSpwcLinkError;

 /* SpaceWire Timecode Config Register Struct */
typedef struct SpwcTimecodeConfig {
  bool bClear; /* SpaceWire Timecode Clear */
  bool bEnable; /* SpaceWire Timecode Enable */
} TSpwcTimecodeConfig;

 /* SpaceWire Timecode Status Register Struct */
typedef struct SpwcTimecodeStatus {
  alt_u8 ucTime; /* SpaceWire Timecode Time */
  alt_u8 ucControl; /* SpaceWire Timecode Control */
} TSpwcTimecodeStatus;

 /* FEE Buffers Device Address Register Struct */
typedef struct FeebDevAddr {
  alt_u32 uliFeebBaseAddr; /* FEE Buffers Device Base Address */
} TFeebDevAddr;

 /* FEE Machine Config Register Struct */
typedef struct FeebMachineControl {
  bool bClear; /* FEE Machine Clear */
  bool bStop; /* FEE Machine Stop */
  bool bStart; /* FEE Machine Start */
  bool bDataControllerEn; /* FEE Data Controller Enable */
  bool bDigitaliseEn; /* FEE Digitalise Enable */
  bool bWindowingEn; /* FEE Windowing Enable */
} TFeebMachineControl;

 /* FEE Buffers Config Register Struct */
typedef struct FeebBufferStatus {
  alt_u8 ucRightBufferSize; /* Windowing Right Buffer Size Config */
  alt_u8 ucLeftBufferSize; /* Windowing Left Buffer Size Config */
  bool bRightBufferEmpty; /* Windowing Right Buffer Empty */
  bool bLeftBufferEmpty; /* Windowing Left Buffer Empty */
  bool bRightFeeBusy; /* FEE Right Machine Busy */
  bool bLeftFeeBusy; /* FEE Left Machine Busy */
} TFeebBufferStatus;

 /* FEE Buffers IRQ Control Register Struct */
typedef struct FeebIrqControl {
  bool bRightBufferEmptyEn; /* FEE Right Buffer Empty IRQ Enable */
  bool bLeftBufferEmptyEn; /* FEE Left Buffer Empty IRQ Enable */
} TFeebIrqControl;

 /* FEE Buffers IRQ Flags Register Struct */
typedef struct FeebIrqFlag {
  bool bRightBufferEmpty0Flag; /* FEE Right Buffer 0 Empty IRQ Flag */
  bool bRightBufferEmpty1Flag; /* FEE Right Buffer 1 Empty IRQ Flag */
  bool bLeftBufferEmpty0Flag; /* FEE Left Buffer 0 Empty IRQ Flag */
  bool bLeftBufferEmpty1Flag; /* FEE Left Buffer 1 Empty IRQ Flag */
} TFeebIrqFlag;

 /* FEE Buffers IRQ Flags Clear Register Struct */
typedef struct FeebIrqFlagClr {
  bool bRightBufferEmpty0FlagClr; /* FEE Right Buffer 0 Empty IRQ Flag Clear */
  bool bRightBufferEmpty1FlagClr; /* FEE Right Buffer 1 Empty IRQ Flag Clear */
  bool bLeftBufferEmpty0FlagClr; /* FEE Left Buffer 0 Empty IRQ Flag Clear */
  bool bLeftBufferEmpty1FlagClr; /* FEE Left Buffer 1 Empty IRQ Flag Clear */
} TFeebIrqFlagClr;

 /* FEE Buffers IRQ Number Register Struct */
typedef struct FeebIrqNumber {
  alt_u32 uliBuffersEmptyIrqId; /* FEE Buffers IRQ Number/ID */
} TFeebIrqNumber;

 /* RMAP Device Address Register Struct */
typedef struct RmapDevAddr {
  alt_u32 uliRmapBaseAddr; /* RMAP Device Base Address */
} TRmapDevAddr;

 /* RMAP Codec Config Register Struct */
typedef struct RmapCodecConfig {
  alt_u8 ucLogicalAddress; /* RMAP Target Logical Address */
  alt_u8 ucKey; /* RMAP Target Key */
} TRmapCodecConfig;

 /* RMAP Codec Status Register Struct */
typedef struct RmapCodecStatus {
  bool bCommandReceived; /* RMAP Status Command Received */
  bool bWriteRequested; /* RMAP Status Write Requested */
  bool bWriteAuthorized; /* RMAP Status Write Authorized */
  bool bReadRequested; /* RMAP Status Read Requested */
  bool bReadAuthorized; /* RMAP Status Read Authorized */
  bool bReplySended; /* RMAP Status Reply Sended */
  bool bDiscardedPackage; /* RMAP Status Discarded Package */
} TRmapCodecStatus;

 /* RMAP Codec Status Register Struct */
typedef struct RmapCodecError {
  bool bEarlyEop; /* RMAP Error Early EOP */
  bool bEep; /* RMAP Error EEP */
  bool bHeaderCRC; /* RMAP Error Header CRC */
  bool bUnusedPacketType; /* RMAP Error Unused Packet Type */
  bool bInvalidCommandCode; /* RMAP Error Invalid Command Code */
  bool bTooMuchData; /* RMAP Error Too Much Data */
  bool bInvalidDataCrc; /* RMAP Error Invalid Data CRC */
} TRmapCodecError;

 /* RMAP Memory Status Register Struct */
typedef struct RmapMemConfigStat {
  alt_u32 uliLastWriteAddress; /* RMAP Last Write Address */
  alt_u32 uliLastReadAddress; /* RMAP Last Read Address */
} TRmapMemConfigStat;

/* RMAP Memory Area Configuration Register Struct */
typedef struct RmapMemAreaConfig {
	alt_u16 usiVStart; /* V Start Config Field */
	alt_u16 usiVEnd; /* V End Config Field */
	alt_u16 usiChargeInjectionWidth; /* Charge Injection Width Config Field */
	alt_u16 usiChargeInjectionGap; /* Charge Injection Gap Config Field */
	alt_u16 usiParallelToiPeriod; /* Parallel Toi Period Config Field */
	alt_u16 usiParallelClkOverlap; /* Parallel Clock Overlap Config Field */
	alt_u8 ucCcdReadoutOrder1stCcd; /* CCD Readout Order Config Field (1st CCD) */
	alt_u8 ucCcdReadoutOrder2ndCcd; /* CCD Readout Order Config Field (2nd CCD) */
	alt_u8 ucCcdReadoutOrder3rdCcd; /* CCD Readout Order Config Field (3rd CCD) */
	alt_u8 ucCcdReadoutOrder4thCcd; /* CCD Readout Order Config Field (4th CCD) */
	alt_u16 usiNFinalDump; /* N Final Dump Config Field */
	alt_u16 usiHEnd; /* H End Config Field */
	bool bChargeInjectionEn; /* Charge Injection Enable Config Field */
	bool bTriLevelClkEn; /* Tri Level Clock Enable Config Field */
	bool bImgClkDir; /* Image Clock Direction Config Field */
	bool bRegClkDir; /* Register Clock Direction Config Field */
	alt_u16 usiPacketSize; /* Data Packet Size Config Field */
	alt_u16 usiIntSyncPeriod; /* Internal Sync Period Config Field */
	alt_u32 uliSlowReadoutPause; /* Slow Readout Pause Config Field */
	bool bSyncSel; /* Sync Source Selection Config Field */
	alt_u8 ucSensorSel; /* CCD Port Data Sensor Selection Config Field */
	bool bDigitiseEn; /* Digitalise Enable Config Field */
	alt_u8 ucReg5ConfigReserved; /* Register 5 Configuration Reserved */
	alt_u32 uliCcd1WinListPtr; /* CCD 1 Window List Pointer Config Field */
	alt_u32 uliCcd1PktorderListPtr; /* CCD 1 Packet Order List Pointer Config Field */
	alt_u16 usiCcd1WinListLength; /* CCD 1 Window List Length Config Field */
	alt_u8 ucCcd1WinSizeX; /* CCD 1 Window Size X Config Field */
	alt_u8 ucCcd1WinSizeY; /* CCD 1 Window Size Y Config Field */
	alt_u8 ucReg8ConfigReserved; /* Register 8 Configuration Reserved */
	alt_u32 uliCcd2WinListPtr; /* CCD 2 Window List Pointer Config Field */
	alt_u32 uliCcd2PktorderListPtr; /* CCD 2 Packet Order List Pointer Config Field */
	alt_u16 usiCcd2WinListLength; /* CCD 2 Window List Length Config Field */
	alt_u8 ucCcd2WinSizeX; /* CCD 2 Window Size X Config Field */
	alt_u8 ucCcd2WinSizeY; /* CCD 2 Window Size Y Config Field */
	alt_u8 ucReg11ConfigReserved; /* Register 11 Configuration Reserved */
	alt_u32 uliCcd3WinListPtr; /* CCD 3 Window List Pointer Config Field */
	alt_u32 uliCcd3PktorderListPtr; /* CCD 3 Packet Order List Pointer Config Field */
	alt_u16 usiCcd3WinListLength; /* CCD 3 Window List Length Config Field */
	alt_u8 ucCcd3WinSizeX; /* CCD 3 Window Size X Config Field */
	alt_u8 ucCcd3WinSizeY; /* CCD 3 Window Size Y Config Field */
	alt_u8 ucReg14ConfigReserved; /* Register 14 Configuration Reserved */
	alt_u32 uliCcd4WinListPtr; /* CCD 4 Window List Pointer Config Field */
	alt_u32 uliCcd4PktorderListPtr; /* CCD 4 Packet Order List Pointer Config Field */
	alt_u16 usiCcd4WinListLength; /* CCD 4 Window List Length Config Field */
	alt_u8 ucCcd4WinSizeX; /* CCD 4 Window Size X Config Field */
	alt_u8 ucCcd4WinSizeY; /* CCD 4 Window Size Y Config Field */
	alt_u8 ucReg17ConfigReserved; /* Register 17 Configuration Reserved */
	alt_u16 usiCcdVodConfig; /* CCD Vod Configuration Config Field */
	alt_u16 usiCcd1VrdConfig; /* CCD 1 Vrd Configuration Config Field */
	alt_u8 ucCcd2VrdConfig0; /* CCD 2 Vrd Configuration Config Field */
	alt_u8 ucCcd2VrdConfig1; /* CCD 2 Vrd Configuration Config Field */
	alt_u16 usiCcd3VrdConfig0; /* CCD 3 Vrd Configuration Config Field */
	alt_u16 usiCcd4VrdConfig1; /* CCD 4 Vrd Configuration Config Field */
	alt_u8 ucCcdVgdConfig0; /* CCD Vgd Configuration Config Field */
	alt_u8 ucCcdVgdConfig1; /* CCD Vgd Configuration Config Field */
	alt_u16 usiCcdVogConfig; /* CCD Vog Configurion Config Field */
	alt_u16 usiCcdIgHiConfig; /* CCD Ig High Configuration Config Field */
	alt_u16 usiCcdIgLoConfig; /* CCD Ig Low Configuration Config Field */
	alt_u16 usiHStart; /* H Start Config Field */
	alt_u8 ucCcdModeConfig; /* CCD Mode Configuration Config Field */
	alt_u8 ucReg21ConfigReserved; /* Register 21 Configuration Reserved */
	bool bClearErrorFlag; /* Clear Error Flag Config Field */
	alt_u32 uliReg22ConfigReserved; /* Register 22 Configuration Reserved */
	alt_u32 uliReg23ConfigReserved; /* Register 23 Configuration Reserved */
} TRmapMemAreaConfig;

 /* RMAP Memory Area Housekeeping Register Struct */
typedef struct RmapMemAreaHk {
	alt_u16 usiTouSense1; /* TOU Sense 1 HK Field */
	alt_u16 usiTouSense2; /* TOU Sense 2 HK Field */
	alt_u16 usiTouSense3; /* TOU Sense 3 HK Field */
	alt_u16 usiTouSense4; /* TOU Sense 4 HK Field */
	alt_u16 usiTouSense5; /* TOU Sense 5 HK Field */
	alt_u16 usiTouSense6; /* TOU Sense 6 HK Field */
	alt_u16 usiCcd1Ts; /* CCD 1 TS HK Field */
	alt_u16 usiCcd2Ts; /* CCD 2 TS HK Field */
	alt_u16 usiCcd3Ts; /* CCD 3 TS HK Field */
	alt_u16 usiCcd4Ts; /* CCD 4 TS HK Field */
	alt_u16 usiPrt1; /* PRT 1 HK Field */
	alt_u16 usiPrt2; /* PRT 2 HK Field */
	alt_u16 usiPrt3; /* PRT 3 HK Field */
	alt_u16 usiPrt4; /* PRT 4 HK Field */
	alt_u16 usiPrt5; /* PRT 5 HK Field */
	alt_u16 usiZeroDiffAmp; /* Zero Diff Amplifier HK Field */
	alt_u16 usiCcd1VodMon; /* CCD 1 Vod Monitor HK Field */
	alt_u16 usiCcd1VogMon; /* CCD 1 Vog Monitor HK Field */
	alt_u16 usiCcd1VrdMonE; /* CCD 1 Vrd Monitor E HK Field */
	alt_u16 usiCcd2VodMon; /* CCD 2 Vod Monitor HK Field */
	alt_u16 usiCcd2VogMon; /* CCD 2 Vog Monitor HK Field */
	alt_u16 usiCcd2VrdMonE; /* CCD 2 Vrd Monitor E HK Field */
	alt_u16 usiCcd3VodMon; /* CCD 3 Vod Monitor HK Field */
	alt_u16 usiCcd3VogMon; /* CCD 3 Vog Monitor HK Field */
	alt_u16 usiCcd3VrdMonE; /* CCD 3 Vrd Monitor E HK Field */
	alt_u16 usiCcd4VodMon; /* CCD 4 Vod Monitor HK Field */
	alt_u16 usiCcd4VogMon; /* CCD 4 Vog Monitor HK Field */
	alt_u16 usiCcd4VrdMonE; /* CCD 4 Vrd Monitor E HK Field */
	alt_u16 usiVccd; /* V CCD HK Field */
	alt_u16 usiVrclkMon; /* VRClock Monitor HK Field */
	alt_u16 usiViclk; /* VIClock HK Field */
	alt_u16 usiVrclkLow; /* VRClock Low HK Field */
	alt_u16 usi5vbPosMon; /* 5Vb Positive Monitor HK Field */
	alt_u16 usi5vbNegMon; /* 5Vb Negative Monitor HK Field */
	alt_u16 usi3v3bMon; /* 3V3b Monitor HK Field */
	alt_u16 usi2v5aMon; /* 2V5a Monitor HK Field */
	alt_u16 usi3v3dMon; /* 3V3d Monitor HK Field */
	alt_u16 usi2v5dMon; /* 2V5d Monitor HK Field */
	alt_u16 usi1v5dMon; /* 1V5d Monitor HK Field */
	alt_u16 usi5vrefMon; /* 5Vref Monitor HK Field */
	alt_u16 usiVccdPosRaw; /* Vccd Positive Raw HK Field */
	alt_u16 usiVclkPosRaw; /* Vclk Positive Raw HK Field */
	alt_u16 usiVan1PosRaw; /* Van 1 Positive Raw HK Field */
	alt_u16 usiVan3NegMon; /* Van 3 Negative Monitor HK Field */
	alt_u16 usiVan2PosRaw; /* Van Positive Raw HK Field */
	alt_u16 usiVdigRaw; /* Vdig Raw HK Field */
	alt_u16 usiVdigRaw2; /* Vdig Raw 2 HK Field */
	alt_u16 usiViclkLow; /* VIClock Low HK Field */
	alt_u16 usiCcd1VrdMonF; /* CCD 1 Vrd Monitor F HK Field */
	alt_u16 usiCcd1VddMon; /* CCD 1 Vdd Monitor HK Field */
	alt_u16 usiCcd1VgdMon; /* CCD 1 Vgd Monitor HK Field */
	alt_u16 usiCcd2VrdMonF; /* CCD 2 Vrd Monitor F HK Field */
	alt_u16 usiCcd2VddMon; /* CCD 2 Vdd Monitor HK Field */
	alt_u16 usiCcd2VgdMon; /* CCD 2 Vgd Monitor HK Field */
	alt_u16 usiCcd3VrdMonF; /* CCD 3 Vrd Monitor F HK Field */
	alt_u16 usiCcd3VddMon; /* CCD 3 Vdd Monitor HK Field */
	alt_u16 usiCcd3VgdMon; /* CCD 3 Vgd Monitor HK Field */
	alt_u16 usiCcd4VrdMonF; /* CCD 4 Vrd Monitor F HK Field */
	alt_u16 usiCcd4VddMon; /* CCD 4 Vdd Monitor HK Field */
	alt_u16 usiCcd4VgdMon; /* CCD 4 Vgd Monitor HK Field */
	alt_u16 usiIgHiMon; /* Ig High Monitor HK Field */
	alt_u16 usiIgLoMon; /* Ig Low Monitor HK Field */
	alt_u16 usiTsenseA; /* Tsense A HK Field */
	alt_u16 usiTsenseB; /* Tsense B HK Field */
	alt_u8 ucSpwStatusSpwStatusReserved; /* SpW Status : SpaceWire Status Reserved */
	alt_u8 ucReg32HkReserved; /* Register 32 HK Reserved */
	alt_u8 ucSpwStatusTimecodeFromSpw; /* SpW Status : Timecode From SpaceWire HK Field */
	alt_u8 ucSpwStatusRmapTargetStatus; /* SpW Status : RMAP Target Status HK Field */
	bool bSpwStatusRmapTargetIndicate; /* SpW Status : RMAP Target Indicate HK Field */
	bool bSpwStatusStatLinkEscapeError; /* SpW Status : Status Link Escape Error HK Field */
	bool bSpwStatusStatLinkCreditError; /* SpW Status : Status Link Credit Error HK Field */
	bool bSpwStatusStatLinkParityError; /* SpW Status : Status Link Parity Error HK Field */
	bool bSpwStatusStatLinkDisconnect; /* SpW Status : Status Link Disconnect HK Field */
	bool bSpwStatusStatLinkRunning; /* SpW Status : Status Link Running HK Field */
	alt_u8 ucOpMode; /* Operational Mode HK Field */
	alt_u16 usiReg33HkReserved; /* Register 33 HK Reserved */
	alt_u16 usiFrameCounter; /* Frame Counter HK Field */
	alt_u8 ucFrameNumber; /* Frame Number HK Field */
	alt_u32 uliErrorFlagsErrorFlagsReserved; /* Error Flags : Error Flags Reserved */
	bool bErrorFlagsFSidePixelExternalSramBufferIsFull; /* Error Flags : F Side Pixel External SRAM Buffer is Full HK Field */
	bool bErrorFlagsESidePixelExternalSramBufferIsFull; /* Error Flags : E Side Pixel External SRAM Buffer is Full HK Field */
	bool bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongYCoordinate; /* Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong Y Coordinate HK Field */
	bool bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongXCoordinate; /* Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong X Coordinate HK Field */
	bool bErrorFlagsSpacewireStatLinkParityError; /* Error Flags : SpaceWire Status Link Parity Error HK Field */
	bool bErrorFlagsSpacewireStatLinkCreditError; /* Error Flags : SpaceWire Status Link Credit Error HK Field */
	bool bErrorFlagsSpacewireStatLinkEscapeError; /* Error Flags : SpaceWire Status Link Escape Error HK Field */
	alt_u32 uliReg35HkReserved; /* Register 35 HK Reserved HK Field */
} TRmapMemAreaHk;

 /* RMAP Memory Area Address Register Struct */
typedef struct RmapMemAreaAddr {
  TRmapMemAreaConfig *puliConfigAreaBaseAddr; /* RMAP Config Memory Area Base Address */
  TRmapMemAreaHk *puliHkAreaBaseAddr; /* RMAP HouseKeeping Memory Area Base Address */
} TRmapMemAreaAddr;

 /* RMAP IRQ Control Register Struct */
typedef struct RmapIrqControl {
  bool bWriteCmdEn; /* RMAP Write Command IRQ Enable */
} TRmapIrqControl;

 /* RMAP IRQ Flags Register Struct */
typedef struct RmapIrqFlag {
  bool bWriteCmdFlag; /* RMAP Write Command IRQ Flag */
} TRmapIrqFlag;

 /* RMAP IRQ Flags Clear Register Struct */
typedef struct RmapIrqFlagClr {
  bool bWriteCmdFlagClr; /* RMAP Write Command IRQ Flag Clear */
} TRmapIrqFlagClr;

 /* RMAP IRQ Number Register Struct */
typedef struct RmapIrqNumber {
  alt_u32 uliWriteCmdIrqId; /* RMAP IRQ Number/ID */
} TRmapIrqNumber;

 /* Data Packet Device Channel Address Register Struct */
typedef struct DpktDevAddr {
  alt_u32 uliDpktBaseAddr; /* Data Packet Device Base Address */
} TDpktDevAddr;

 /* Data Packet Config Register Struct */
typedef struct DpktDataPacketConfig {
  alt_u16 usiCcdXSize; /* Data Packet CCD X Size */
  alt_u16 usiCcdYSize; /* Data Packet CCD Y Size */
  alt_u16 usiDataYSize; /* Data Packet Data Y Size */
  alt_u16 usiOverscanYSize; /* Data Packet Overscan Y Size */
  alt_u16 usiPacketLength; /* Data Packet Packet Length */
  alt_u8 ucLogicalAddr; /* Data Packet Logical Address */
  alt_u8 ucProtocolId; /* Data Packet Protocol ID */
  alt_u8 ucFeeMode; /* Data Packet FEE Mode */
  alt_u8 ucCcdNumber; /* Data Packet CCD Number */
} TDpktDataPacketConfig;

 /* Data Packet Header Register Struct */
typedef struct DpktDataPacketHeader {
  alt_u16 usiLength; /* Data Packet Header Length */
  alt_u16 usiType; /* Data Packet Header Type */
  alt_u16 usiFrameCounter; /* Data Packet Header Frame Counter */
  alt_u16 usiSequenceCounter; /* Data Packet Header Sequence Counter */
} TDpktDataPacketHeader;

 /* Data Packet Pixel Delay Register Struct */
typedef struct DpktPixelDelay {
  alt_u16 usiLineDelay; /* Data Packet Line Delay */
  alt_u16 usiColumnDelay; /* Data Packet Column Delay */
  alt_u16 usiAdcDelay; /* Data Packet ADC Delay */
} TDpktPixelDelay;

 /* Error Injection Control Register Struct */
typedef struct DpktErrorInjection {
  bool bTxDisabled; /* Error Injection Tx Disabled Enable */
  bool bMissingPkts; /* Error Injection Missing Packets Enable */
  bool bMissingData; /* Error Injection Missing Data Enable */
  alt_u8 ucFrameNum; /* Error Injection Frame Number of Error */
  alt_u16 usiSequenceCnt; /* Error Injection Sequence Counter of Error */
  alt_u16 usiDataCnt; /* Error Injection Data Counter of Error */
  alt_u16 usiNRepeat; /* Error Injection Number of Error Repeats */
} TDpktErrorInjection;

/* General Struct for RMAP Memory Area Registers Access */
typedef struct RmapMemArea {
	TRmapMemAreaConfig xRmapMemAreaConfig;
	TRmapMemAreaHk xRmapMemAreaHk;
} TRmapMemArea;

/* General Struct for SpaceWire Codec Registers Access */
typedef struct SpwcChannel {
	TSpwcDevAddr xSpwcDevAddr;
	TSpwcLinkConfig xSpwcLinkConfig;
	TSpwcLinkStatus xSpwcLinkStatus;
	TSpwcLinkError xSpwcLinkError;
	TSpwcTimecodeConfig xSpwcTimecodeConfig;
	TSpwcTimecodeStatus xSpwcTimecodeStatus;
} TSpwcChannel;

/* General Struct for FEE Buffers Registers Access */
typedef struct FeebChannel {
	TFeebDevAddr xFeebDevAddr;
	TFeebMachineControl xFeebMachineControl;
	TFeebBufferStatus xFeebBufferStatus;
	TFeebIrqControl xFeebIrqControl;
	TFeebIrqFlag xFeebIrqFlag;
	TFeebIrqFlagClr xFeebIrqFlagClr;
	TFeebIrqNumber xFeebIrqNumber;
} TFeebChannel;

/* General Struct for RMAP Codec Registers Access */
typedef struct RmapChannel {
	TRmapDevAddr xRmapDevAddr;
	TRmapCodecConfig xRmapCodecConfig;
	TRmapCodecStatus xRmapCodecStatus;
	TRmapCodecError xRmapCodecError;
	TRmapMemConfigStat xRmapMemConfigStat;
	TRmapMemAreaAddr xRmapMemAreaAddr;
	TRmapIrqControl xRmapIrqControl;
	TRmapIrqFlag xRmapIrqFlag;
	TRmapIrqFlagClr xRmapIrqFlagClr;
	TRmapIrqNumber xRmapIrqNumber;
} TRmapChannel;

 /* General Struct for Data Packet Registers Access */
typedef struct DpktChannel {
	TDpktDevAddr xDpktDevAddr;
	TDpktDataPacketConfig xDpktDataPacketConfig;
	TDpktDataPacketHeader xDpktDataPacketHeader;
	TDpktPixelDelay xDpktPixelDelay;
	TDpktErrorInjection xDpktErrorInjection;
} TDpktChannel;

 /* General Struct for Communication Module Registers Access */
typedef struct CommChannel {
	TCommDevAddr xCommDevAddr;
	TCommIrqControl xCommIrqControl;
	TSpwcChannel xSpacewire;
	TFeebChannel xFeeBuffer;
	TRmapChannel xRmap;
	TDpktChannel xDataPacket;
} TCommChannel;

//! [public module structs definition]

//! [public function prototypes]
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* COMM_H_ */
