@ECHO off
PUSHD "%~dp0"
REM Executa os batch files responsaveis pelo update de cada módulo o Hw Project
START cmd /c "..\FPGA_Developments\COM_Module_v1_8\Development\UpdateComm180Hw.bat"
START cmd /c "..\FPGA_Developments\Sync\Development\UpdateSyncHw.bat"
START cmd /c "..\FPGA_Developments\FTDI_USB3\Development\UpdateFtdiUsb3Hw.bat"
START cmd /c "..\FPGA_Developments\Seven_Seg_Display\Development\UpdateSsdpHw.bat"
REM Adicionar novos Hw sempre que forem criados
REM PAUSE
