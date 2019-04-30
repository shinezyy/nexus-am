.section entry, "ax"
.globl _start
.type _start, @function

_start:
  j here
.align 2
magic_num:
  .word 0xdeadbeef
  # dtb will be put here
  # 8K should be enough
  .skip 0x2000
here:
  # load mtvec and make sure it sticks
  la t0, handle_trap
  csrw mtvec, t0
  csrr t1, mtvec
1:bne t0, t1, 1b

  # this is PARD custom CSR: real Hart ID
  csrr  a0,0x810
  # only let hart 0 run
2:bne a0, zero, 2b

  la sp, stack_end
  tail _trm_init



handle_trap:
  # exception stack (for simulation)
  la sp, exception_stack
  tail bad_trap

.align 3
stack:
  .skip 0x4000
exception_stack:
  .skip 0x4000
stack_end:
