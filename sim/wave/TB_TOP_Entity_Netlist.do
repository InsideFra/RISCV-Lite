onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/clk0
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/csb0
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/web0
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/addr0
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/din0
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/dout0
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/csb0_reg
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/web0_reg
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/addr0_reg
add wave -noupdate -expand -group FE0 /DP_TB/DP_uut/FE0_instr_mem0/din0_reg
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/clk0
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/csb0
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/web0
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/addr0
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/din0
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/dout0
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/csb0_reg
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/web0_reg
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/addr0_reg
add wave -noupdate -expand -group ME0 /DP_TB/DP_uut/ME0_data_mem0/din0_reg
add wave -noupdate /DP_TB/DP_uut/FE0_I_FSM0_max_cnt
add wave -noupdate /DP_TB/DP_uut/FE0_I_FSM0_counter
add wave -noupdate /DP_TB/DP_uut/FE0_I_FSM0_current_state
add wave -noupdate /DP_TB/DP_uut/CLK
add wave -noupdate /DP_TB/DP_uut/EN
add wave -noupdate /DP_TB/DP_uut/RSTn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {361805 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {349926 ps} {381926 ps}
