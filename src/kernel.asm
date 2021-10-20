feliz_kernel_call_vectors:
    jmp word feliz_kernel_start
    jmp word feliz_shell_print_char
    jmp word feliz_shell_print_string
    jmp word feliz_keyboard_wait_for_key
    jmp word feliz_serial_print_char
    jmp word feliz_serial_print_string
    jmp word feliz_string_equal
    jmp word feliz_string_split
    jmp word feliz_shell_clear_screen
    jmp word feliz_shell_print_newline
    jmp word feliz_shell_move_cursor
    jmp word feliz_shell_instruction_to_call
    jmp word feliz_string_byte_to_ascii
    jmp word feliz_disk_load

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

    ; Get system calls from command
    call feliz_shell_instruction_to_call
    jc .unknown_instruction

    jmp .finish_instruction

.unknown_instruction:
    ; Print unknown command message
    mov si, feliz_kernel_text_unknown_command
    call feliz_shell_print_string
    mov si, [misc_buffer]
    call feliz_shell_print_line

.finish_instruction:
    mov al, 0
    mov di, shell_buffer
.clear_buffer:
    stosb
    cmp byte [di], 1
    jne .clear_buffer

    jmp .shell

feliz_kernel_panic:
    mov di, misc_buffer

    mov si, .panic_text_0
    call feliz_shell_print_line

    mov si, .panic_text_1
    call feliz_shell_print_string
    push ax
    mov al, ah
    call feliz_string_byte_to_ascii
    pop ax
    mov si, misc_buffer
    call feliz_shell_print_line

    mov si, .panic_text_2
    call feliz_shell_print_string
    call feliz_string_byte_to_ascii
    mov si, misc_buffer
    call feliz_shell_print_line

    mov si, .panic_text_3
    call feliz_shell_print_string
    mov al, bh
    call feliz_string_byte_to_ascii
    mov si, misc_buffer
    call feliz_shell_print_line

    mov si, .panic_text_4
    call feliz_shell_print_string
    mov al, bl
    call feliz_string_byte_to_ascii
    mov si, misc_buffer
    call feliz_shell_print_line

    mov si, .panic_text_5
    call feliz_shell_print_string
    mov al, ch
    call feliz_string_byte_to_ascii
    mov si, misc_buffer
    call feliz_shell_print_line

    mov si, .panic_text_6
    call feliz_shell_print_string
    mov al, cl
    call feliz_string_byte_to_ascii
    mov si, misc_buffer
    call feliz_shell_print_line

    mov si, .panic_text_7
    call feliz_shell_print_string
    mov al, dh
    call feliz_string_byte_to_ascii
    mov si, misc_buffer
    call feliz_shell_print_line

    mov si, .panic_text_8
    call feliz_shell_print_string
    mov al, dl
    call feliz_string_byte_to_ascii
    mov si, misc_buffer
    call feliz_shell_print_line

    jmp $

.panic_text_0: db "FELIZ KERNEL PANIC", 0
.panic_text_1: db "ah: 0x", 0
.panic_text_2: db "al: 0x", 0
.panic_text_3: db "bh: 0x", 0
.panic_text_4: db "bl: 0x", 0
.panic_text_5: db "ch: 0x", 0
.panic_text_6: db "cl: 0x", 0
.panic_text_7: db "dh: 0x", 0
.panic_text_8: db "dl: 0x", 0

feliz_kernel_text_start: db "Kernel: Started", 0
feliz_kernel_text_welcome: db "FelizOS 0.0", 0
feliz_kernel_text_unknown_command: db "Unknown command: ", 0

%include "disk.asm"
%include "keyboard.asm"
%include "serial.asm"
%include "shell.asm"
%include "string.asm"

db 1
shell_buffer: times 78 db 0
db 1
misc_buffer: times 78 db 0
