onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:clk
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:Fault_Info_FIFO_in
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:Fault_Info_LBDR_in
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:Fault_Info_Arbiter_in
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:Fault_Info_XBAR_in
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_FIFO_input_select_N_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_FIFO_input_select_E_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_FIFO_input_select_W_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_FIFO_input_select_S_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_FIFO_input_select_L_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_FIFO_input_select_R_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_LBDR_input_select_N_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_LBDR_input_select_E_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_LBDR_input_select_W_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_LBDR_input_select_S_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_LBDR_input_select_L_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_LBDR_input_select_R_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_ARBITER_input_select_N_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_ARBITER_input_select_E_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_ARBITER_input_select_W_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_ARBITER_input_select_S_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_ARBITER_input_select_L_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_ARBITER_input_select_R_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_XBAR_input_select_N_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_XBAR_input_select_E_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_XBAR_input_select_W_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_XBAR_input_select_S_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_XBAR_input_select_L_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_5x1_XBAR_input_select_R_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_FIFO_output_select_N_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_FIFO_output_select_E_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_FIFO_output_select_W_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_FIFO_output_select_S_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_FIFO_output_select_L_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_LBDR_output_select_N_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_LBDR_output_select_E_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_LBDR_output_select_W_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_LBDR_output_select_S_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_LBDR_output_select_L_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_ARBITER_output_select_N_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_ARBITER_output_select_E_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_ARBITER_output_select_W_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_ARBITER_output_select_S_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_ARBITER_output_select_L_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_XBAR_output_select_N_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_XBAR_output_select_E_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_XBAR_output_select_W_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_XBAR_output_select_S_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:MUX_6x1_XBAR_output_select_L_out
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:Fault_Information_Array_r
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:Unit_Is_Binded_r
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:PATH_STATUS_r
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:Input_MUX_UNIT_r
add wave -noupdate -group fault_control :tb_network_2x2:NoC:R_0:Fault_Control_v2_inst:Output_MUX_UNIT_r
add wave -noupdate -divider {New Divider}
add wave -noupdate -color green -radix decimal :tb_network_2x2:RX_L_0
add wave -noupdate -color green -radix decimal :tb_network_2x2:RX_L_1
add wave -noupdate -color green -radix decimal :tb_network_2x2:RX_L_2
add wave -noupdate -color green -radix decimal :tb_network_2x2:RX_L_3
add wave -noupdate :tb_network_2x2:clk
add wave -noupdate :tb_network_2x2:clk
add wave -noupdate -color green -radix decimal :tb_network_2x2:TX_L_0
add wave -noupdate -color green -radix decimal :tb_network_2x2:TX_L_1
add wave -noupdate -color green -radix decimal :tb_network_2x2:TX_L_2
add wave -noupdate -color green -radix decimal :tb_network_2x2:TX_L_3
add wave -noupdate :tb_network_2x2:clk
add wave -noupdate :tb_network_2x2:clk
add wave -noupdate -color Gold -radix decimal :tb_network_2x2:RX_L_0
add wave -noupdate -color Gold :tb_network_2x2:CTS_L_0
add wave -noupdate -color Gold :tb_network_2x2:DRTS_L_0
add wave -noupdate -color Violet -radix decimal :tb_network_2x2:TX_L_0
add wave -noupdate -color Violet :tb_network_2x2:RTS_L_0
add wave -noupdate -color Violet :tb_network_2x2:DCTS_L_0
add wave -noupdate :tb_network_2x2:clk
add wave -noupdate -color Gold -radix decimal :tb_network_2x2:RX_L_1
add wave -noupdate -color Gold :tb_network_2x2:CTS_L_1
add wave -noupdate -color Gold :tb_network_2x2:DRTS_L_1
add wave -noupdate -color Violet -radix decimal :tb_network_2x2:TX_L_1
add wave -noupdate -color Violet :tb_network_2x2:RTS_L_1
add wave -noupdate -color Violet :tb_network_2x2:DCTS_L_1
add wave -noupdate :tb_network_2x2:clk
add wave -noupdate -color Gold -radix decimal :tb_network_2x2:RX_L_2
add wave -noupdate -color Gold :tb_network_2x2:CTS_L_2
add wave -noupdate -color Gold :tb_network_2x2:DRTS_L_2
add wave -noupdate -color Violet -radix decimal :tb_network_2x2:TX_L_2
add wave -noupdate -color Violet :tb_network_2x2:RTS_L_2
add wave -noupdate -color Violet :tb_network_2x2:DCTS_L_2
add wave -noupdate :tb_network_2x2:clk
add wave -noupdate -color Gold -radix decimal :tb_network_2x2:RX_L_3
add wave -noupdate -color Gold :tb_network_2x2:CTS_L_3
add wave -noupdate -color Gold :tb_network_2x2:DRTS_L_3
add wave -noupdate -color Violet -radix decimal :tb_network_2x2:TX_L_3
add wave -noupdate -color Violet :tb_network_2x2:RTS_L_3
add wave -noupdate -color Violet :tb_network_2x2:DCTS_L_3
add wave -noupdate :tb_network_2x2:clk
add wave -noupdate :tb_network_2x2:NoC:R_0:FIFO_L:full
add wave -noupdate :tb_network_2x2:NoC:R_1:FIFO_L:full
add wave -noupdate :tb_network_2x2:NoC:R_2:FIFO_L:full
add wave -noupdate :tb_network_2x2:NoC:R_3:FIFO_L:full
add wave -noupdate :tb_network_2x2:clk
add wave -noupdate :tb_network_2x2:NoC:R_0:FIFO_L:empty
add wave -noupdate :tb_network_2x2:NoC:R_1:FIFO_L:empty
add wave -noupdate :tb_network_2x2:NoC:R_2:FIFO_L:empty
add wave -noupdate :tb_network_2x2:NoC:R_3:FIFO_L:empty
add wave -noupdate :tb_network_2x2:clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 396
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
WaveRestoreZoom {0 ps} {210 ns}
