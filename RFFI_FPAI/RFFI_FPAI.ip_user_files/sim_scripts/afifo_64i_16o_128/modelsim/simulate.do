onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.afifo_64i_16o_128 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {afifo_64i_16o_128.udo}

run -all

quit -force
