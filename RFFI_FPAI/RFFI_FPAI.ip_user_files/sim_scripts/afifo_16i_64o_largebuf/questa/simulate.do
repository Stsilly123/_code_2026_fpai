onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib afifo_16i_64o_largebuf_opt

do {wave.do}

view wave
view structure
view signals

do {afifo_16i_64o_largebuf.udo}

run -all

quit -force
