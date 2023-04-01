[bits 32]

section .text

pos dd 0
line dd 0

global vgaWrite
global vgaClear

vgaClear:
    push ebp
    mov ebp, esp
    
    mov esp, ebp
    pop ebp
    ret

vgaWrite:
    push ebp
    mov ebp, esp

    push ebx
    push ecx
    push edx

    mov ebx, 0x0700 ; attrib white on black
.loop:
    lodsb

    mov ecx, [pos]

    or al, al
    jz .eLoop

    cmp al, 0x10
    je .nl

    mov ah, 0x0f
    mov word [0xb8000 + ecx], ax
    add ecx, 2

    mov [pos], ecx

    jmp .loop
.nl:
    mov edx, [line]
    inc edx
    mov eax, 160 ;80 * 2 | 80 = vga width 2 = 1-char 1-attrib (color)
    mov ebx, edx
    mul ebx
    mov ecx, eax ;(80 * 2) * line

    mov [pos], ecx
    mov [line], edx
    jmp .loop
.eLoop:
    pop edx
    pop ecx
    pop ebx

    mov esp, ebp ; Restore old stack and return
    pop ebp
    ret