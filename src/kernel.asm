feliz_kernel_start:
    ; Update data segment
    mov ax, 0x0800
    mov ds, ax
    mov es, ax

    mov si, feliz_kernel_text_start
    call feliz_shell_print_string

    call feliz_shell_clear_screen

.shell:
    mov di, shell_buffer
    call feliz_shell_prompt

    mov si, shell_buffer
    call feliz_shell_print_line

    mov al, 0
.clear_buffer:
    stosb
    cmp di, shell_buffer_end + 1
    jle .clear_buffer

    jmp .shell

feliz_kernel_text_start: db "Kernel: Started", 0

%include "keyboard.asm"
%include "shell.asm"

shell_buffer: times 80 db 0
shell_buffer_end:
