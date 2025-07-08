[org 0x7c00]
bits 16

; Choose stack segment and pointer (e.g., somewhere safe)
mov ax, 0x9000    ; segment for stack (just an example)
mov ss, ax

mov sp, 0xFFFF    ; stack pointer at top of segment

mov ah, 0x00   ; wait for key
int 0x16       ; result: AL = ASCII code

mov ax, 0x13
int 0x10





mov ax, 0xA000
mov es, ax

gameloop:
    call checkinput
    call update
    call draw

    jmp gameloop

jmp loop


checkinput:

    mov ah, 0x01
    int 0x16
    jz do_ret

    mov ah, 0x00   ; wait for key
    int 0x16       ; result: AL = ASCII code

    cmp al, 'w'
    je upkey
    cmp al, 's'
    je downkey
    cmp al, 'd'
    je rightkey
    cmp al, 'a'
    je leftkey

    ret

do_ret:
    ret

upkey:
    mov byte [inputstate], 0b00001000
    ret
downkey:
    mov byte [inputstate], 0b00000100
    ret
leftkey:
    mov byte [inputstate], 0b00000010
    ret
rightkey:
    mov byte [inputstate], 0b00000001
    ret

update:
    cmp byte [inputstate], 0b00001000
    je movup
    cmp byte [inputstate], 0b00000100
    je movdown
    cmp byte [inputstate], 0b00000010
    je movleft
    cmp byte [inputstate], 0b00000001
    je movright
    ret

movup:
    dec word [posy]
    ret
movdown:
    inc word [posy]
    ret
movleft:
    dec word [posx]
    ret
movright:
    inc word [posx]
    ret

draw:
    pusha

    ;mov ax, 0x13
    ;int 0x10          ; set 320x200x256 graphics mode (mode 13h)

    mov ax, [posy]
    mov bx, 320
    mul bx
    add ax, [posx]
    mov di, ax
    mov al, 15
    mov [es:di], al

    popa
    ret


loop:
    jmp loop

posx:
    dw 100
posy:
    dw 50
inputstate:
    db 0b00000001 ; up 1000, down 0100, left 0010, right 0001


times 510 - ($-$$) db 0
dw 0xaa55