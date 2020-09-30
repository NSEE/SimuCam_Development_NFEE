/*
 * data_packet.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "data_packet.h"

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
bool bDpktSetPacketConfig(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktDataPacketConfig = pxDpktCh->xDpktDataPacketConfig;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktGetPacketConfig(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketConfig = vpxCommChannel->xDataPacket.xDpktDataPacketConfig;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktSetPacketErrors(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktDataPacketErrors = pxDpktCh->xDpktDataPacketErrors;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktGetPacketErrors(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketErrors = vpxCommChannel->xDataPacket.xDpktDataPacketErrors;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktGetPacketHeader(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketHeader = vpxCommChannel->xDataPacket.xDpktDataPacketHeader;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktSetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktPixelDelay = pxDpktCh->xDpktPixelDelay;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDpktGetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktPixelDelay = vpxCommChannel->xDataPacket.xDpktPixelDelay;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktSetSpacewireErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktSpacewireErrInj = pxDpktCh->xDpktSpacewireErrInj;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDpktGetSpacewireErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktSpacewireErrInj = vpxCommChannel->xDataPacket.xDpktSpacewireErrInj;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktSetSpwCodecErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktSpwCodecErrInj = pxDpktCh->xDpktSpwCodecErrInj;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDpktGetSpwCodecErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktSpwCodecErrInj = vpxCommChannel->xDataPacket.xDpktSpwCodecErrInj;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktSetRmapErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktRmapErrInj = pxDpktCh->xDpktRmapErrInj;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDpktGetRmapErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktRmapErrInj = vpxCommChannel->xDataPacket.xDpktRmapErrInj;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktSetTransmissionErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktTransmissionErrInj = pxDpktCh->xDpktTransmissionErrInj;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDpktGetTransmissionErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktTransmissionErrInj = vpxCommChannel->xDataPacket.xDpktTransmissionErrInj;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktSetLeftContentErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktLeftContentErrInj = pxDpktCh->xDpktLeftContentErrInj;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDpktGetLeftContentErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktLeftContentErrInj = vpxCommChannel->xDataPacket.xDpktLeftContentErrInj;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktSetRightContentErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktRightContentErrInj = pxDpktCh->xDpktRightContentErrInj;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDpktGetRightContentErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktRightContentErrInj = vpxCommChannel->xDataPacket.xDpktRightContentErrInj;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktContentErrInjClearEntries(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bInjecting) {
			vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bStopInj = TRUE;
		} else if (vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bRecording) {
			vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bCloseList = TRUE;
		}

		if (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bInjecting) {
			vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bStopInj = TRUE;
		} else if (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bRecording) {
			vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bCloseList = TRUE;
		}

		while (!(vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bIdle) && (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bIdle)) {}

		vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bClearList = TRUE;
		vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bClearList = TRUE;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktContentErrInjOpenList(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bInjecting) {
			vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bStopInj = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bIdle) {}
		}

		if (vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bIdle) {
			vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bOpenList = TRUE;

		}

		if (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bInjecting) {
			vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bStopInj = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bIdle) {}
		}

		if (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bIdle) {
			vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bOpenList = TRUE;

		}

		while (!(vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bRecording) && (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bRecording)) {}

		bStatus = TRUE;

	}

	return (bStatus);
}

alt_u8 ucDpktContentErrInjAddEntry(TDpktChannel *pxDpktCh, alt_u8 ucCcdSide, alt_u16 usiStartFrame, alt_u16 usiStopFrame, alt_u16 usiPxColX, alt_u16 usiPxRowY, alt_u16 usiPxValue) {
	alt_u8 ucEntries = 0;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		switch (ucCcdSide) {
			case eDpktCcdSideE:
				if (vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bRecording) {

					vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.usiStartFrame = usiStartFrame;
					vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.usiStopFrame  = usiStopFrame ;
					vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.usiPxColX     = usiPxColX    ;
					vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.usiPxRowY     = usiPxRowY    ;
					vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.usiPxValue    = usiPxValue   ;

					vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bWriteList = TRUE;

					usleep(10);

					ucEntries = vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.ucErrorsCnt;

				}
				break;
			case eDpktCcdSideF:
				if (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bRecording) {

					vpxCommChannel->xDataPacket.xDpktRightContentErrInj.usiStartFrame = usiStartFrame;
					vpxCommChannel->xDataPacket.xDpktRightContentErrInj.usiStopFrame  = usiStopFrame ;
					vpxCommChannel->xDataPacket.xDpktRightContentErrInj.usiPxColX     = usiPxColX    ;
					vpxCommChannel->xDataPacket.xDpktRightContentErrInj.usiPxRowY     = usiPxRowY    ;
					vpxCommChannel->xDataPacket.xDpktRightContentErrInj.usiPxValue    = usiPxValue   ;

					vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bWriteList = TRUE;

					usleep(10);

					ucEntries = vpxCommChannel->xDataPacket.xDpktRightContentErrInj.ucErrorsCnt;

				}
				break;
			default:
				ucEntries = 0;
				break;
		}

	}

	return (ucEntries);
}

bool bDpktContentErrInjCloseList(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	bool bLeftStatus = FALSE;
	bool bRightStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bRecording) {
			vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bCloseList = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bIdle) {}

			bLeftStatus = TRUE;
		}

		if (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bRecording) {
			vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bCloseList = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bIdle) {}

			bRightStatus = TRUE;
		}

		if ((bLeftStatus) && (bRightStatus)) {
			bStatus = TRUE;
		}

	}

	return (bStatus);
}

bool bDpktContentErrInjStartInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bRecording) {
			vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bCloseList = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bIdle) {}
		}

		if (vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bIdle) {
			vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bStartInj = TRUE;

		}

		if (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bRecording) {
			vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bCloseList = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bIdle) {}
		}

		if (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bIdle) {
			vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bStartInj = TRUE;

		}

		while (!(vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bInjecting) && (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bInjecting)) {}

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktContentErrInjStopInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	bool bLeftStatus = FALSE;
	bool bRightStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bInjecting) {
			vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bStopInj = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktLeftContentErrInj.bIdle) {}

			bLeftStatus = TRUE;
		}

		if (vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bInjecting) {
			vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bStopInj = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktRightContentErrInj.bIdle) {}

			bRightStatus = TRUE;
		}

		if ((bLeftStatus) && (bRightStatus)) {
			bStatus = TRUE;
		}

	}

	return (bStatus);
}

bool bDpktSetHeaderErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktHeaderErrInj = pxDpktCh->xDpktHeaderErrInj;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDpktGetHeaderErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktHeaderErrInj = vpxCommChannel->xDataPacket.xDpktHeaderErrInj;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktHeaderErrInjClearEntries(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bInjecting) {
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bStopInj = TRUE;
		} else if (vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bRecording) {
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bCloseList = TRUE;
		}

		while (!vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bIdle) {}

		vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bClearList = TRUE;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktHeaderErrInjOpenList(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bInjecting) {
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bStopInj = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bIdle) {}
		}

		if (vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bIdle) {
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bOpenList = TRUE;

		}

		while (!vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bRecording) {}

		bStatus = TRUE;

	}

	return (bStatus);
}

alt_u8 ucDpktHeaderErrInjAddEntry(TDpktChannel *pxDpktCh, alt_u8 ucFrameNum, alt_u16 usiSequenceCnt, alt_u8 ucFieldId, alt_u16 usiFieldValue) {
	alt_u8 ucEntries = 0;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bRecording) {

			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.ucFrameNum     = ucFrameNum    ;
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.usiSequenceCnt = usiSequenceCnt;
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.ucFieldId      = ucFieldId     ;
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.usiValue       = usiFieldValue ;

			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bWriteList = TRUE;

			usleep(10);

			ucEntries = vpxCommChannel->xDataPacket.xDpktHeaderErrInj.ucErrorsCnt;

		}

	}

	return (ucEntries);
}

bool bDpktHeaderErrInjCloseList(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bRecording) {
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bCloseList = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bIdle) {}

			bStatus = TRUE;
		}

	}

	return (bStatus);
}


bool bDpktHeaderErrInjStartInj(TDpktChannel *pxDpktCh){
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bRecording) {
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bCloseList = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bIdle) {}
		}

		if (vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bIdle) {
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bStartInj = TRUE;

		}

		while (!vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bInjecting) {}

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktHeaderErrInjStopInj(TDpktChannel *pxDpktCh){
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		if (vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bInjecting) {
			vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bStopInj = TRUE;

			while (!vpxCommChannel->xDataPacket.xDpktHeaderErrInj.bIdle) {}

			bStatus = TRUE;
		}

	}

	return (bStatus);
}

bool bDpktSetWindowingParams(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktWindowingParam = pxDpktCh->xDpktWindowingParam;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDpktGetWindowingParams(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktWindowingParam = vpxCommChannel->xDataPacket.xDpktWindowingParam;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bDpktInitCh(TDpktChannel *pxDpktCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bDpktGetPacketConfig(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPacketErrors(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPacketHeader(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPixelDelay(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetSpacewireErrInj(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetSpwCodecErrInj(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetRmapErrInj(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetTransmissionErrInj(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetLeftContentErrInj(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetRightContentErrInj(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetHeaderErrInj(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetWindowingParams(pxDpktCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return (bStatus);
}

/*
 * Return the necessary delay value for a
 * Pixel Delay period in uliPeriodNs ns.
 */
alt_u32 uliPxDelayCalcPeriodNs(alt_u32 uliPeriodNs) {

	/*
	 * Delay = PxDelay * ClkCycles@100MHz
	 * PxDelay = Delay / ClkCycles@100MHz
	 *
	 * ClkCycles@100MHz = 10 ns
	 *
	 * Delay[ns] / 10 = Delay[ns] * 1e-1
	 * PxDelay = Delay[ns] * 1e-1
	 */

	alt_u32 uliPxDelay;
	//    uliPxDelay = (alt_u32) ((float) uliPeriodNs * 1e-1);
	uliPxDelay = (alt_u32) (uliPeriodNs / (alt_u32) 10);

	return uliPxDelay;
}

alt_u32 uliPxDelayCalcPeriodMs(alt_u32 uliPeriodMs) {

	/*
	 * Delay = PxDelay * ClkCycles@100MHz
	 * PxDelay = Delay / ClkCycles@100MHz
	 *
	 * ClkCycles@100MHz = 10 ns = 1e-5 ms
	 *
	 * Delay[ms] / 1e-5 = Delay[ms] * 1e+5
	 * PxDelay = Delay[ms] * 1e+5
	 */

	alt_u32 uliPxDelay;
	//    uliPxDelay = (alt_u32) ((float) uliPeriodMs * 1e+5);
	uliPxDelay = (alt_u32) (uliPeriodMs * (alt_u32) 100000);

	return uliPxDelay;
}

//! [public functions]

//! [private functions]
//! [private functions]
