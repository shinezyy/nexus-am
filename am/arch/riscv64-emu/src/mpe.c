#include <am.h>
#include "riscv64-emu.h"

int _cpu(void) {
  return read_const_csr(mhartid);
}
