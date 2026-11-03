onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib rindex_buf_2b_16w_opt

do {wave.do}

view wave
view structure
view signals

do {rindex_buf_2b_16w.udo}

run -all

quit -force
