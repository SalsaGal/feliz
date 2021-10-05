jmp boot_start

boot_start:
    mov ax, 0x07c0
    mov ds, ax

    mov si, boot_text_start
    call boot_string

    jmp $

boot_string:
    push ax
    mov ah, 0xe

.loop:
    lodsb
    cmp al, 0
    je .end
    int 0x10
    jmp .loop

.end:
    pop ax
    ret

boot_text_start: db "Boot start",0

times 510-($-$$) db 0
dw 0xaa55
