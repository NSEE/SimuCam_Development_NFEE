@echo off
PUSHD "%~dp0"
REM Copia da pasta de projeto para o HW Project
ROBOCOPY "SpaceWire_Channel" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon\SpaceWire_Channel" /MIR /E /R:0 /W:0 /NJH /NJS
ROBOCOPY "..\Development" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon" "SpaceWire_Channel_hw.tcl" /R:0 /W:0 /NJH /NJS
REM PAUSE
