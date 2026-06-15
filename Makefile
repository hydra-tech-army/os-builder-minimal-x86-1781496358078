# Makefile — Build the OS image

ASM=nasm
CC=i686-elf-gcc
LD=i686-elf-ld

CFLAGS=-ffreestanding -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs

all: os-image.bin

boot.bin: boot/boot.asm
	$(ASM) -f bin $< -o $@

kernel_entry.o: boot/kernel_entry.asm
	$(ASM) -f elf32 $< -o $@

kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel.bin: kernel_entry.o kernel.o
	$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary

os-image.bin: boot.bin kernel.bin
	cat $^ > $@

clean:
	rm -f *.bin *.o

iso: os-image.bin
	mkdir -p iso/boot/grub
	cp os-image.bin iso/boot/
	grub-mkrescue -o myos.iso iso/
