; IN:
; al - Sector count
; cl - Sector number
; dl - Drive number
;
; OUT:
; es:bx - File cache location
; carry if error
feliz_disk_load_sectors:
    pusha

    mov ah, 2
    mov ch, 0
    mov dh, 0

    int 0x13
    jc .carry

    popa
    clc
    ret

.carry:
    popa
    stc
    ret

; IN:
; di - Address list of tokens
feliz_disk_shell_command:
    pusha

    ; Get subcommand string and compare
    push di
    mov si, [di + 2]

    ; Check that there is a subcommand
    cmp si, 0
    je .missing_subcommand

    ; Help
    mov di, .subcommand_help
    call feliz_string_equal
    jc .print_help

    ; Print unknown subcommand error
    push si
    mov si, .unknown_subcommand_text
    call feliz_shell_print_string
    pop si
    call feliz_shell_print_line
    pop di

    popa
    ret

.print_help:
    mov si, .help_text
    call feliz_shell_print_line

    pop di
    popa
    ret

.missing_subcommand:
    mov si, .missing_subcommand_text
    call feliz_shell_print_line

    pop di
    popa
    ret

.subcommand_help: db "help", 0

.help_text:
db "disk help:", 0xa, 0xd, "  print this help message", 0
.missing_subcommand_text: db "Missing subcommand", 0
.unknown_subcommand_text: db "Unknown subcommand: ", 0