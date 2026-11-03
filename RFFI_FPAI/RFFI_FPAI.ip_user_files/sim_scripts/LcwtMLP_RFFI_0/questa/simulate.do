onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib LcwtMLP_RFFI_0_opt

do {wave.do}

view wave
view structure
view signals

do {LcwtMLP_RFFI_0.udo}

run -all

quit -force
