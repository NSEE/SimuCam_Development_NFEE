@echo off
PUSHD "%~dp0"
REM Copia da pasta de projeto para o HW Project
ROBOCOPY "SpaceWire_PassThrough" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon\SpaceWire_PassThrough" /MIR /E /R:0 /W:0 /NJH /NJS
ROBOCOPY "..\Development" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon" "SpaceWire_PassThrough_hw.tcl" /R:0 /W:0 /NJH /NJS
REM PAUSE
