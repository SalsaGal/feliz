jmp boot_start

boot_start:
    mov ax, 0x07c0
    mov ds, ax

    jmp $

times 510-($-$$) db 0
dw 0xaa55
