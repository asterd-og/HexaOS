; This isn't the best KB implementation
; Because i have simply 1% of idea on
; How to implement IDT in assembly!
; (And i don't wanna use external sources
;  Such as github to see other's code)

[bits 32]


section .data
kbMap: db "001234567890-=", 0xb, 0xf, "qwertyuiop[]", 0x10, 0x12, "asdfghjkl;||", 0x13, ";zxcvbnm,.;.;", 0x14, " "
pressed db "key pressed ", 0

section .text
extern vgaWrite
extern vgaWriteChar
global kbRead

inportb:
    push ebp
    mov ebp, esp

    xor al, al

    in al, dx ; result is in al

    mov esp, ebp
    pop ebp
    ret

kbRead:
    push ebp
    mov ebp, esp
.kbLoop:
    xor ax, ax
    xor dx, dx
    
    in al, 0x64

    and ax, 0x1 ; res & 1

    test ax, ax
    jnz .cont

    jmp .kbLoop
.cont:
    xor ax, ax
    in al, 0x60
    cmp al, 57
    jle .kbPrintChar
    jmp .kbLoop
.kbPrintChar:
    mov al, byte [kbMap + eax]
    call vgaWriteChar
    jmp .kbLoop
.exit:
    mov esp, ebp
    pop ebp
    ret