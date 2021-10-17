; IN:
; si - string a
; di - string b
; OUT:
; carry if equal
feliz_string_equal:
    pusha

.loop:
    mov al, [si]
    mov bl, [di]

    cmp al, bl
    jne .different

    cmp al, 0
    je .same

    inc si
    inc di
    jmp .loop

.different:
    popa
    clc
    ret

.same:
    popa
    stc
    ret
