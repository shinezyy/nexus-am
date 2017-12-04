#include <am.h>
#include <klib.h>

extern char _end;
extern int main();
extern void uart_init();
extern void uart_send(uint8_t data);

_Area _heap = {
  .start = &_end,
};

void _putc(char ch) {
  uart_send(ch);
}

static void puts(const char *s) {
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

  while (1);
}

void _trm_init() {
  uart_init();

  int mem_size = 0x800000;
  _heap.end = (void *)0x80000000 + mem_size;

  int ret = main();
  _halt(ret);
}
