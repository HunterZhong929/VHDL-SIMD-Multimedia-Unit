#############################################################
# vsimsa environment configuration
set dsn $curdir
log $dsn/log/vsimsa.log
@echo
@echo #################### Starting C Code Debug Session ######################
cd $dsn/src
amap Proj $dsn/Proj/Proj.lib
set worklib Proj
# simulation
asim -callbacks +notimingchecks +no_tchk_msg -O5 +access +r +m+Instruction_BufferTB Instruction_BufferTB Instruction_BufferTB
run -all
#############################################################