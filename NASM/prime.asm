; file: prime. asm
%include "asm_io.inc"

segment .data
Message db  "Find primes up to: ", 0

segment .bss
Limit resd 1
Guess resd 1

segment .text
    global asm_main
asm_main:
    enter 0, 0
    pusha

    mov eax, Message
    call print_string
    call read_int                ; scanf("%u", &limit);
    mov [Limit], eax

    mov eax, 2                   ; printf("2\n");
    call print_int
    call print_nl
    mov eax, 3                   ; printf("3\n");
    call print_int
    call print_nl

    mov dword [Guess], 5         ; Guess = 5;
while_limit:                     ; while (Guess <= Limit)
    mov eax, [Guess]
    cmp eax, [Limit]
    jnbe end_while_limit         ; use jnbe since numbers are unsigned. 我寻思用ja应该也可以

    mov ebx, 3                   ; `ebx means` factor = 3;
while_factor:
    mov eax, ebx
    mul eax                      ; edx:eax = eax * eax
    jo end_while_factor          ; if answer won’t fit in eax alone
    cmp eax, [Guess]
    jnb end_while_factor         ; if !(factor * factor < guess)
    mov eax, [Guess]
    mov edx, 0
    div ebx                      ; edx = edx:eax % ebx
    cmp edx, 0
    je end_while_factor          ; if !(guess % factor != 0)

    add ebx, 2                   ; factor += 2;
    jmp while_factor
end_while_factor:
    je end_if                    ; if !(guess % factor != 0)
    mov eax, [Guess]
    call print_int
    call print_nl
end_if:
    add dword [Guess], 2         ; guess += 2;
    jmp while_limit
end_while_limit:

    popa 
    mov eax, 0
    leave
    ret