onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib afifo_24w_4096d_opt

do {wave.do}

view wave
view structure
view signals

do {afifo_24w_4096d.udo}

run -all

quit -force
