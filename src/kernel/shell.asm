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
    cmp al, 1
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
feliz_shell_move_cursor:
    pusha

    mov ah, 2
    mov bx, 0
    int 0x10

    popa
    ret

feliz_shell_clear_screen:
    pusha

    mov dx, 0
    call feliz_shell_move_cursor

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
; di - Instruction token addresses
;
; OUT:
; carry - set if valid instruction
feliz_shell_instruction_to_call:
    pusha

    push di

    ; Determine instruction name
    mov di, .instruction_reboot
    call feliz_string_equal
    jnc .not_reboot

    ; Reboot
    jmp 0xffff:0
    jmp .end_no_carry

.not_reboot:
    mov di, .instruction_clear
    call feliz_string_equal
    jnc .not_clear

    ; Clear
    call feliz_shell_clear_screen
    jmp .end_no_carry

.not_clear:
    mov di, .instruction_shutdown
    call feliz_string_equal
    jnc .not_shutdown

    ; Shutdown
    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xf000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15

.not_shutdown:
    mov di, .instruction_help
    call feliz_string_equal
    jnc .not_help

    ; Help
    mov si, .help_message
    call feliz_shell_print_line
    jmp .end_no_carry

.not_help:

.end_carry:
    pop di
    popa
    stc
    ret

.end_no_carry:
    pop di
    popa
    clc
    ret

.instruction_clear: db "clear", 0
.instruction_help: db "help", 0
.instruction_reboot: db "reboot", 0
.instruction_shutdown: db "shutdown", 0

.help_message:
db "clear:", 0xa, 0xd, "  clear the screen", 0xa, 0xd
db "help:", 0xa, 0xd, "  print this help message", 0xa, 0xd
db "reboot:", 0xa, 0xd, "  reboot the computer", 0xa, 0xd
db "shutdown:", 0xa, 0xd, "  shutdown the computer"
db 0
