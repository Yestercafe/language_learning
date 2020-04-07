#include <stdio.h>

int main(void)
{
    unsigned guess;    // 当前对素数的猜测
    unsigned factor;   // 猜测数的可能的因子
    unsigned limit;    // 查找这个值以下的素数

    printf("Find primes up to: ");
    scanf("%u", &limit);
    printf("2\n");     // 把头两个素数作为特殊情况处理
    printf("3\n");
    guess = 5;         // 初始化猜测数
    while (guess <= limit) {
        factor = 3;
        while (factor * factor > guess &&
               guess % factor != 0)
            factor += 2;
        if (guess % factor != 0)
            printf("%d\n", guess);
        guess += 2;    // 只考虑奇数
    }
}