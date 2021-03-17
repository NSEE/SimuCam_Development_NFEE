
@ REM ######################################
@ REM # Variable to ignore <CR> in DOS
@ REM # line endings
@ set SHELLOPTS=igncr

@ REM ######################################
@ REM # Variable to ignore mixed paths
@ REM # i.e. G:/$SOPC_KIT_NIOS2/bin
@ set CYGWIN=nodosfilewarning

@ set SOPC_BUILDER_PATH=%SOPC_KIT_NIOS2%
@ "%QUARTUS_ROOTDIR%\bin64\cygwin\bin\bash.exe" --rcfile ".\nios_ii_terminal.sh"
pause