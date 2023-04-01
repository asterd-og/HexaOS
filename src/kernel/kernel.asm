[bits 32]

section .data
    gdtLoaded db "GDT Loaded.", 0x10, 0
    startup db "HexaOS started up!", 0x10, 0

section .text
global main
extern gdtInit
extern vgaWrite
extern vgaClear

main:
    push ebp
    mov ebp, esp ; set up new stack
    sub esp, 12

    call gdtInit

    mov esi, gdtLoaded
    call vgaWrite

    mov esi, startup
    call vgaWrite

    add esp, 12
    jmp $