[bits 32]

section .data
    gdtLoaded db "GDT Loaded.", 0x10, 0
    startup db 0xae, "HexaOS", 0xaf, " started up!", 0x10, 0

section .text
global main
extern gdtInit
extern kbRead
extern vgaTest

%include "src/video/vga.inc"

main:
    push ebp
    mov ebp, esp ; set up new stack

    call gdtInit

    print gdtLoaded
    print startup

    call kbRead

    jmp $
    mov esp, ebp
    pop ebp
    ret