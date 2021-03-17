@ECHO off
PUSHD "%~dp0"
REM Executa os batch files responsaveis pelo update de cada módulo o Hw Project
START cmd /c "..\FPGA_Developments\COM_Module_v2\Development\UpdateComm200Hw.bat"
START cmd /c "..\FPGA_Developments\FTDI_USB3\Development\UpdateFtdiUsb3Hw.bat"
START cmd /c "..\FPGA_Developments\RMAP_Echoing\Development\UpdateRmpe100Hw.bat
START cmd /c "..\FPGA_Developments\RMAP_Memory_NFEE_Area\Development\UpdateNRMe100Hw.bat
START cmd /c "..\FPGA_Developments\SpaceWire_Channel\Development\UpdateSpwc100Hw.bat
START cmd /c "..\FPGA_Developments\SpaceWire_Glutton\Development\UpdateSpwGluttonHw.bat
START cmd /c "..\FPGA_Developments\Synchronization_COMM\Development\UpdateScom100Hw.bat
START cmd /c "..\FPGA_Developments\Sync\Development\UpdateSyncHw.bat"
START cmd /c "..\FPGA_Developments\Memory_Filler\Development\UpdateMfilHw.bat"
REM Adicionar novos Hw sempre que forem criados
REM PAUSE
