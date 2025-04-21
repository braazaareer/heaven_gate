// main.c — compile with i686-w64-mingw32-gcc -m32
#include <stdio.h>

// read CS in 32‑bit compatibility mode
static unsigned short get_cs(void) {
    unsigned short cs;
    __asm__ volatile ("mov %%cs, %0" : "=r"(cs));
    return cs;
}

// our stub
extern void heaven_gate(void);

int main(void) {
    unsigned short before = get_cs();
    printf("CS before: 0x%X\n", before);

    heaven_gate();

    unsigned short after = get_cs();
    printf("CS after:  0x%X\n", after);

    return 0;
}
