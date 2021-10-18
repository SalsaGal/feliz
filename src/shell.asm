; IN:
; es:di - Buffer destination
feliz_shell_prompt:
    pusha

    mov al, '>'
    call feliz_shell_print_char

.loop:
    call feliz_keyboard_wait_for_key

    cmp al, 8
    je .backspace

    cmp al, 0xd
    je .return

    cmp byte [di], 1
    je .loop

    stosb
    call feliz_shell_print_char
    jmp .loop

.backspace:
    cmp byte [di - 1], 1
    je .loop

    ; Move the screen cursor
    mov ah, 0xe
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 8
    int 0x10

    ; Update the value in the buffer
    dec di
    mov byte [di], 0
    
    jmp .loop

.return:
    popa
    call feliz_shell_print_newline
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
    cmp al, 20
    jl .end
    int 0x10
    jmp .loop

.end:
    pop si
    pop ax
    ret

; IN:
; si - String pointer
feliz_shell_print_line:
    call feliz_shell_print_string
    call feliz_shell_print_newline

    ret

feliz_shell_print_newline:
    push ax
    mov ah, 0xe
    mov al, 0xd
    int 0x10
    mov al, 0xa
    int 0x10
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

; IN:
; si - Instruction
;
; OUT:
; carry - set if valid instruction
feliz_shell_instruction_to_call:
    pusha

    ; Determine instruction name
    mov di, .instruction_reboot
    call feliz_string_equal
    jnc .not_reboot

    ; Reboot
    int 0x19
    jmp .end_no_carry

.not_reboot:

.end_carry:
    popa
    stc
    ret

.end_no_carry:
    popa
    clc
    ret

.instruction_reboot: db "reboot", 0
