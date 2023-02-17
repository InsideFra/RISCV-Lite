onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {IF_ID Reg} /DataPath/if_id_reg0/clk
add wave -noupdate -group {IF_ID Reg} /DataPath/if_id_reg0/rstn
add wave -noupdate -group {IF_ID Reg} /DataPath/if_id_reg0/en
add wave -noupdate -group {IF_ID Reg} -radix decimal /DataPath/if_id_reg0/in_PC_link
add wave -noupdate -group {IF_ID Reg} -radix decimal /DataPath/if_id_reg0/in_PC_add
add wave -noupdate -group {IF_ID Reg} -radix decimal /DataPath/if_id_reg0/out_PC_link
add wave -noupdate -group {IF_ID Reg} -radix decimal /DataPath/if_id_reg0/out_PC_add
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/clk
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/rstn
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/en
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_WB
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_M
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_EX
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_PC_link
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_PC_add
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_reg_data_1
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_reg_data_2
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_imm
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_ALU_ctrl
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_Rd
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_Rs1
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/in_Rs2
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_WB
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_M
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_EX
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_PC_link
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_PC_add
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_reg_data_1
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_reg_data_2
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_imm
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_ALU_ctrl
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_Rd
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_Rs1
add wave -noupdate -group {ID_EX Reg} /DataPath/ID_EX_M_r/out_Rs2
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/clk
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/rstn
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/en
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/in_WB
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/in_M
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/in_PC_link
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/in_PC_jump
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/in_bit_branch
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/in_ALU_res
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/in_reg_data_2
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/in_Rd
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/out_WB
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/out_M
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/out_PC_link
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/out_PC_jump
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/out_bit_branch
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/out_reg_data_2
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/out_ALU_res
add wave -noupdate -group {EX_MEM Reg} /DataPath/ex_mem_reg/out_Rd
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/clk
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/rstn
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/en
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/in_WB
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/in_PC_link
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/in_ALU_res
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/in_Rd
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/out_WB
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/out_PC_link
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/out_ALU_res
add wave -noupdate -group {MEM_WB Reg} /DataPath/MEM_WB_r/out_Rd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {76200 ps} 0}
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
