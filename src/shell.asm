; IN:
; SI - String pointer
feliz_shell_print_string:
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
