analyze -library WORK -format sverilog -autoread ../../src/ >> ../report/analyze.rep

set power_preserve_rtl_hier_names true

elaborate DataPath -library WORK 
check_design >> ../report/analyze.rep
uniquify >> ../report/uniquify.rep
link >> ../report/link.rep

create_clock -name CLK -period 1.08 CLK
set_dont_touch_network CLK
set_clock_uncertainty 0.007 [get_clocks CLK]
set_input_delay 0.1 -max -clock CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.1 -max -clock CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
#set_false_path -through {FE0/instr_mem0/dout0[*] ME0/data_mem0/dout0[*]}
#set_max_delay -through {FE0/instr_mem0/dout0[*] ME0/data_mem0/dout0[*]} 2.5
set_multicycle_path -setup 3 -through {FE0/instr_mem0/dout0[*] ME0/data_mem0/dout0[*]}

compile_ultra >> ../report/compile_ultra.rep
check_design >> ../report/check_design.rep
report_timing >> ../report/timing_group.txt
ungroup -all -flatten >> ../report/ungroup.rep
report_timing >> ../report/timing_ungroup.txt
report_area >> ../report/area.txt
report_area -hierarchy >> ../report/area_hier.rep

report_resources >> ../report/resources.txt
change_names -hierarchy -rules verilog >> ../report/change_names.rep
write_sdf ../../netlist/TOP_Entity.sdf >> ../report/write_sdf.rep
write -f verilog -output ../../netlist/TOP_Entity.v >> ../report/write_verilog.rep
write -hierarchy -format ddc
