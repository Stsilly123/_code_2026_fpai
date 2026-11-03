# aclk {FREQ_HZ 100000000 CLK_DOMAIN exdes_gp_axi_aclk PHASE 0.000}
# Clock Domain: exdes_gp_axi_aclk
create_clock -name aclk -period 10.000 [get_ports aclk]
# Generated clocks
