#!/bin/sh

if [ -f $SOPC_KIT_NIOS2/nios2_sdk_shell_bashrc ]
then
	. "$QUARTUS_ROOTDIR/sopc_builder/bin/nios_bash"
	perl nios_ii_terminal.pl

else
    "$SOPC_KIT_NIOS2/nios2_command_shell.sh" perl nios_ii_terminal.pl
    
fi

