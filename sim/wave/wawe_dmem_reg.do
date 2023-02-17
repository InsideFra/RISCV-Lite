onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DataPath/TB_LOADPROGRAM_CTRL
add wave -noupdate /DataPath/CLK
add wave -noupdate /DataPath/RSTn
add wave -noupdate /DataPath/RSTn_PC
add wave -noupdate /DataPath/START
add wave -noupdate /DataPath/FETCH_INSTRUCTION
add wave -noupdate -group {Hazard Control Unit} /DataPath/HAZARD_o
add wave -noupdate -group {Hazard Control Unit} /DataPath/HAZARD_i
add wave -noupdate -group {Forward Control Unit} /DataPath/Forward_i
add wave -noupdate -group {Forward Control Unit} /DataPath/Forward_o
add wave -noupdate -group {Fetch Stage VAR} -radix decimal /DataPath/FETCH_MUX_toPC
add wave -noupdate -group {Fetch Stage VAR} -radix decimal /DataPath/ADD_Result
add wave -noupdate -group {Fetch Stage VAR} -radix decimal /DataPath/FETCH_PC_toMUX
add wave -noupdate -group {Fetch Stage VAR} -radix decimal /DataPath/INSTR_MEM_ADDR
add wave -noupdate -group {Fetch Stage VAR} /DataPath/INSTR_MEM_DIN
add wave -noupdate -group {Fetch Stage VAR} -radix hexadecimal /DataPath/INSTR_MEM_DOUT
add wave -noupdate -group {Fetch Stage VAR} /DataPath/INSTR_MEM_RE
add wave -noupdate -group {ID Stage VAR} -expand -group {ID IN} /DataPath/ID_in_WB
add wave -noupdate -group {ID Stage VAR} -expand -group {ID IN} /DataPath/ID_in_M
add wave -noupdate -group {ID Stage VAR} -expand -group {ID IN} /DataPath/ID_in_EX
add wave -noupdate -group {ID Stage VAR} -expand -group {ID IN} -radix decimal /DataPath/ID_in_PC_link
add wave -noupdate -group {ID Stage VAR} -expand -group {ID IN} -radix decimal /DataPath/ID_in_PC_add
add wave -noupdate -group {ID Stage VAR} -expand -group {ID IN} /DataPath/ID_in_ALU_ctrl
add wave -noupdate -group {ID Stage VAR} -radix unsigned /DataPath/ID_Rs1
add wave -noupdate -group {ID Stage VAR} -radix unsigned /DataPath/ID_Rs2
add wave -noupdate -group {ID Stage VAR} -radix unsigned /DataPath/ID_Rd
add wave -noupdate -group {ID Stage VAR} /DataPath/ID_RegWrite
add wave -noupdate -group {ID Stage VAR} /DataPath/ID_opcode
add wave -noupdate -group {ID Stage VAR} /DataPath/ID_WB_c
add wave -noupdate -group {ID Stage VAR} /DataPath/ID_M_c
add wave -noupdate -group {ID Stage VAR} /DataPath/ID_EX_c
add wave -noupdate -group {ID Stage VAR} -radix hexadecimal /DataPath/ID_inst
add wave -noupdate -group {ID Stage VAR} -radix decimal /DataPath/ID_imm
add wave -noupdate -group {ID Stage VAR} /DataPath/ID_sel_mux
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} -radix decimal /DataPath/EX_in_PC_add
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_PC_link
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_imm
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_reg_data_2
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_reg_data_1
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_ALU_ctrl
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_Rd
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_Rs1
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_Rs2
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_EX
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_WB
add wave -noupdate -group {EX Stage VAR} -expand -group {EX IN} /DataPath/EX_in_M
add wave -noupdate -group {EX Stage VAR} /DataPath/EX_Mux_ALUIN1
add wave -noupdate -group {EX Stage VAR} /DataPath/EX_Mux_ALUIN2
add wave -noupdate -group {EX Stage VAR} /DataPath/EX_Mux_Mux_ALUIN1
add wave -noupdate -group {EX Stage VAR} /DataPath/EX_Mux_Mux_ALUIN2
add wave -noupdate -group {EX Stage VAR} /DataPath/EX_ALUControl
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_toPC
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_in_WB
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_in_M
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_in_PC_link
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_in_PC_jump
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_in_bit_branch
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_in_reg_data_2
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_in_ALU_res
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_in_Rd
add wave -noupdate -expand -group {MEM Stage VAR} /DataPath/MEM_mem_data
add wave -noupdate -group {WB Stage VAR} -expand /DataPath/WB_in_WB
add wave -noupdate -group {WB Stage VAR} /DataPath/WB_in_PC_link
add wave -noupdate -group {WB Stage VAR} /DataPath/WB_in_ALU_res
add wave -noupdate -group {WB Stage VAR} /DataPath/WB_in_Rd
add wave -noupdate -group {WB Stage VAR} /DataPath/WB_Mux_out
add wave -noupdate -group {WB Stage VAR} /DataPath/WB_Mux_Mux_out
add wave -noupdate /DataPath/PCSrc
add wave -noupdate /DataPath/data_mem0/dout0
add wave -noupdate /DataPath/ID_RF/RegWrite
add wave -noupdate /DataPath/ID_RF/write_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11900 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {88800 ps}
