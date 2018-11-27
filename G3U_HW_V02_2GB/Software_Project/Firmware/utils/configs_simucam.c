/*
 * configs_simucam.c
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */


#include "configs_simucam.h"


/*Configuration related to the eth connection*/
TConfEth xConfEth;


bool vLoadDefaultETHConf( ){
	short int siFile;
	bool bSuccess = FALSE;
	char c, *p_inteiro;
	char inteiro[8];

	if ( (xSdHandle.connected == TRUE) && (bSDcardIsPresent()) && (bSDcardFAT16Check()) ){

		siFile = siOpenFile( ETH_FILE_NAME );
		if ( siFile < 0 ){

			memset( &(inteiro) , 10 , sizeof( inteiro ) );
			p_inteiro = inteiro;

			do {
				c = fgetc(arquivo);
				switch (c) {
					case 39:// aspas simples '
						c = fgetc(arquivo);
						while ( c != 39 ){
							c = fgetc(arquivo);
						}
						break;
					case 0x20://espaço
					case 10: //nova linha
						break;
					case 'E':
						while ((c = fgetc(arquivo))!=10){
							if ( isdigit(c) ){
								(*p_inteiro) = c;
								p_inteiro++;
							}
						}
						(*p_inteiro) = 10;
						pthread_mutex_lock(&mutex_sockEntrada);
							config_con.port_Entrada = atoi( inteiro );
						pthread_mutex_unlock(&mutex_sockEntrada);
						p_inteiro = inteiro;
						break;
					case 'S':
						while ((c = fgetc(arquivo))!=10){
							if ( isdigit(c) ){
								(*p_inteiro) = c;
								p_inteiro++;
							}
						}
						(*p_inteiro) = 10;
						pthread_mutex_lock(&mutex_sockSaida);
							config_con.port_Saida = atoi( inteiro );
						pthread_mutex_unlock(&mutex_sockSaida);
						p_inteiro = inteiro;
						break;
					case 'C':
						while ((c = fgetc(arquivo))!=10){
							if ( isdigit(c) ){
								(*p_inteiro) = c;
								p_inteiro++;
							}
						}
						(*p_inteiro) = 10;
						pthread_mutex_lock(&mutex_sockConfig);
							config_con.port_Config = atoi( inteiro );
						pthread_mutex_unlock(&mutex_sockConfig);
						p_inteiro = inteiro;
						break;
					case 'D':
						while ((c = fgetc(arquivo))!=10){
							if ( isdigit(c) ){
								(*p_inteiro) = c;
								p_inteiro++;
							}
						}
						(*p_inteiro) = 10;
						pthread_mutex_lock(&mutex_sockDebug);
							config_con.port_Debug = atoi( inteiro );
						pthread_mutex_unlock(&mutex_sockDebug);
						p_inteiro = inteiro;
						break;
					case 0x3C: //"<"
						fclose(arquivo);
						return;
						break;
					default:
						puts("Algum erro ocorreu na leitura do arquivo!");
						break;
				}
			}while ( !feof( arquivo ) );




			bSuccess = TRUE; //pensar melhor
		}
	}

	/* Will load the default configuration if not successful in read the SDCard */
	if ( bSuccess == FALSE ) {
		/*Enviar mensagem que e gravar log que não encontrou o arquivo e começara a utilizar o padrao*/
		printf("Atenção: Arquivo de conexão não foi encontrado. Carregando conf padrao\n");
		printf("Procurando por:'%s'.\n", ETH_FILE_NAME);


		xConfEth.xSocketDebug = 17003;
		xConfEth.xSocketPUS = 17000;
		/*ucIP[0].ucIP[1].ucIP[2].ucIP[3]
		 *192.168.0.5*/
		xConfEth.ucIP[0] = 192;
		xConfEth.ucIP[1] = 168;
		xConfEth.ucIP[2] = 0;
		xConfEth.ucIP[3] = 5;

		/*ucGTW[0].ucGTW[1].ucGTW[2].ucGTW[3]
		 *192.168.0.1*/
		xConfEth.ucGTW[0] = 192;
		xConfEth.ucGTW[1] = 168;
		xConfEth.ucGTW[2] = 0;
		xConfEth.ucGTW[3] = 1;


		/*ucMAC[0]:ucMAC[1]:ucMAC[2]:ucMAC[3]:ucMAC[4]:ucMAC[5]
		 *fc:f7:63:4d:1f:42*/
		xConfEth.ucMAC[0] = 0xFC;
		xConfEth.ucMAC[1] = 0xF7;
		xConfEth.ucMAC[2] = 0x63;
		xConfEth.ucMAC[3] = 0x4D;
		xConfEth.ucMAC[4] = 0x1F;
		xConfEth.ucMAC[5] = 0x42;

	}

	return bSuccess;
}
