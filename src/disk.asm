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
