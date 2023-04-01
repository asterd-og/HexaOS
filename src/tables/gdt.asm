section .data
    data: dq 0x0000000000000000
          dq 0x00009a000000ffff ; 16-bit code
          dq 0x000093000000ffff ; 16-bit data
          dq 0x00cf9a000000ffff ; 32-bit code
          dq 0x00cf93000000ffff ; 32-bit data
    gdt: dw 19
         dd data
    ; Borked from AstroNovaOS (my old OS)

section .text
global gdtInit
gdtInit:
    push ebp
    mov ebp, esp

    lgdt [gdt]

    mov esp, ebp ; Restore old stack and return
    pop ebp
    ret