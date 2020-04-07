%define ARRAY_SIZE 100
%define NEW_LINE 10

segment .data
FirstMsg db "First 10 elements of array", 0
Prompt db "Enter index of element to display: ", 0
SecondMsg db "Element %d is %d", NEW_LINE, 0
ThirdMsg db "Elements 20 through 29 of array", 0
InputFormat db "%d", 0

segment .bss
array resd ARRAY_SIZE

segment .text
    extern puts, printf, scanf, dump_line
    global asm_main
asm_main:
    enter 4, 0
    push ebx
    push esi

; initialize array as 100, 99, 98, ...
    mov ecx, ARRAY_SIZE
    mov ebx, array
init_loop:
    mov [ebx], ecx
    add ebx, 4
    loop init_loop

    push dword FirstMsg
    call puts
    pop ecx

    push dword 10
    push dword array
    call print_array
    add esp, 8

Prompt_loop:
    push dword Prompt
    call printf
    pop ecx

    lea eax, [ebp-4]            ; get addr of ebp-4
    push eax
    push dword InputFormat
    call scanf
    add esp, 8
    cmp eax, 1                  ; eax = scanf retval
    je InputOK

    call dump_line
    jmp Prompt_loop

InputOK:
    mov esi, [ebp-4]
    push dword [array + 4*esi]
    push esi
    push dword SecondMsg
    call printf
    add esp, 12

    push dword ThirdMsg
    call puts
    pop ecx

    push dword 10
    push dword array + 20*4
    call print_array
    add esp, 8

    pop esi
    pop ebx
    mov eax, 0
    leave
    ret

; subprogram: print_array
; 调用的 C 程序把双字数组的元素当作有符号整型来显示. 
; C 函数原型:
; void print_array(const int* a, int n);
; 参数:
;   a - pointer to array will be prompted (ebp + 8)
;   n - the number of numbers prompted (ebp + 12)

segment .data
OutputFormat db "%-5d %5d", NEW_LINE, 0

segment .text
    global print_array
print_array:
    enter 0, 0
    push esi
    push ebx

    xor esi, esi                 ; esi = 0
    mov ecx, [ebp + 12]          ; ecx - n
    mov ebx, [ebp + 8]           ; ebx = a
print_loop:
    push ecx                     ; printf 会改变 ecx, 先保存

    push dword [ebx + 4*esi]
    push esi
    push dword OutputFormat
    call printf
    add esp, 12

    pop ecx
    inc esi
    loop print_loop

    push ebx
    pop esi
    leave
    ret