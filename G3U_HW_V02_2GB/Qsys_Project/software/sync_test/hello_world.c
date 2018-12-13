/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "driver/sync/sync.h"
#include <unistd.h>

// Master blank time = (MBT * 20 ns) = 400 ms
#define MBT	20E6
// Blank time = (BT * 20 ns) = 200 ms
#define BT	10E6
// Period = (PER * 20 ns) = 6,25 s
#define PER	312500E3
// One shot time = (OST * 20 ns) = 500 ms
#define OST	25E6
// Blank level polarity = '0'
#define POL FALSE
// Number of cycles = 4
#define N_CICLOS 4

int main()
{
  bool		flag;
  alt_u32	aux_32;
  alt_u8	aux_8;

  init_interrupt();
  n = 0;
  printf("Hello from Nios II!\n");

  // Retorna ao estado idle
  flag = sync_ctr_reset();

  // Le bit de status - sync ext. ou int. (default = externo)
  flag = sync_status_extn_int();

  // Sync externo
  flag = sync_ctr_extn_int(FALSE);

  // Habilita sync_out enable (deve aparecer na saída o sync ext.)
  flag = sync_ctr_sync_out_enable(TRUE);

  // Altera para sync interno (ainda não configurado)
  flag = sync_ctr_extn_int(TRUE);

  // Configura um padrão de sync interno
  // MBT => 400 ms @ 20 ns (50 MHz)
  flag = sync_config_mbt(MBT);

  // BT => 200 ms @ 20 ns (50 MHz)
  flag = sync_config_bt(BT);

  // PER => 6,25s @ 20 ns (50 MHz)
  flag = sync_config_per((alt_u32)PER);

  // OST => 500 ms @ 20 ns (50 MHz)
  flag = sync_config_ost(OST);

  // Polaridade
  flag = sync_config_polarity(POL);

  // N. de ciclos
  flag = sync_config_n_cycles(N_CICLOS);

  // Lê toda a configuração para conferir setup
  // MBT
  aux_32 = sync_read_config_mbt();
  printf("MBT = %u \n", aux_32);
  // BT
  aux_32 = sync_read_config_bt();
  printf("BT = %u \n", aux_32);
  // PER
  aux_32 = sync_read_config_per();
  printf("PER = %u \n", aux_32);
  // OST
  aux_32 = sync_read_config_ost();
  printf("OST = %u \n", aux_32);
  // General
  aux_32 = sync_read_config_general();
  printf("General = %x \n", aux_32);

  // Lê control reg
  aux_32 = sync_read_ctr();
  printf("Control = %x \n", aux_32);

  // Start no gerador interno - deve aparecer no sync out
  flag = sync_ctr_start();

  // Lê control reg
  aux_32 = sync_read_ctr();
  printf("Control = %x \n", aux_32);

  // Lê estado
  aux_8 = sync_status_state();
  printf("State = %x \n", aux_8);

  // Lê n. do ciclo atual
  aux_8 = sync_status_cycle_number();
  printf("N. do ciclo = %u \n", aux_8);

  // Retorna ao estado idle
  flag = sync_ctr_reset();

  // One shot
  flag = sync_ctr_one_shot();

  // Retorna ao estado idle
  flag = sync_ctr_reset();

  // Err_inj
  flag = sync_ctr_err_inj();

  // Lê estado
  aux_8 = sync_status_state();
  printf("State = %x \n", aux_8);

  // Lê n. do ciclo atual
  aux_8 = sync_status_cycle_number();
  printf("N. do ciclo = %u \n", aux_8);

  // Lê status reg
  aux_32 = sync_read_status();
  printf("Status reg = %x \n", aux_32);

  // Le bit de status - sync ext. ou int. (default = externo)
  flag = sync_status_extn_int();
  printf("extn_int = %x \n", flag);

  // Habilita int blank pulse
  aux_32 = sync_int_enable_blank(TRUE);

  // Retorna ao estado idle
  flag = sync_ctr_reset();

  // Desabilita int blank pulse
  aux_32 = sync_int_enable_blank(FALSE);

  // Polaridade
  flag = sync_config_polarity(!POL);

  // Start
  flag = sync_ctr_start();

  // Retorna ao estado idle
  flag = sync_ctr_reset();

  // Polaridade
  flag = sync_config_polarity(POL);

  // Habilita int blank pulse
  aux_32 = sync_int_enable_blank(TRUE);

  // Start
  flag = sync_ctr_start();

  while (1) {
	  usleep(1000000);
	  printf("Ocorreu int. blank n. = %u \n", n);
  }

  return 0;
}
