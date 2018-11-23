/**
 * @file   util.c
 * @Author Rafael Corsi (corsiferrao@gmail.com)
 * @date   Marrço, 2015
 * @brief  Definiçõeses para acesso aos módulos via Avalon
 *
 * tab = 4
 */

#include "util.h"

/**
 * @name    _reg_write
 * @brief   Escrita dos registradores de config. RMAP/SPW
 * @ingroup UTIL
 *
 * Acessa os registradores do módulos RMAP_SPW via acesso a memoria AVALON
 *
 * @param [in] BASE_ADD Endereço base de acesso ao registrador
 * @param [in] REG_ADD  Endereço do registador (Offset)
 * @param [in] REG_DADO Dado a ser gravado no registrador
 *
 * @retval 1 : Sucesso 
 *
 */

alt_32 _reg_write(int BASE_ADD, alt_32 REG_ADD, alt_32 REG_Dado) {

	IOWR_32DIRECT(BASE_ADD, REG_ADD << 2, REG_Dado);
	return 1;

}

/**
 * @name    _reg_read
 * @brief   Leitura dos registradores de config. RMAP/SPW
 * @ingroup UTIL
 *
 * Acessa os registradores do módulos RMAP_SPW via acesso a memoria AVALON
 *
 * @param [in] BASE_ADD Endereço base de acesso ao registrador
 * @param [in] REG_ADD  Endereço do registador (Offset)
 * @param [in] REG_DADO Retorno do dado lido
 *
 * @retval 1 : Sucesso 
 *
 */

alt_32 _reg_read(int BASE_ADD, alt_32 REG_ADD, alt_32 *REG_Dado) {

	*REG_Dado = IORD_32DIRECT(BASE_ADD, REG_ADD << 2);
	return 1;

}

/**
 * @name    _print_codec_status
 * @brief   Print codec status
 * @ingroup UTIL
 *
 * Print codec status
 *
 * @param [in] codec_status
 * *
 * @retval 1 : Sucesso
 *
 */
void _print_codec_status(int codec_status) {
	int started = (int) ((codec_status >> 6) & 1);
	int connecting = (int) ((codec_status >> 5) & 1);
	int running = (int) ((codec_status >> 4) & 1);

	printf("-------- link status \n");
	printf("Link started    : %s \n", (started == 1) ? "S" : "N");
	printf("Link connecting : %s \n", (connecting == 1) ? "S" : "N");
	printf("Link running    : %s \n", (running == 1) ? "S" : "N");
	printf("--------  \n");
}

/**
 * @name    _split_codec_status
 * @brief   Split codec status
 * @ingroup UTIL
 *
 * Split codec status
 *
 * @param [in] codec_status
 * *
 * @retval 1 : Sucesso
 *
 */
void _split_codec_status(int codec_status, int *started, int *connecting,
		int *running) {
	*started = (int) ((codec_status >> 6) & 1);
	*connecting = (int) ((codec_status >> 5) & 1);
	*running = (int) ((codec_status >> 4) & 1);
}

/**
 * @name    aatoh
 * @brief   Converts chars to hexa
 * @ingroup UTIL
 *
 * Converts 2 chars to hexadecimal value
 *
 * @param [in] &char[n]
 * *
 * @retval INT8U of hecadecimal value
 *
 */
INT8U aatoh(INT8U *buffer) {
	INT8U* a;
	INT8U v;
	a = buffer;
	v = ((a[0] - (48 + 7 * (a[0] > 57))) << 4)
			+ (a[1] - (48 + 7 * (a[1] > 57)));
	return v;
}

/**
 * @name    Verif_Error
 * @brief   Prints errors
 * @ingroup UTIL
 *
 * Prints errors and acts as a passthrough
 *
 * @param [in] int
 * *
 * @retval int
 *
 */

INT8U Verif_Error(INT8U error_code) {
	if (!error_code) {
		printf("ERROR\n\r");
		return 0;
	} else
		return 1;
}

/**
 * @name    toInt
 * @brief   Converts ASCII number to int
 * @ingroup UTIL
 *
 * Converts 1 digit ASCII numbers to int
 *
 * @param [in] INT8U
 * *
 * @retval int
 *
 */

INT8U toInt(INT8U ascii) {
	return (int) ascii - 48;
}