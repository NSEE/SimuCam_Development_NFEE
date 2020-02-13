@echo off
PUSHD "%~dp0"
REM Copia da pasta de projeto para o HW Project
ROBOCOPY "RMAP_Echoing" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon\RMAP_Echoing" /MIR /E /R:0 /W:0 /NJH /NJS
ROBOCOPY "..\Development" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon" "RMAP_Echoing_hw.tcl" /R:0 /W:0 /NJH /NJS
REM PAUSE
