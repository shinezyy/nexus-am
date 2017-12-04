.section entry, "ax"
.globl _start
.type _start, @function

_start:
  j here
.align 2
magic_num:
  .word 0xdeadbeef
here:
  la sp, stack_end
  tail _trm_init

.align 3
stack:
  .skip 0x4000
stack_end:
