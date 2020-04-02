int main(void) {
    volatile unsigned char uchar = 0xff;
    volatile signed   char schar = 0xff;
    volatile int a = (int) uchar;
    volatile int b = (int) schar;
    return 0;
}