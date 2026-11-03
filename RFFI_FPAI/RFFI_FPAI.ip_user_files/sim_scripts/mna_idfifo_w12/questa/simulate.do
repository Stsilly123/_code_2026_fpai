onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib mna_idfifo_w12_opt

do {wave.do}

view wave
view structure
view signals

do {mna_idfifo_w12.udo}

run -all

quit -force
