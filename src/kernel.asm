feliz_kernel_start:
    ; Update data segment
    mov ax, 0x0800
    mov ds, ax

    mov si, feliz_kernel_text_start
    call feliz_shell_print_string
    
    jmp $

feliz_kernel_text_start: db "Kernel: Started", 0

%include "shell.asm"
