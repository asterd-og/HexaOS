[bits 32]

section .data
fbAddr dd 0xfd000000
white dd 0xffffffff
blue dd 0xff0000ff
magenta dd 0xffff00ff

section .text
global fbInit
global fbSetPix

fbInit:
    push ebp
    mov ebp, esp
    xor ecx, ecx
.l1:
    cmp ecx, 1228800 ; width * height * pixel stride (4)
    je .exit
    mov dword [0xfd000000 + ecx], 0xffffffff
    inc ecx
    jmp .l1
.exit:
    mov esp, ebp
    pop ebp
    ret

fbSetPix:
    push ebp
    mov ebp, esp

    sub esp, 12

    ; esp + 8 = x
    ; esp + 4 = y
    ; esp = color

    mov eax, dword [esp + 4]
    mov ebx, 640

    mul ebx

    mov ecx, eax ; move result to ecx

    mov eax, dword [esp + 8]

    mov dword [0xfd000000 + (eax + ecx)], 0xffffffff

    add esp, 12

    mov esp, ebp
    pop ebp
    ret
