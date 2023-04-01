FMBALIGN  equ  1 << 0            ; align loaded modules on page boundaries
FMEMINFO  equ  1 << 1            ; provide memory map
FVIDMODE  equ  1 << 2            ; try to set graphics mode
FLAGS     equ  FMBALIGN | FMEMINFO | FVIDMODE
MAGIC     equ  0x1BADB002
CHECKSUM  equ -(MAGIC + FLAGS)

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM
    ; address tag
    dd 0   ; header_addr
    dd 0   ; load_addr
    dd 0   ; load_end_addr
    dd 0   ; bss_end_addr
    dd 0   ; entry_addr
    dd 1
    dd 640
    dd 480
    dd 32

section .text
global start
extern main
start:
    mov esp, stack_top
    push ebx
    call main
    hlt

section .bss
align 16
stack_bottom:
resb 0x4000 ; 16 KiB
stack_top: