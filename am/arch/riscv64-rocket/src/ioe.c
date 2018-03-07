#include <am.h>
#include "riscv64-rocket.h"

static unsigned long boot_time = 0;
#define HZ 100000000

void _ioe_init() {
  boot_time = read_const_csr(mcycle) / (HZ / 1000);
}

// -------------------- cycles and uptime --------------------

unsigned long _uptime(){
  return read_const_csr(mcycle) / (HZ / 1000) - boot_time;
}

// -------------------- video --------------------


_Screen _screen = {
  .width  = 0,
  .height = 0,
};

void _draw_p(int x, int y, uint32_t p) {
}

void _draw_sync() {
}

// -------------------- keyboard --------------------

static inline int upevent(int e) { return e; }
static inline int downevent(int e) { return e | 0x8000; }

int _read_key(){
  int uart_recv();
  int key = uart_recv();
  if (key == -1) {
    return _KEY_NONE;
  }
  return key;
}

void poweroff(void) __attribute((noreturn));

extern void puts(const char *s);
static void print_b(unsigned char a)
{
  const static char hex_map[][2]={
    "0","1","2","3","4","5","6","7",
    "8","9","a","b","c","d","e","f"}; 
  puts(hex_map[a>>4]);
  puts(hex_map[a&0xf]);
}

static void print_l(unsigned a)
{
  print_b((a>>24)&0xff);
  print_b((a>>16)&0xff);
  print_b((a>>8)&0xff);
  print_b(a&0xff);
}

#define read_csr(reg) ({ unsigned long __tmp; \
    asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
    __tmp; })

void __attribute__((noreturn)) bad_trap()
{
  extern void uart_init();
  // reinitialize uart, make sure it's in correct state
  // so that we can print
  uart_init();
  puts("machine mode: unhandlable trap ");
  print_l(read_csr(mcause));
  puts(" @ ");
  print_l(read_csr(mepc));
  puts("\n");
  poweroff();
}

void poweroff(void) {
  while (1);
}
