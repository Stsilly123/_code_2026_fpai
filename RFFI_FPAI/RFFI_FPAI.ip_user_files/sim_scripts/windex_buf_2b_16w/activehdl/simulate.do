onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+windex_buf_2b_16w -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.windex_buf_2b_16w xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {windex_buf_2b_16w.udo}

run -all

endsim

quit -force
