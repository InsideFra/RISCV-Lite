/opt/riscv/bin/riscv32-unknown-linux-gnu-as -o sim/main.o sim/main.s
/opt/riscv/bin/riscv32-unknown-linux-gnu-ld -o sim/main.elf sim/main.o
/opt/riscv/bin/riscv32-unknown-linux-gnu-objcopy -O binary sim/main.elf sim/main.bin
hexdump -e '"%08x\n"' sim/main.bin > sim/main.hex
csplit -z sim/main.hex '/\*/' '{*}'; mv xx00 sim/main_hex.txt; mv xx01 sim/data_hex.txt