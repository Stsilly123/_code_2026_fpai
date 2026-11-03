create_clock -period 5.000 -name sclk [get_ports clk]
set_input_delay  -clock sclk 0.500 [get_ports -filter {NAME != "clk"}]
set_output_delay -clock sclk 0.500 [all_outputs]
