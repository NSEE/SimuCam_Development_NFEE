#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting ELF File: D:\nsee-dev-git\SimuCam_Development\G3U_HW_V02_2GB\Qsys_Project\software\Simucam_R0_UART\Simucam_R0_UART.elf to: "..\flash/Simucam_R0_UART_ext_flash.flash"
#
elf2flash --input="D:/nsee-dev-git/SimuCam_Development/G3U_HW_V02_2GB/Qsys_Project/software/Simucam_R0_UART/Simucam_R0_UART.elf" --output="../flash/Simucam_R0_UART_ext_flash.flash" --boot="nios2eds/components/altera_nios2/boot_loader_cfi.srec" --base=0x84000000 --end=0x88000000 --reset=0x86020000 --verbose 

#
# Programming File: "..\flash/Simucam_R0_UART_ext_flash.flash" To Device: ext_flash
#
nios2-flash-programmer "../flash/Simucam_R0_UART_ext_flash.flash" --base=0x84000000 --sidp=0x80002480 --id=0x71 --timestamp=1568269533 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

