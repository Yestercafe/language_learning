; file: sub5.asm
; subprogram: calc_sum
; 求整数 1 到 n 的和
; 参数:
;   n - 从 1 加到多少 ([ebp+8])
;   sump - 指向总数的 `int *` 指针 ([ebp+12])
; pseudocode:
; void calc_sum(int n, int *sump)
; {
;     int i, sum = 0;
;     for (i = 1; i <= n; i++)
;         sum += i;
;     *sump = sum;
; }
%include "asm_io.inc"

segment .text
    global calc_sum
;
; 局部变量:
;   存储在 [ebp - 4] 里的 sum 值
calc_sum:
    enter 4, 0
    push ebx               ; 重要!!

    mov dword [ebp-4], 0   ; sum = 0
    dump_stack 1, 2, 4     ; 输出堆栈中从 ebp-8 到 ebp+16 的值
    mov ecx, 1             ; ecx -- i in pseudocode
for_loop:
    cmp ecx, [ebp+8]       ; 比较 i 和 n
    jnle end_for           ; 如果 i > n, 则退出循环; 这里表达 !(i <= n) 的逻辑更符合 pseudocode 的意思

    add [ebp-4], ecx       ; sum += 1
    inc ecx                ; i++
    jmp short for_loop

end_for:
    mov ebx, [ebp+12]      ; ebx = sump
    mov eax, [ebp-4]       ; eax = sum
    mov [ebx], eax         ; *sump = sum

    pop ebx
    leave
    ret