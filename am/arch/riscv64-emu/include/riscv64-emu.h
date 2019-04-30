#ifndef __RISCV64_ROCKET__
#define __RISCV64_ROCKET__

#define MAX_HARTS 2

#define read_const_csr(reg) ({ unsigned long __tmp; \
    asm ("csrr %0, " #reg : "=r"(__tmp)); \
    __tmp; })

#endif
