ISONAME = HexaOS.iso
CXX := i686-elf-g++
CC := i686-elf-gcc

KOUT = kernel.elf

LD := i686-elf-ld

LVL5_PAGING = 0

# User controllable linker flags. We set none by default.
LDFLAGS ?=

# Internal C flags that should not be changed by the user.
CXXFLAGS=-Isrc/ -Wall -Wextra -pedantic -m32 -O0 -std=c99 -finline-functions -ffreestanding -DVBE_MODE
		 
# Internal linker flags that should not be changed by the user.
override INTERNALLDFLAGS :=    \
	-Tconf\linker.ld       \
	-melf_i386			   \

override ASMFILES := $(shell dir /S /B *.asm)
override OBJ := $(ASMFILES:.asm=.o)

.PHONY: all
all: $(ISONAME) run clean
	rm -rf iso_root $(OBJ) $(KOUT) $(ISONAME)

run:
	qemu-system-i386 -M q35 -m 2G -smp 1 -s -cdrom $(ISONAME) -boot d -no-reboot -no-shutdown --serial stdio

uefi: $(ISONAME) run-uefi clean

limine:
	git clone https://github.com/limine-bootloader/limine.git --branch=v4.x-branch-binary --depth=1
	make -C limine

kernel: $(OBJ)
	$(LD) $(OBJ) $(LDFLAGS) $(INTERNALLDFLAGS) -o $(KOUT)

%.o: %.asm
	@echo Compiling $< to $@
	@nasm -felf $< -o $@

$(ISONAME): limine kernel
	@-rd /s /q iso_root
	@mkdir iso_root
	@copy $(KOUT) iso_root
	@copy conf\limine.cfg iso_root
	@copy limine\limine.sys iso_root
	@copy limine\limine-cd.bin iso_root
	@copy limine\limine-cd-efi.bin iso_root
	@xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-cd-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso_root -o $(ISONAME)
	@limine\limine-deploy $(ISONAME)
	@-rd /s /q iso_root

clean:
	@-rd /s /q iso_root
	@-del /q $(ISONAME) $(OBJ) $(KOUT)
