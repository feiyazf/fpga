onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib tri_rom_opt

do {wave.do}

view wave
view structure
view signals

do {tri_rom.udo}

run -all

quit -force
