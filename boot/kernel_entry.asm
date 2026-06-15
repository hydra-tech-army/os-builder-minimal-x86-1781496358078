; kernel_entry.asm — Switch to protected mode and call kernel_main
[BITS 16]
[ORG 0x1000]

switch_to_pm:
    cli                     ; Disable interrupts
    lgdt [gdt_descriptor]   ; Load GDT

    mov eax, cr0
    or eax, 0x1             ; Set PE bit
    mov cr0, eax

    jmp CODE_SEG:init_pm    ; Far jump to 32-bit code

[BITS 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    call KERNEL_OFFSET      ; Call kernel_main

    jmp $

KERNEL_OFFSET equ 0x2000

; GDT
gdt_start:
    dq 0x0                  ; Null descriptor

gdt_code:
    dw 0xFFFF, 0x0000
    db 0x00, 10011010b, 11001111b, 0x00

gdt_data:
    dw 0xFFFF, 0x0000
    db 0x00, 10010010b, 11001111b, 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
