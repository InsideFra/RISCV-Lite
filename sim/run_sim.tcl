rm -rf run;
mkdir run;
cp main_hex.txt run/
cp data_hex.txt run/
cd run;

rm -rf work;
vlib work;
vlog -f ../compile_all.tcl
vsim work.DP_TB -voptargs=+acc -t 1ps -suppress 3009;
do ../wave/TB_TOP_Entity.do;
add log -r sim:/DP_TB/DP_uut/*
run 10 us;
