#!/bin/bash
blue=$(tput setaf 4)
normal=$(tput sgr0)

SOPC_KIT_NIOS2=/home/Dados/opt/Altera/Quartus16/nios2eds 
NIOS2_SHELL=$SOPC_KIT_NIOS2/nios2_command_shell.sh
BASE_ADDR=$(pwd)

SOF_FILE=$1 #SOF_FILE=TopLevelTransfBlock.sof
ELF_FILE=$2 #ELF_FILE=NIOS-Boot-Test.elf
NAME=$3     #NamedOutput

FLASH_HW_ADDR=out/$NAME\_hw.flash
FLASH_SW_ADDR=out/$NAME\_sw.flash
FLASH_MAP_ADDR=out/$NAME\_hw.map.flash

printf " ${blue}  Rafael Corsi - NSEE - 2017  \n"
printf " ${blue} ---------------------------------- [sof -> hw.flash] ---- \n"
printf " ${blue} --- INPUT  :  %s    \n" $SOF_FILE
printf " ${blue} --- OUTPUT :  %s    \n" $FLASH_HW_ADDR
printf " ${blue} --- OUTPUT :  %s    \n" $FLASH_MAP_ADDR
printf " ${normal}"

$NIOS2_SHELL sof2flash --input=$BASE_ADDR/$SOF_FILE --output=$BASE_ADDR/$FLASH_HW_ADDR --offset=0x00020000 --pfl --optionbit=0x18000 --programmingmode=FPP

printf " ${blue} ---------------------------------- [sof -> hw.flash] ---- \n"
printf " ${blue} --- INPUT  :  %s    \n"  $ELF_FILE
printf " ${blue} --- OUTPUT :  %s    \n"  $FLASH_SW_ADDR
printf " ${normal}"

$NIOS2_SHELL elf2flash --base=0x08000000 --end=0x0bFFFFFF --reset=0x0a020000 --input=$BASE_ADDR/$ELF_FILE --output=$BASE_ADDR/$FLASH_SW_ADDR --boot=$SOPC_KIT_NIOS2/components/altera_nios2/boot_loader_cfi.srec 

printf " ${blue} ------------------------------ [S1...-> hw.map.flash] ---- \n"
printf " ${blue} --- INPUT  :  %s    \n"  $BASE_ADDR/$FLASH_MAP_ADDR
printf " ${blue} --- OUTPUT :  %s    \n"  $BASE_ADDR/$FLASH_MAP_ADDR
echo "S21501808003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6" >> $BASE_ADDR/$FLASH_MAP_ADDR


printf "%s\n" " End ---------------------" 
