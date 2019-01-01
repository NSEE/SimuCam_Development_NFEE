# ------------------------------------------------------------------------------
# Top Level Simulation Script to source msim_setup.tcl
# ------------------------------------------------------------------------------
set QSYS_SIMDIR obj/default/runtime/sim
source msim_setup.tcl
# Copy generated memory initialization hex and dat file(s) to current directory
file copy -force C:/Users/rfranca/Development/GitHub/SimuCam_Development/G3U_HW_V02_2GB/Qsys_Project/software/COMM_Pedreiro_Test/mem_init/hdl_sim/ext_flash.dat ./ 
file copy -force C:/Users/rfranca/Development/GitHub/SimuCam_Development/G3U_HW_V02_2GB/Qsys_Project/software/COMM_Pedreiro_Test/mem_init/hdl_sim/MebX_Qsys_Project_onchip_memory.dat ./ 
file copy -force C:/Users/rfranca/Development/GitHub/SimuCam_Development/G3U_HW_V02_2GB/Qsys_Project/software/COMM_Pedreiro_Test/mem_init/MebX_Qsys_Project_onchip_memory.hex ./ 
