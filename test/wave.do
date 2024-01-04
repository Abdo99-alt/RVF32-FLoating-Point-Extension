onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/top/datapath/fp_alu/A
add wave -noupdate /tb/top/datapath/fp_alu/B
add wave -noupdate /tb/top/datapath/fp_alu/ALUCtrl
add wave -noupdate /tb/top/datapath/fp_alu/ALUResult
add wave -noupdate /tb/top/datapath/fp_alu/CVT_Out
add wave -noupdate /tb/top/datapath/fp_alu/MUL_Out
add wave -noupdate /tb/top/datapath/fp_alu/CLASS_Out
add wave -noupdate /tb/top/datapath/fp_alu/CMP_Out
add wave -noupdate /tb/top/datapath/fp_alu/MINMAX_Out
add wave -noupdate /tb/top/datapath/fp_alu/cmp_sel
add wave -noupdate /tb/top/datapath/fp_alu/min_max_sel
add wave -noupdate -divider mux
add wave -noupdate /tb/top/datapath/i7/A
add wave -noupdate /tb/top/datapath/i7/B
add wave -noupdate /tb/top/datapath/i7/sel
add wave -noupdate /tb/top/datapath/i7/MUXOut
add wave -noupdate -divider rf
add wave -noupdate /tb/top/datapath/fp_reg_file/A1
add wave -noupdate /tb/top/datapath/fp_reg_file/A2
add wave -noupdate /tb/top/datapath/fp_reg_file/A3
add wave -noupdate /tb/top/datapath/fp_reg_file/clk
add wave -noupdate /tb/top/datapath/fp_reg_file/WE3
add wave -noupdate /tb/top/datapath/fp_reg_file/WD3
add wave -noupdate /tb/top/datapath/fp_reg_file/RD1
add wave -noupdate /tb/top/datapath/fp_reg_file/RD2
add wave -noupdate -divider instr
add wave -noupdate /tb/top/instr_mem/Instr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 114
configure wave -valuecolwidth 102
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
WaveRestoreZoom {0 ns} {63 ns}
