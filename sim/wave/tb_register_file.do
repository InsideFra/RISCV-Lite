onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Input /tb_register_file/rs1
add wave -noupdate -expand -group Input /tb_register_file/rs2
add wave -noupdate -expand -group Input /tb_register_file/rd
add wave -noupdate -expand -group Input /tb_register_file/write_data
add wave -noupdate -expand -group Input /tb_register_file/RSTn
add wave -noupdate -expand -group Input /tb_register_file/RegWrite
add wave -noupdate -height 15 -expand -group Output /tb_register_file/read_data1
add wave -noupdate -height 15 -expand -group Output /tb_register_file/read_data2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7300 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 185
configure wave -valuecolwidth 213
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
WaveRestoreZoom {0 ps} {188500 ps}
