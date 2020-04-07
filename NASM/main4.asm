; file: main4.asm
%include "asm_io.inc"

segment .data
sum dd 0


segment .bss
input resd 1

segment .text
    global asm_main
    extern get_int, print_sum
asm_main:
    enter 0, 0
    pusha
    
    mov edx, 1         ; edx -- i in pseudocode
while_loop:
    push edx
    push dword input
    call get_int
    add esp, 8

    mov eax, [input]
    cmp eax, 0
    je end_while       ; input == 0 then exit loop

    add [sum], eax     ; sum += input

    inc edx
    jmp short while_loop

end_while:
    push dword [sum]
    call print_sum
    pop ecx            ; 程序马上就要结束了, 这里完全可以使用 pop ecx 取代 add esp, 4

    popa
    leave
    ret