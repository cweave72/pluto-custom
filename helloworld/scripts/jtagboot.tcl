puts "Booting from jtag"
set bitfile export/System_top.bit
set fsbl export/fsbl.elf
set app  export/helloworld.elf

puts "Connecting..."
connect -url tcp:192.168.1.8:3121
target -set -nocase -filter {name =~ "ARM*#0"} -index 0
rst -system

puts "Programming PL"
fpga -f $bitfile

puts "Programming fsbl"
dow $fsbl
con

puts "Programming app"
dow $app
con
