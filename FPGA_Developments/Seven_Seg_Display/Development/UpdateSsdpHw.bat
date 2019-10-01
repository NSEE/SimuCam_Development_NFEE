@echo off
PUSHD "%~dp0"
REM Copia da pasta de projeto para o HW Project
ROBOCOPY "SSDP" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon\SSDP" /MIR /E /R:0 /W:0 /NJH /NJS
ROBOCOPY "..\Development" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon" "SEVEN_SEGMENT_CONTROLLER_hw.tcl" /R:0 /W:0 /NJH /NJS
REM PAUSE
