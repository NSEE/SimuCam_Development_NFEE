@ECHO OFF
PUSHD "%~dp0"

REM Pastas a serem utilizadas, precisa ser ajustado conforme a necessidade
SET HARDWARE_FOLDER=..\G3U_HW_V02_2GB\Quartus_Project\output_files
SET HARDWARE_NAME=MebX_Quartus_Project_DE4_230.sof

REM Copia o último arquivo de HW (.sof)
ECHO   Copiando ultimo arquivo de hardware (.sof)...
ROBOCOPY "%HARDWARE_FOLDER%" "." "%HARDWARE_NAME%" /R:0 /W:0 /NJH /NJS > NUL

REM Renomeia a arquivo o timestamp
SET HARDWARE_DATE=%date%%time%
SET HARDWARE_DATE=%HARDWARE_DATE:/=%
SET HARDWARE_DATE=%HARDWARE_DATE::=%
SET HARDWARE_DATE=%HARDWARE_DATE:,=%
SET HARDWARE_DATE=%HARDWARE_DATE: =%
SET HARDWARE_DATE=%HARDWARE_DATE%_%HARDWARE_NAME%
REN "%HARDWARE_NAME%" "%HARDWARE_DATE%" > NUL

ECHO   Copia Terminada!!
REM PAUSE
