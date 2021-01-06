## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

## Reset btn[0]
set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { nrst }]; #IO_L16P_T2_35 Sch=ck_rst

# Enable sw[0]
#set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { en }]; #IO_L12N_T1_MRCC_16 Sch=sw[0]

# tx ja[1]
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { tx }]; #IO_0_15 Sch=ja[1]

# rx ja[2
#set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { rx }]; #IO_L4P_T0_15 Sch=ja[2]