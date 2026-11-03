onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib xfft_256_opt

do {wave.do}

view wave
view structure
view signals

do {xfft_256.udo}

run -all

quit -force
