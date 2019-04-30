start.o: start.S
	riscv64-unknown-linux-gnu-gcc -I$(AM_HOME)/am/arch/riscv64-emu/include -fno-pic -ffunction-sections -MMD -c start.S -o start.o

-include start.d
