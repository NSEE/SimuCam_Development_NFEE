@ECHO off
PUSHD "%~dp0"
REM Executa os batch files responsaveis pelo update de cada módulo o Hw Project
START cmd /c "..\FPGA_Developments\COM_Module_v1_8\Development\UpdateComm180Hw.bat"
START cmd /c "..\FPGA_Developments\FTDI_USB3\Development\UpdateFtdiUsb3Hw.bat"
START cmd /c "..\FPGA_Developments\RMAP_Echoing\Development\UpdateRmpe100Hw.bat
START cmd /c "..\FPGA_Developments\RMAP_Memory_NFEE_Area\Development\UpdateNRMe100Hw.bat
START cmd /c "..\FPGA_Developments\SpaceWire_Channel\Development\UpdateSpwc100Hw.bat
START cmd /c "..\FPGA_Developments\SpaceWire_Glutton\Development\UpdateSpwGluttonHw.bat
START cmd /c "..\FPGA_Developments\Sync\Development\UpdateSyncHw.bat"
REM Adicionar novos Hw sempre que forem criados
REM PAUSE
