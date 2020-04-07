; sub4.asm
%include "asm_io.inc"

segment .data
prompt db  ") Enter an integer number (0 to quit): ", 0

segment .text
    global get_int, print_sum
get_int:
    enter 0, 0

    mov eax, [ebp + 12]
    call print_int

    mov eax, prompt
    call print_string

    call read_int
    mov ebx, [ebp + 8]
    mov [ebx], eax             ; 将输入存储到内存中

    leave
    ret

segment .data
result db "The sum is ", 0

segment .text
print_sum:
    enter 0, 0

    mov eax, result
    call print_string

    mov eax, [ebp + 8]
    call print_int
    call print_nl

    leave
    ret