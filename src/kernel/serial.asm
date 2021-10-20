; IN:
; al - Character
feliz_serial_print_char:
    pusha

    mov ah, 1
    mov dx, 0
    int 0x14

    popa
    ret

feliz_serial_print_string:
    push ax
    push si
    mov dx, 0

.loop:
    mov ah, 1
    lodsb
    cmp al, 0
    je .end
    int 0x14
    jmp .loop

.end:
    pop si
    pop ax
    ret
