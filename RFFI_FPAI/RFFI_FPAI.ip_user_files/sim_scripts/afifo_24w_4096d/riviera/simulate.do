onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+afifo_24w_4096d -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.afifo_24w_4096d xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {afifo_24w_4096d.udo}

run -all

endsim

quit -force
