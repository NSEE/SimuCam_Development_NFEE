/*
 * fee_task.c
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */


#include "fee_task.h"



void vFeeTask(void *task_data) {
	bool bSuccess = FALSE;
	TNFee *pxNFee;
	INT8U error_code;

	pxNFee = ( TNFee * ) task_data;

	#ifdef DEBUG_ON
		fprintf(fp,"NFEE %hhu Task. (Task on)\n", pxNFee->ucId);
	#endif

	#ifdef DEBUG_ON
		vPrintUARTNFee( pxNFee );
	#endif


	for(;;){
		break; /*todo:Tirar depois do debug*/
		/* Simular N itera��es para verificar os endere�os de mem�ria */
	}


	// Load default configurations CCD e FEE
	// carregar valores baseado no *task_data



	// IMplementar maquina de estados para o NFEE

	// LOOP
		// assim que tiver disponivel, agendar dma para buffer (transmissão)

		// Verificar se existe comando pus e realizar alterações

		// verificar se existe comando vindo do SPW

		// precisa mudar de estado?
			// em modo de emergencia ou apenas no sync?

		// Check sync ?
			// mudar de estado se isso estiver agendado


}

#ifdef DEBUG_ON
	void vPrintConsoleNFee( TNFee *pxNFeeI ) {
		TNFee *pxNFee;

		pxNFee = pxNFeeI;

		fprintf(fp,"=================================NFEE %hhu=====================================\n", pxNFee->ucId);
		fprintf(fp,"\n");
		fprintf(fp,"NFEE %hhu CCD infos: \n", pxNFee->ucId);
		fprintf(fp,"    PreScan = %hu \n", pxNFee->xCcdInfo.usiSPrescanN);
		fprintf(fp,"    OverScan = %hu \n", pxNFee->xCcdInfo.usiSOverscanN);
		fprintf(fp,"    OLN = %hu \n", pxNFee->xCcdInfo.usiOLN);
		fprintf(fp,"    Half Width = %hu \n", pxNFee->xCcdInfo.usiHalfWidth);
		fprintf(fp,"    Height = %hu \n", pxNFee->xCcdInfo.usiHeight);
		fprintf(fp,"\n");
		fprintf(fp,"NFEE %hhu Control: \n", pxNFee->ucId);
		fprintf(fp,"    NFEE State 	= %hu \n", pxNFee->xControl.eMode);
		fprintf(fp,"    NFEE Enable? = %hu \n", pxNFee->xControl.bEnabled);
		fprintf(fp,"    Using DMA?   = %hu \n", pxNFee->xControl.bUsingDMA);
		fprintf(fp,"    Logging?     = %hu \n", pxNFee->xControl.bLogging);
		fprintf(fp,"    Echoing?     = %hu \n", pxNFee->xControl.bEchoing);
		fprintf(fp,"    Channel Enable? = %hu \n", pxNFee->xControl.bChannelEnable);
		fprintf(fp,"    Readout order = [ %hhu , %hhu , %hhu , %hhu ] \n", pxNFee->xControl.ucROutOrder[0], pxNFee->xControl.ucROutOrder[1], pxNFee->xControl.ucROutOrder[2], pxNFee->xControl.ucROutOrder[3]);
		fprintf(fp,"    CCD Side = = %hu \n", pxNFee->xControl.eSide);
		fprintf(fp,"\n\n");
		fprintf(fp,"NFEE %hhu MEMORY MAP: \n", pxNFee->ucId);
		fprintf(fp,"    General Info: \n");
		fprintf(fp,"        Offset root 	= %lu \n", pxNFee->xMemMap.ulOffsetRoot);
		fprintf(fp,"        Total Bytes 	= %lu \n", pxNFee->xMemMap.ulTotalBytes);
		fprintf(fp,"        LUT ADDR 	= %lu \n", pxNFee->xMemMap.ulLUTAddr);
		fprintf(fp,"    Common to all CCDs: \n");
		fprintf(fp,"        Total Bytes 	= %hu \n", pxNFee->xMemMap.xCommon.usiTotalBytes);
		fprintf(fp,"        Total of Blocks = %hu \n", pxNFee->xMemMap.xCommon.usiNTotalBlocks);
		fprintf(fp,"        Padding Bytes 	= %hhu\n", pxNFee->xMemMap.xCommon.ucPaddingBytes);
		fprintf(fp,"        Padding MASK 	= %llu\n", pxNFee->xMemMap.xCommon.ucPaddingMask.ullWord);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 0 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 1 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 2 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 3 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"==============================================================================\n");
		fprintf(fp,"==============================================================================\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
	}
#endif


#ifdef DEBUG_ON
	void vPrintUARTNFee( TNFee *pxNFeeI ) {
		TNFee *pxNFee;

		pxNFee = pxNFeeI;

		printf("=================================NFEE %hhu=====================================\n", pxNFee->ucId);
		printf("\n");
		printf("NFEE %hhu CCD infos: \n", pxNFee->ucId);
		printf("    PreScan = %hu \n", pxNFee->xCcdInfo.usiSPrescanN);
		printf("    OverScan = %hu \n", pxNFee->xCcdInfo.usiSOverscanN);
		printf("    OLN = %hu \n", pxNFee->xCcdInfo.usiOLN);
		printf("    Half Width = %hu \n", pxNFee->xCcdInfo.usiHalfWidth);
		printf("    Height = %hu \n", pxNFee->xCcdInfo.usiHeight);
		printf("\n");
		printf("NFEE %hhu Control: \n", pxNFee->ucId);
		printf("    NFEE State 	= %hu \n", pxNFee->xControl.eMode);
		printf("    NFEE Enable? = %hu \n", pxNFee->xControl.bEnabled);
		printf("    Using DMA?   = %hu \n", pxNFee->xControl.bUsingDMA);
		printf("    Logging?     = %hu \n", pxNFee->xControl.bLogging);
		printf("    Echoing?     = %hu \n", pxNFee->xControl.bEchoing);
		printf("    Channel Enable? = %hu \n", pxNFee->xControl.bChannelEnable);
		printf("    Readout order = [ %hhu , %hhu , %hhu , %hhu ] \n", pxNFee->xControl.ucROutOrder[0], pxNFee->xControl.ucROutOrder[1], pxNFee->xControl.ucROutOrder[2], pxNFee->xControl.ucROutOrder[3]);
		printf("    CCD Side = = %hu \n", pxNFee->xControl.eSide);
		printf("\n\n");
		printf("NFEE %hhu MEMORY MAP: \n", pxNFee->ucId);
		printf("    General Info: \n");
		printf("        Offset root 	= %lu \n", pxNFee->xMemMap.ulOffsetRoot);
		printf("        Total Bytes 	= %lu \n", pxNFee->xMemMap.ulTotalBytes);
		printf("        LUT ADDR 	= %lu \n", pxNFee->xMemMap.ulLUTAddr);
		printf("    Common to all CCDs: \n");
		printf("        Total Bytes 	= %hu \n", pxNFee->xMemMap.xCommon.usiTotalBytes);
		printf("        Total of Blocks = %hu \n", pxNFee->xMemMap.xCommon.usiNTotalBlocks);
		printf("        Padding Bytes 	= %hhu\n", pxNFee->xMemMap.xCommon.ucPaddingBytes);
		printf("        Padding MASK 	= %llu\n", pxNFee->xMemMap.xCommon.ucPaddingMask.ullWord);
		printf("\n");
		printf("    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 0 , pxNFee->ucId);
		printf("        Left side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulAddrI);
		printf("        Right side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulAddrI);
		printf("\n");
		printf("    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 1 , pxNFee->ucId);
		printf("        Left side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulAddrI);
		printf("        Right side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulAddrI);
		printf("\n");
		printf("    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 2 , pxNFee->ucId);
		printf("        Left side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulAddrI);
		printf("        Right side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulAddrI);
		printf("\n");
		printf("    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 3 , pxNFee->ucId);
		printf("        Left side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulAddrI);
		printf("        Right side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulAddrI);
		printf("\n");
		printf("==============================================================================\n");
		printf("==============================================================================\n");
		printf("\n");
		printf("\n");
		printf("\n");
		printf("\n");
	}
#endif

