; boot.asm — Minimal x86 Bootloader
; Assembled with NASM: nasm -f bin boot.asm -o boot.bin

[BITS 16]
[ORG 0x7C00]

start:
    ; Set up segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Print boot message
    mov si, boot_msg
    call print_string

    ; Load kernel from disk (sector 2) to 0x1000
    mov ah, 0x02        ; BIOS read sectors
    mov al, 10          ; Number of sectors to read
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Start from sector 2
    mov dh, 0           ; Head 0
    mov dl, 0x80        ; First hard drive
    mov bx, 0x1000      ; Load to 0x1000
    int 0x13
    jc disk_error

    ; Jump to kernel
    jmp 0x1000

disk_error:
    mov si, err_msg
    call print_string
    hlt

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

boot_msg db "Booting OS...", 13, 10, 0
err_msg  db "Disk read error!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
