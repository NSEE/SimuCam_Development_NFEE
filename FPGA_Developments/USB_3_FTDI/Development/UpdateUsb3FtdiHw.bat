@echo off
PUSHD "%~dp0"
REM Copia da pasta de projeto para o HW Project
ROBOCOPY "Usb_3_Ftdi" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon\Usb_3_Ftdi" /MIR /E /R:0 /W:0 /NJH /NJS
ROBOCOPY "..\Development" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon" "USB_3_FTDI_hw.tcl" /R:0 /W:0 /NJH /NJS
REM PAUSE
