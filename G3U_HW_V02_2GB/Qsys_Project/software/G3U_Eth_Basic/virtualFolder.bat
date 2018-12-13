@echo off
title Create virtual folder inside the project
echo This is an script that should run into source project file in order to create an virtual folder linked to driver, logic and utils file in the Firmware folder.
echo If you create a project in the default location, then you folder project is inside "Qsys_Project\software\<name_of_your_project>
pause
del ".\driver"
del ".\logic"
del ".\utils"
del ".\rtos"
mklink /D ".\driver" "..\..\..\Software_Project\Firmware\driver" 
mklink /D ".\logic" "..\..\..\Software_Project\Firmware\logic"
mklink /D ".\utils" "..\..\..\Software_Project\Firmware\utils"
mklink /D ".\rtos" "..\..\..\Software_Project\Firmware\rtos"
echo .
echo Job done. 
echo Arigato gosaimasu!
echo . 
echo . 
pause