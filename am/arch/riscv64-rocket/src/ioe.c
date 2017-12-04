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
  return _KEY_NONE;
}

