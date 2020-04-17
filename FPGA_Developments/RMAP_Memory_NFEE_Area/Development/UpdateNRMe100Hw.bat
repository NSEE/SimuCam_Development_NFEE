@echo off
PUSHD "%~dp0"
REM Copia da pasta de projeto para o HW Project
ROBOCOPY "RMAP_Memory_NFEE_Area" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon\RMAP_Memory_NFEE_Area" /MIR /E /R:0 /W:0 /NJH /NJS
ROBOCOPY "..\Development" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon" "RMAP_Memory_NFEE_Area_hw.tcl" /R:0 /W:0 /NJH /NJS
REM PAUSE
