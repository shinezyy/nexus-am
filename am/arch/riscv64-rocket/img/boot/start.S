.section entry, "ax"
.globl _start
.type _start, @function

.extern fdt

_start:
  j here
.align 2
magic_num:
  .word 0xdeadbeef
here:
  la sp, stack_end
  la t0, fdt
  sd x11, (t0)
  tail _trm_init

stack:
  .skip 0x4000
stack_end:
