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

; IN:
; si - string (changes the instances of the token to 0)
; di - destination for list of token offsets (puts null at the end)
; ah - token for splitting
feliz_string_split:
    pusha

    ; Push the first token
    mov word [di], si
    add di, 2

.loop:
    lodsb
    cmp al, 0
    je .end
    cmp al, ah
    jne .loop
    mov word [di], si
    mov byte [si - 1], 0
    add di, 2
    jmp .loop

.end:
    ; Put a final null byte at the end to mark the end
    mov word [di], 0
    popa
    ret
