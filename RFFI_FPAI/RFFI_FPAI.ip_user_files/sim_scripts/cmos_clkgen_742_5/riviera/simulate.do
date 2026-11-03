onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+cmos_clkgen_742_5 -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.cmos_clkgen_742_5 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {cmos_clkgen_742_5.udo}

run -all

endsim

quit -force
