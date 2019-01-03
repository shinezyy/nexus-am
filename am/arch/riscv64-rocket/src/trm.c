#include <am.h>
#include <klib.h>
#include "riscv64-rocket.h"

extern char _end;
extern int main();
extern void uart_init();
extern void uart_send(uint8_t data);

_Area _heap = {
  .start = &_end,
};

void _putc(char ch) {
  uart_send(ch);
  if (ch == '\n') {
    uart_send('\r');
  }
}

void puts(const char *s) {
  for (const char *p = s; *p; p ++) {
    _putc(*p);
  }
}

void _halt(int code) {
  puts("Exited (");
  if (code == 0) _putc('0');
  else {
    char buf[10], *p = buf + 9;
    for (*p = 0; code; code /= 10) {
      *(-- p) = '0' + code % 10;
    }
    puts(p);
  }
  puts(").\n");

  // asm volatile("csrwi 0x800, 0");
  while (1);
}

static volatile int test;

void _trm_init() {
  uart_init();

  // microbnch needs at least 128MB
  int mem_size = 0x8000000;
  _heap.end = (void *)0x100000000 + mem_size;

  int ret = main();
  _halt(ret);
}
