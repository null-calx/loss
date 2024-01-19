.PHONE: all
all: run

boot.bin: boot.asm
	nasm -f bin $< -o $@

run: boot.bin
	qemu-system-x86_64 $<
