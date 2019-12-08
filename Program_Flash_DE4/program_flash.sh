#!/bin/sh

if [ -f $SOPC_KIT_NIOS2/nios2_sdk_shell_bashrc ]
then
	. "$QUARTUS_ROOTDIR/sopc_builder/bin/nios_bash"
	perl program_flash.pl

else
    "$SOPC_KIT_NIOS2/nios2_command_shell.sh" perl program_flash.pl
    
fi

