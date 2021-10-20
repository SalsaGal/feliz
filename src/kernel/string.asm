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

; IN:
; al - number
; es:di - location to write string
feliz_string_byte_to_ascii:
    pusha
    mov ah, 0xe
    mov bx, 0

    ; High nibble
    push ax
    and al, 0xf0
    shr al, 4
    add al, 0x30

    cmp al, 0x3a
    jl .high_not_hex
    add al, 0x27

.high_not_hex:
    stosb
    pop ax

    ; Low nibble
    push ax
    and al, 0x0f
    add al, 0x30

    cmp al, 0x3a
    jl .low_not_hex
    add al, 0x27

.low_not_hex:
    stosb
    pop ax

    popa
    ret

; IN:
; si - String pointer
;
; OUT:
; ax - string length
feliz_string_get_length:
    push si
    mov ax, 0

.loop:
    push ax
    lodsb
    cmp al, 0
    je .end
    pop ax
    inc ax
    jmp .loop

.end:
    pop ax
    pop si
    ret

; IN:
; si - string
;
; OUT:
; ah - value
feliz_string_ascii_to_byte:
    push si
    push bx

    ; Check if it is only one character
    mov ah, byte [si + 1]
    cmp ah, 0
    je .low

.high:
    mov ah, byte [si]
    sub ah, 0x30
    cmp ah, 0xa
    jl .high_not_hex
    sub ah, 0x27

.high_not_hex:
    shl ah, 4
    inc si

.low:
    mov bh, byte [si]
    sub bh, 0x30
    cmp bh, 0xa
    jl .low_not_hex
    sub bh, 0x27

.low_not_hex:
    add ah, bh

    pop bx
    pop si
    ret
