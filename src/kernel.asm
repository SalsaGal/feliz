feliz_kernel_start:
    ; Update data segment
    mov ax, 0x0800
    mov ds, ax

    mov si, feliz_kernel_text_start
    call feliz_shell_print_string

    call feliz_shell_clear_screen

.shell:
    mov di, shell_buffer
    call feliz_shell_prompt
    jmp .shell

feliz_kernel_text_start: db "Kernel: Started", 0

%include "shell.asm"

shell_buffer: times 32 db 0
