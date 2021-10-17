; OUT:
; ah - BIOS scan code
; al - ASCII character
feliz_keyboard_wait_for_key:
    mov ah, 0
    int 0x16
    ret
