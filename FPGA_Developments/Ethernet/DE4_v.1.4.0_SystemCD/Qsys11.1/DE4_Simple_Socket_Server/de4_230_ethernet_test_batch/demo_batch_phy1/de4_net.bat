%QUARTUS_ROOTDIR%\\bin\\quartus_pgm.exe -z -m JTAG -c USB-Blaster[USB-0] -o "p;DE4_Ethernet.sof"
@ set SOPC_BUILDER_PATH=%SOPC_KIT_NIOS2%+%SOPC_BUILDER_PATH%
@ "%QUARTUS_ROOTDIR%\bin\cygwin\bin\bash.exe" --rcfile ".\de4_net_bashrc"

pause