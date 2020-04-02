; file: memory.asm
global asm_copy, asm_find, asm_strlen, asm_strcpy

segment .text
; function asm_copy
; 复制内存块
; C 原型
; void asm_copy(void* dest, const void* src, unsigned sz);
; 参数:
;   dest - 指向复制操作的目的缓冲区指针
;   src  - 指向复制操作的源缓冲区指针
;   sz   - 需要复制的字节数

%define dest [ebp+8]
%define src  [ebp+12]
%define sz   [ebp+16]
asm_copy:
    enter 0, 0
    push esi
    push edi

    mov esi, src
    mov edi, dest
    mov ecx, sz

    cld
    rep movsb          ; 从 [DS:ESI] 向 [ES:EDI] 拷贝

    pop edi
    pop esi
    leave
    ret

; function asm_find
; 根据一给定的字节值查找内存
; void* asm_fin(const void* src, char target, unsigned sz);
; 参数:
;   src    - 指向需要查找的缓冲区的指针
;   target - 需要查找的字节值
;   sz     - 在缓冲区中的字节总数
; 返回值:
;   如果找到了 target, 返回指向在缓冲区中第一次出现 target 的地方的指针
;   否则
;     返回NULL
; 注意: target 是一个字节值, 但是被当作一个双字压入栈中.
;      字节值存储在低八位上.
%define src    [ebp+8]
%define target [ebp+12]
%define sz     [ebp+16]
asm_find:
    enter 0, 0
    push edi

    mov eax, target        ; 真正要使用的是 AL
    mov edi, src
    mov ecx, sz
    cld
    
    repne scasb            ; 扫描直到 ECX = 0 或 [ES:EDI] = AL 才停止

    je found_it            ; 如果 ZF = 1, 就是找到了
    mov eax, 0             ; 如果没找到, 返回 NULL
    jmp short quit

found_it:
    mov eax, edi
    dec eax                ; 如果找到了, 就返回(DI - 1), 因为多加了
quit:
    pop edi
    leave
    ret

; function asm_strlen
; 返回字符串的长度
; unsigned asm_strlen(const char *);
; 参数:
;   src - 指向字符串的指针
; 返回值:
;   字符串中的字符数

%define src [ebp+8]
asm_strlen:
    enter 0,0
    push edi

    mov edi, src
    mov ecx, 0FFFFFFFFh    ; ECX 设置尽可能大的初值
    xor al, al
    cld

    repnz scasb            ; 扫描终止符 0

    mov eax, 0FFFFFFFEh
    sub eax, ecx;          ; eax = 0xFFFFFFFE - (0xFFFFFFFF - n_loop - 1), 因为 repnz 会多执行一步

    pop edi
    leave
    ret

; function asm_strcpy
; 复制一个字符串
; void asm_strcpy(char* dest, const char* src)
; 参数:
;   dest - 指向进行复制操作的目的字符串
;   src  - 指向进行复制操作的源字符串

%define dest [ebp+8]
%define src  [ebp+12]
asm_strcpy:
    enter 0, 0
    push esi
    push edi

    mov esi, src
    mov edi, dest
    xor al, al
    cld

cpy_loop:
    lodsb            ; 关于为什么不能把两个合并
    stosb            ; 是因为作为"中间变量"的 AL 是有用的
    or al, al        ; 这个运算看似没有用, 但是会设置 ZF, 如果 al 为 0, ZF 会置位
    jnz cpy_loop     ; 如果 ZF 没置位, 则继续

    pop edi
    pop esi
    leave
    ret