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
#include "driver/ctrl_io_lvds/ctrl_io_lvds.h"
#include "driver/sinc/sinc.h"

int main()
{
  bool flag;

  printf("Hello from Nios II!\n");

  // Estado default:
  // EN_ISO_DRIVERS = '0' (tx iso drivers/sinc = off)
  // PWDW\ = '1'          (placa drivers_lvds = on)
  // PEM1:PEM0 = '00'     (pré-ênfase = off)
  // SINC_OUT = '0'
  disable_iso_drivers();
  enable_lvds_board();
  set_pre_emphasys(PEM_OFF);
  disable_sinc_out();

  // Habilita tx iso drivers/sinc
  enable_iso_drivers();

  // Checa sinc_in = '0'
  flag = read_sinc_in();
  if  (flag) {
	  printf("Erro! Sinc_in nao confere com sinc_out!\n");
  }
  else {
	  printf("Ok, Sinc_in confere com sinc_out...\n");
  }

  // Desabilita tx iso drivers/sinc
  disable_iso_drivers();

  // Desabilita placa drivers_lvds
  disable_lvds_board();

  // Reabilita placa drivers_lvds
  enable_lvds_board();

  // Coloca pré-ênfase máxima
  set_pre_emphasys(PEM_HI);

  // Retorna pré-ênfase para off
  set_pre_emphasys(PEM_OFF);

  // Habilita tx iso drivers/sinc
  enable_iso_drivers();

  // Sobe o sinal sinc_out
  enable_sinc_out();

  // Checa sinc_in = '1'
  flag = read_sinc_in();
  if  (!flag) {
	  printf("Erro! Sinc_in nao confere com sinc_out!\n");
  }
  else {
	  printf("Ok, Sinc_in confere com sinc_out...\n");
  }

  return 0;
}
