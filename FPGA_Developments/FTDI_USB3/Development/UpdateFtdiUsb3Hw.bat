@echo off
PUSHD "%~dp0"
REM Copia da pasta de projeto para o HW Project
ROBOCOPY "Ftdi_Usb3" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon\Ftdi_Usb3" /MIR /E /R:0 /W:0 /NJH /NJS
ROBOCOPY "..\Development" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon" "FTDI_USB3_hw.tcl" /R:0 /W:0 /NJH /NJS
REM PAUSE
