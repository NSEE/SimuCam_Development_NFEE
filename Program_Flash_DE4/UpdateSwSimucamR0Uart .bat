@ECHO OFF
PUSHD "%~dp0"

REM Pastas a serem utilizadas, precisa ser ajustado conforme a necessidade
SET SOFTWARE_FOLDER=..\G3U_HW_V02_2GB\Qsys_Project\software\Simucam_R0_UART
SET SOFTWARE_NAME=Simucam_R0_UART.elf

REM Copia o último arquivo de SW (.elf)
ECHO   Copiando ultimo arquivo de software (.elf)...
ROBOCOPY "%SOFTWARE_FOLDER%" "." "%SOFTWARE_NAME%" /R:0 /W:0 /NJH /NJS > NUL

REM Renomeia a arquivo o timestamp
SET SOFTWARE_DATE=%date%%time%
SET SOFTWARE_DATE=%SOFTWARE_DATE:/=%
SET SOFTWARE_DATE=%SOFTWARE_DATE::=%
SET SOFTWARE_DATE=%SOFTWARE_DATE:,=%
SET SOFTWARE_DATE=%SOFTWARE_DATE: =%
SET SOFTWARE_DATE=%SOFTWARE_DATE%_%SOFTWARE_NAME%
REN "%SOFTWARE_NAME%" "%SOFTWARE_DATE%" > NUL

ECHO   Copia Terminada!!
REM PAUSE
