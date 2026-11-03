onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib log2_lut_rom_opt

do {wave.do}

view wave
view structure
view signals

do {log2_lut_rom.udo}

run -all

quit -force
