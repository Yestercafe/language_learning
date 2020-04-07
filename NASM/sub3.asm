; file: sub3.asm
%include "asm_io.inc"

segment .data
sum dd 0

segment .bss
input resd 1

; pseudocode
; i = 1;
; sum = 0;
; while (get_int(i, &input), input != 0) {
;     sum += input;
;     i++;
; }
; print_sum(num);

segment .text
    global asm_main
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

; 子程序 get_int
; 参数 (顺序压入栈)
;   输入的个数(储存在[ebp+12]中)
;   储存输入字的地址(储存在[ebp+8]中)
; 注意:
;   eax 和 ebx 的值都被销毁了!
segment .data
prompt db  ") Enter an integer number (0 to quit): ", 0

segment .text
get_int:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 12]
    call print_int

    mov eax, prompt
    call print_string

    call read_int
    mov ebx, [ebp + 8]
    mov [ebx], eax             ; 将输入存储到内存中

    pop ebp
    ret

; 子程序 print_sum
; 输出总数
; 参数:
;   需要输出的总数(储存在[ebp+8]中)
; 注意: eax 的值被销毁了
; 
segment .data
result db "The sum is ", 0

segment .text
print_sum:
    push ebp
    mov ebp, esp

    mov eax, result
    call print_string

    mov eax, [ebp + 8]
    call print_int
    call print_nl

    pop ebp
    ret