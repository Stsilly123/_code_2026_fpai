## OOC constraint for the WaveMLP PL design.
## Same scheme as the CNN project's exported OOC xdc: a plain 5.000 ns clock.
## The project's "4 ns" budget is 5 ns minus the 20% uncertainty set in the HLS
## solution, so WNS must be >= +1.000 ns for the effective 4.00 ns target.
create_clock -name ap_clk -period 5.000 [get_ports ap_clk]
