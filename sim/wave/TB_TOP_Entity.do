onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {Data MEM} /DP_TB/DP_uut/ME0/data_mem0/clk0
add wave -noupdate -group {Data MEM} /DP_TB/DP_uut/ME0/data_mem0/csb0
add wave -noupdate -group {Data MEM} /DP_TB/DP_uut/ME0/data_mem0/web0
add wave -noupdate -group {Data MEM} -radix hexadecimal /DP_TB/DP_uut/ME0/data_mem0/addr0
add wave -noupdate -group {Data MEM} -radix hexadecimal /DP_TB/DP_uut/ME0/data_mem0/din0
add wave -noupdate -group {Data MEM} -radix hexadecimal /DP_TB/DP_uut/ME0/data_mem0/dout0
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/chipselect
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/write_enable
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/clk
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/rstn
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/MEM_CSB_OUT
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/STOP_Pipelinen
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/current_state
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/next_state
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/counter
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/max_cnt
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/enable_counter
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/reset_cnt
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_WB
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_M
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_EX
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_PC_link
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_PC_add
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_imm
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_reg_data_1
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_reg_data_2
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_ALU_ctrl
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_Rd
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_Rs1
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_Rs2
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/in_P
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/clk
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/rstn
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/en
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_WB
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_M
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_EX
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_PC_link
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_PC_add
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_imm
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_reg_data_1
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_reg_data_2
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_ALU_ctrl
add wave -noupdate -group ID_EX /DP_TB/DP_uut/ID_EX_M_r/out_P
add wave -noupdate -group ID_EX -radix unsigned /DP_TB/DP_uut/ID_EX_M_r/out_Rd
add wave -noupdate -group ID_EX -radix unsigned /DP_TB/DP_uut/ID_EX_M_r/out_Rs1
add wave -noupdate -group ID_EX -radix unsigned /DP_TB/DP_uut/ID_EX_M_r/out_Rs2
add wave -noupdate -group ALU -radix decimal /DP_TB/DP_uut/EX0/alu_unit0/op1
add wave -noupdate -group ALU -radix decimal /DP_TB/DP_uut/EX0/alu_unit0/op2
add wave -noupdate -group ALU /DP_TB/DP_uut/EX0/alu_unit0/ALUControl
add wave -noupdate -group ALU -radix decimal /DP_TB/DP_uut/EX0/alu_unit0/ALUResult
add wave -noupdate -group ALU /DP_TB/DP_uut/EX0/alu_unit0/BIT_Branch
add wave -noupdate -group ALU -radix decimal /DP_TB/DP_uut/EX0/alu_unit0/ADD_Result
add wave -noupdate -group ALU /DP_TB/DP_uut/EX0/alu_unit0/XOR_Result
add wave -noupdate -group ALU -radix decimal /DP_TB/DP_uut/EX0/alu_unit0/SUB_Result
add wave -noupdate -group ALU /DP_TB/DP_uut/EX0/alu_unit0/SRAI_Result
add wave -noupdate -group ALU /DP_TB/DP_uut/EX0/alu_unit0/SLLI_Result
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/CLK
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/RSTn
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/EN
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/PCSrc
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/HAZARD_BP_o
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/MEM_in_PC_link
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/HAZARD_wrong_P
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/MEM_toPC
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/HAZARD_mask
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/PC_link
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/PC_add
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/instr
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/FETCH_P
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/PCSrc_BP_out
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/PC_Input
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/FETCH_BF_data_out
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/FETCH_PC_toMUX
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/FETCH_BF_sel_out
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/FETCH_in_BF
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/INSTR_MEM_RE
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/INSTR_MEM_ADDR
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/INSTR_MEM_DOUT
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/PC_changed
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/FSM_PCSrc
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/MEM_CSB_OUT
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/MEM_WE
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/match
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/ICACHE_WEn
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/FSM_SEL
add wave -noupdate -group FE0 /DP_TB/DP_uut/FE0/START
add wave -noupdate -group FE0 -radix hexadecimal /DP_TB/DP_uut/FE0/data_cache_out
add wave -noupdate -group RF -radix unsigned /DP_TB/DP_uut/DE0/ID_RF/rs1
add wave -noupdate -group RF -radix unsigned /DP_TB/DP_uut/DE0/ID_RF/rs2
add wave -noupdate -group RF -radix unsigned /DP_TB/DP_uut/DE0/ID_RF/rd
add wave -noupdate -group RF -radix hexadecimal /DP_TB/DP_uut/DE0/ID_RF/write_data
add wave -noupdate -group RF /DP_TB/DP_uut/DE0/ID_RF/RegWrite
add wave -noupdate -group RF /DP_TB/DP_uut/DE0/ID_RF/RSTn
add wave -noupdate -group RF /DP_TB/DP_uut/DE0/ID_RF/clk
add wave -noupdate -group RF /DP_TB/DP_uut/DE0/ID_RF/en
add wave -noupdate -group RF -radix hexadecimal /DP_TB/DP_uut/DE0/ID_RF/read_data1
add wave -noupdate -group RF -radix hexadecimal /DP_TB/DP_uut/DE0/ID_RF/read_data2
add wave -noupdate -group RF /DP_TB/DP_uut/DE0/ID_RF/i
add wave -noupdate /DP_TB/DP_uut/fsm0/max_cnt
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/MEM_WE
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/clk
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/rstn
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/START
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/match
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/PC_changed
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/TEST_MEM_DATA
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/FSM_SEL
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/ICACHE_WEn
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/MEM_CSB_OUT
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/PCSrc
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/TEST_EN
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/TEST_MEM_MUX
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/TEST_MEM_WE
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/current_state
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/next_state
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/counter
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/enable_counter
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/reset_cnt
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/max_cnt
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/counter1
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/enable_counter1
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/reset_cnt1
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/clk0
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/csb0
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/web0
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/addr0
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/din0
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/dout0
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/csb0_reg
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/web0_reg
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/addr0_reg
add wave -noupdate -expand -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/din0_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {362550 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 285
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {356235 ps} {374935 ps}
