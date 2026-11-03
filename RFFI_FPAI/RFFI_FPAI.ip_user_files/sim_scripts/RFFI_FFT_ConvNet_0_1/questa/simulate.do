onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib RFFI_FFT_ConvNet_0_opt

do {wave.do}

view wave
view structure
view signals

do {RFFI_FFT_ConvNet_0.udo}

run -all

quit -force
