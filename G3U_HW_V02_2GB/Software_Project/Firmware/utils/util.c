/**
 * @file   util.c
 * @Author Rafael Corsi (corsiferrao@gmail.com)
 * @date   Marrço, 2015
 * @brief  Definiçġeses para acesso aos módulos via Avalon
 *
 * tab = 4
 */

#include "util.h"

#if DEBUG_ON
char cDebugBuffer[256];
#endif

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

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		sprintf(cDebugBuffer, "-------- link status \n");
		debug(fp, cDebugBuffer);
		sprintf(cDebugBuffer, "Link started    : %s \n", (started == 1) ? "S" : "N");
		debug(fp, cDebugBuffer);
		sprintf(cDebugBuffer, "Link connecting : %s \n", (connecting == 1) ? "S" : "N");
		debug(fp, cDebugBuffer);
		sprintf(cDebugBuffer, "Link running    : %s \n", (running == 1) ? "S" : "N");
		debug(fp, cDebugBuffer);
		sprintf(cDebugBuffer, "--------  \n");
		debug(fp, cDebugBuffer);
	}
#endif
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
alt_u8 aatoh(alt_u8 *buffer) {
	alt_u8* a;
	alt_u8 v;
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

alt_u8 Verif_Error(alt_u8 error_code) {
	if (!error_code) {
#if DEBUG_ON
if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
	debug(fp, "ERROR\n\r");
}
#endif
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

alt_u8 toInt(alt_u8 ascii) {
	return (int) ascii - 48;
}
