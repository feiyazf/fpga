onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib saw_rom_opt

do {wave.do}

view wave
view structure
view signals

do {saw_rom.udo}

run -all

quit -force
