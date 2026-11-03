onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+afifo_16i_64o_largebuf -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.afifo_16i_64o_largebuf xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {afifo_16i_64o_largebuf.udo}

run -all

endsim

quit -force
