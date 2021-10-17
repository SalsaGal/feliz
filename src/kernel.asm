feliz_kernel_start:
    ; Update data segment
    mov ax, 0x0800
    mov ds, ax
    mov es, ax

    mov si, feliz_kernel_text_start
    call feliz_shell_print_string
    call feliz_shell_clear_screen

    mov si, feliz_kernel_text_welcome
    call feliz_shell_print_line

.shell:
    ; Get the instruction
    call feliz_shell_print_newline
    mov di, shell_buffer
    call feliz_shell_prompt

    ; Handle instruction
    mov si, shell_buffer
    mov di, misc_buffer
    mov ah, ' '
    call feliz_string_split

    mov si, word [misc_buffer]
    call feliz_shell_print_line
    mov si, word [misc_buffer + 2]
    call feliz_shell_print_line
    mov si, word [misc_buffer + 4]
    call feliz_shell_print_line

    mov al, 0
.clear_buffer:
    stosb
    cmp byte [di], 1
    jne .clear_buffer

    jmp .shell

feliz_kernel_text_start: db "Kernel: Started", 0
feliz_kernel_text_welcome: db "FelizOS 0.0", 0
feliz_kernel_text_unknown_command: db "Unknown command: ", 0

%include "keyboard.asm"
%include "serial.asm"
%include "shell.asm"
%include "string.asm"

db 1
shell_buffer: times 78 db 0
db 1
misc_buffer: times 64 db 0
