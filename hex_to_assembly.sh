/opt/riscv32/bin/riscv32-unknown-linux-gnu-as -v -march=rv32i -o sim/main.o sim/main.s
/opt/riscv32/bin/riscv32-unknown-linux-gnu-ld -v -o sim/main.elf sim/main.o
/opt/riscv32/bin/riscv32-unknown-linux-gnu-objcopy -v -O binary sim/main.elf sim/main.bin
hexdump -e '"%08x\n"' sim/main.bin > sim/main.hex
csplit -z sim/main.hex '/\*/' '{*}'; mv xx00 sim/main_hex.txt; mv xx01 sim/data_hex.txt