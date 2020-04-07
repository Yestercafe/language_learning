#include <stdio.h>

int asm_main(void);
void dump_line(void);

int main()
{
    return asm_main();
}

void dump_line()
{
    int ch;
    while ((ch = getchar()) != EOF && ch != '\n')
        continue;
}
