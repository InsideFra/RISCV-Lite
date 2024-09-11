onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /DP_TB/DP_uut/if_id_reg0/in_PC_add
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/MEM_WE
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/clk
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/rstn
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/match
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/PC_changed
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/TEST_MEM_DATA
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/FSM_SEL
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/ICACHE_WEn
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/MEM_CSB_OUT
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/PCSrc
add wave -noupdate -expand -group I_FSM /DP_TB/DP_uut/FE0/I_FSM0/TEST_EN
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
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/clk0
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/csb0
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/web0
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/addr0
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/din0
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/dout0
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/csb0_reg
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/web0_reg
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/addr0_reg
add wave -noupdate -group INSTR_MEM /DP_TB/DP_uut/FE0/instr_mem0/din0_reg
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/CLK
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/RSTn
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/EN
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/START
add wave -noupdate -expand -group FE -expand /DP_TB/DP_uut/FE0/HAZARD
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/TB_LOAD_PROGRAM_CTRL
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/TB_LOAD_PROGRAM_DATA
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/TB_LOAD_PROGRAM_ADDR
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/MEM_in_PC_jump
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/MEM_in_ALU_res
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/PC_link
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/PC_add
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/instr
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/TEST_EN_OUT
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/FSM_PCSrc
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/PC_Input
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/FETCH_PC_toMUX
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/INSTR_MEM_RE
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/INSTR_MEM_ADDR
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/INSTR_MEM_DIN
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/INSTR_MEM_DOUT
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/TEST_EN
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/TEST_MEM_WE
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/TEST_MEM_DATA
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/_FSM_PCSrc
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/MEM_CSB_OUT
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/MEM_WE
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/ICACHE_WEn
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/TEST_MEM_MUX
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/FSM_SEL
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/enable_PC
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/match
add wave -noupdate -expand -group FE /DP_TB/DP_uut/FE0/data_cache_out
add wave -noupdate -group FE_DE_REG -radix hexadecimal /DP_TB/DP_uut/if_id_reg0/in_PC_link
add wave -noupdate -group FE_DE_REG -radix hexadecimal /DP_TB/DP_uut/if_id_reg0/in_instr
add wave -noupdate -group FE_DE_REG /DP_TB/DP_uut/if_id_reg0/in_P
add wave -noupdate -group FE_DE_REG /DP_TB/DP_uut/if_id_reg0/clk
add wave -noupdate -group FE_DE_REG /DP_TB/DP_uut/if_id_reg0/rstn
add wave -noupdate -group FE_DE_REG /DP_TB/DP_uut/if_id_reg0/en
add wave -noupdate -group FE_DE_REG -radix hexadecimal /DP_TB/DP_uut/if_id_reg0/out_PC_link
add wave -noupdate -group FE_DE_REG -radix hexadecimal /DP_TB/DP_uut/if_id_reg0/out_PC_add
add wave -noupdate -group FE_DE_REG -radix hexadecimal /DP_TB/DP_uut/if_id_reg0/out_instr
add wave -noupdate -group FE_DE_REG /DP_TB/DP_uut/if_id_reg0/out_P
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
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/CLK
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/EN
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/RSTn
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/START
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_in_instr
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/WB_in_Rd
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/WB_Mux_Mux_out
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/HAZARD_BP_o
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/WB_in_WB
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_in_WB
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_in_M
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_in_EX
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_imm
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_reg_data_1
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_reg_data_2
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_Rs1
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_sel_mux
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/EX_in_instr
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_Rd_EQ0
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_RegWrite
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_opcode
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_WB_c
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_M_c
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_EX_c
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/MUX_ID_Rs1
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_reg_data_1_BM
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_reg_data_2_BM
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_Rs2
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_Rd
add wave -noupdate -group DE /DP_TB/DP_uut/DE0/ID_in_ALU_ctrl
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/in_WB
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/in_M
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/in_EX
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/in_PC_link
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/in_imm
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/in_reg_data_1
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/in_reg_data_2
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/in_ALU_ctrl
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/in_Rd
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/in_Rs1
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/in_Rs2
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/in_Rd_EQ0
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/in_P
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/clk
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/rstn
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/en
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/out_WB
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/out_M
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/out_EX
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/out_PC_link
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/out_PC_add
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/out_imm
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/out_reg_data_1
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/out_reg_data_2
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/out_ALU_ctrl
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/out_P
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/out_Rd
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/out_Rs1
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/out_Rs2
add wave -noupdate -expand -group DE_EX_REG /DP_TB/DP_uut/ID_EX_M_r/out_Rd_EQ0
add wave -noupdate -expand -group DE_EX_REG -radix hexadecimal /DP_TB/DP_uut/ID_EX_M_r/in_PC_add
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
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/CLK
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EN
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/RSTn
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_in_EX
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/Forward_o
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/HAZARD_BP_o
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_in_PC_add
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_in_imm
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_in_reg_data_2
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_in_reg_data_1
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_in_ALU_ctrl
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/WB_Mux_Mux_out
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/MEM_in_instr
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/MEM_in_ALU_res
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_in_instr
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_PC_jump
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_ALUResult
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_bit_branch
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_Mux_ALUIN1
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_Mux_ALUIN2
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_Mux_Mux_ALUIN1
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_Mux_Mux_ALUIN2
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_Mux_Mux_Mux_ALUIN1
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_Mux_Mux_Mux_ALUIN2
add wave -noupdate -group EX /DP_TB/DP_uut/EX0/EX_ALUControl
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/in_WB
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/in_M
add wave -noupdate -expand -group EX_MEM_REG -radix hexadecimal /DP_TB/DP_uut/ex_mem_reg/in_PC_link
add wave -noupdate -expand -group EX_MEM_REG -radix hexadecimal /DP_TB/DP_uut/ex_mem_reg/in_PC_jump
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/in_bit_branch
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/in_ALU_res
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/in_reg_data_2
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/in_Rd
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/in_Rd_EQ0
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/clk
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/in_P
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/rstn
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/en
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_WB
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_M
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_PC_link
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_PC_jump
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_PC
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_bit_branch
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_reg_data_2
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_ALU_res
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_P
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_Rd
add wave -noupdate -expand -group EX_MEM_REG /DP_TB/DP_uut/ex_mem_reg/out_Rd_EQ0
add wave -noupdate -expand -group EX_MEM_REG -radix hexadecimal /DP_TB/DP_uut/ex_mem_reg/in_PC
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
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/STOP_Pipelinen
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/current_state
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/next_state
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/counter
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/max_cnt
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/enable_counter
add wave -noupdate -group D_FSM /DP_TB/DP_uut/fsm0/reset_cnt
add wave -noupdate /DP_TB/DP_uut/fsm0/max_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {414920 ps} 0}
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
WaveRestoreZoom {398593 ps} {443467 ps}
