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
#include "api_driver/ddr2/ddr2.h"

int main()
{
  printf("Memory EEPROM dumper application\n\n");

//  printf("Memory M1 EEPROM Test:\n");
//  if (bDdr2EepromTest(DDR2_M1_ID)){
//	  printf("Memory M1 EEPROM Dump:\n");
//	  bDdr2EepromDump(DDR2_M1_ID);
////  } else {
////	  printf("Memory M1 EEPROM Test failed, not possible to dump\n");
////  }
//
////  printf("Memory M2 EEPROM Test:\n");
////  if (bDdr2EepromTest(DDR2_M2_ID)){
////	  printf("Memory M2 EEPROM Dump:\n");
//	  bDdr2EepromDump(DDR2_M2_ID);
////  } else {
////	  printf("Memory M2 EEPROM Test failed, not possible to dump\n");
////  }
////
//  printf("EEPROM Test and Dump complete!\n");


  bDdr2MemoryRandomWriteTest(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME);
  bDdr2MemoryRandomReadTest(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME);

  while (1) {}

  return 0;
}
