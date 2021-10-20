jmp feliz_boot_start

feliz_boot_start:
    ; Set data segment
    mov ax, 0x07c0
    mov ds, ax

    ; Set stack segment
    add ax, 0x0200
    mov ss, ax

    mov si, feliz_boot_text_start
    call feliz_boot_string

    ; Reset disk
    mov ax, 0
    int 0x13
    jc .feliz_boot_fail_disk_reset

    ; Load sectors with kernel
    mov ah, 2
    mov al, 4   ; Sector count
    mov ch, 0
    mov cl, 2
    mov dh, 0
    
    mov bx, 0x800
    mov es, bx
    mov bx, 0
    int 0x13
    jc .feliz_boot_fail_load_kernel

    mov si, feliz_boot_text_kernel_loaded
    call feliz_boot_string

    jmp 0:0x8000

.feliz_boot_fail_disk_reset:
    mov si, feliz_boot_text_fail_reset
    call feliz_boot_string
    mov al, ah
    call feliz_boot_print_number
    jmp $

.feliz_boot_fail_load_kernel:
    mov si, feliz_boot_text_fail_load
    call feliz_boot_string
    mov al, ah
    call feliz_boot_print_number
    jmp $

; IN:
; al - number
feliz_boot_print_number:
    pusha
    mov ah, 0xe
    mov bx, 0

    ; High nibble
    push ax
    and al, 0xf0
    shr al, 4
    add al, 0x30
    int 0x10
    pop ax

    ; Low nibble
    push ax
    and al, 0x0f
    add al, 0x30
    int 0x10
    pop ax

    popa
    ret

feliz_boot_string:
    push ax
    mov ah, 0xe

.loop:
    lodsb
    cmp al, 0
    je .end
    int 0x10
    jmp .loop

.end:
    pop ax
    ret

feliz_boot_text_start: db "Boot: Started", 0xa, 0xd, 0
feliz_boot_text_kernel_loaded: db "Boot: Kernel loaded", 0xa, 0xd, 0
feliz_boot_text_fail_reset: db "Boot: Failed disk reset #", 0
feliz_boot_text_fail_load: db "Boot: Failed to load kernel #", 0

times 510-($-$$) db 0
dw 0xaa55
