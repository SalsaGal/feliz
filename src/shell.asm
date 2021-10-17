; IN:
; di - Buffer destination
feliz_shell_prompt:
    pusha

    mov al, '>'
    call feliz_shell_print_char

.loop:
    jmp .loop

    popa
    ret

; IN:
; al - Character
feliz_shell_print_char:
    push ax
    mov ah, 0xe
    int 0x10
    pop ax
    ret

; IN:
; si - String pointer
feliz_shell_print_string:
    push ax
    push si
    mov ah, 0xe

.loop:
    lodsb
    cmp al, 0
    je .end
    int 0x10
    jmp .loop

.end:
    pop si
    pop ax
    ret

; IN:
; si - String pointer
feliz_shell_print_line:
    push ax
    push si

    call feliz_shell_print_string

    mov ah, 0xe
    mov al, 0xd
    int 0x10
    mov al, 0xa
    int 0x10

    pop si
    pop ax
    ret

; IN:
; dl - x
; dh - y
feliz_move_cursor:
    pusha

    mov ah, 2
    mov bx, 0
    int 0x10

    popa
    ret

feliz_shell_clear_screen:
    pusha

    mov dx, 0
    call feliz_move_cursor

    mov ah, 6
    mov al, 0
    mov bh, 7
    mov cx, 0
    mov dh, 24
    mov dl, 79
    int 0x10

    popa
    ret
