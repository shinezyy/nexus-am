.globl intr
.type intr, @function
.globl do_irq
.type do_irq, @function
.extern irq_handle
.set noat

.globl _trap_entry
.type _trapPentry function

# TODO: this should be the real entry
_trap_entry:
  j intr

intr:
	#cli
	mfc0	$k0, $12
	ori		$k0, $k0, 0x2
	mtc0	$k0, $12
	la		$k1, do_irq
	jr		$k1

do_irq:
#pusha
	addiu	$sp,$sp,-176
	sw 		$at, 0x4($sp)
	sw 		$v0, 0x8($sp)
	sw 		$v1, 0xc($sp)
	sw 		$a0, 0x10($sp)
	sw 		$a1, 0x14($sp)
	sw 		$a2, 0x18($sp)
	sw 		$a3, 0x1c($sp)
	sw 		$t0, 0x20($sp)
	sw 		$t1, 0x24($sp)
	sw 		$t2, 0x28($sp)
	sw 		$t3, 0x2c($sp)
	sw 		$t4, 0x30($sp)
	sw 		$t5, 0x34($sp)
	sw 		$t6, 0x38($sp)
	sw 		$t7, 0x3c($sp)
	sw 		$t8, 0x40($sp)
	sw 		$t9, 0x44($sp)
	sw 		$s0, 0x48($sp)
	sw 		$s1, 0x4c($sp)
	sw 		$s2, 0x50($sp)
	sw 		$s3, 0x54($sp)
	sw 		$s4, 0x58($sp)
	sw 		$s5, 0x5c($sp)
	sw 		$s6, 0x60($sp)
	sw 		$s7, 0x64($sp)
	sw 		$k0, 0x68($sp)
	sw 		$k1, 0x6c($sp)
	sw 		$gp, 0x70($sp)
	sw		$sp, 0x74($sp)
	sw 		$fp, 0x78($sp)
	sw 		$ra, 0x7c($sp)
	mfc0	$k0, $14
	sw		$k0, 0x80($sp)
	mfc0	$k0, $13
	sw		$k0, 0x84($sp)
	mfc0	$k0, $12
	sw		$k0, 0x88($sp)
	mfc0	$k0, $8
	sw		$k0, 0x8c($sp)
#give trapframe pointer to a0
	addiu   $a0, $sp, 0x4
#disable the appropriate IM bit to prevent an interrupt loop
	mfc0	$k0, $12
	mfc0	$k1, $13
	andi	$k0, $k0, 0xff00
	and 	$k0, $k0, $k1
	beq		$k0, $zero, SetMaskDone
	# it is interruption, instead of exception
	srl		$k0, $k0, 8
	addiu	$k1, $zero, 0x0
	# clz is used to get the interruption which contains highest priority
	# but we don't have clz instruction
	# thus use loop to simulate it
GetInterruptPriority:
	srl		$k0, $k0, 1
	addiu	$k1, $k1, 0x1
	beq		$k0, $zero, GetInterruptPriority

	#set mask
	addiu	$k0, $zero, 1
	sllv	$k0, $k0, $k1
	srl		$k0, $k0, 1
	mfc0	$k1, $12
	xor		$k1, $k1, $k0
	mtc0	$k1, $12 
SetMaskDone:
	#clear exl to enable nested exception & sti
	mfc0	$k0, $12
	xori	$k0, $k0, 0x2
	mtc0	$k0, $12


	jal		irq_handle

	#cli
	mfc0	$k0, $12
	ori		$k0, $k0, 0x2
	mtc0	$k0, $12
#popa	
	lw 		$at, 0x4($sp)
	lw 		$v0, 0x8($sp)
	lw 		$v1, 0xc($sp)
	lw 		$a0, 0x10($sp)
	lw 		$a1, 0x14($sp)
	lw 		$a2, 0x18($sp)
	lw 		$a3, 0x1c($sp)
	lw 		$t0, 0x20($sp)
	lw 		$t1, 0x24($sp)
	lw 		$t2, 0x28($sp)
	lw 		$t3, 0x2c($sp)
	lw 		$t4, 0x30($sp)
	lw 		$t5, 0x34($sp)
	lw 		$t6, 0x38($sp)
	lw 		$t7, 0x3c($sp)
	lw 		$t8, 0x40($sp)
	lw 		$t9, 0x44($sp)
	lw 		$s0, 0x48($sp)
	lw 		$s1, 0x4c($sp)
	lw 		$s2, 0x50($sp)
	lw 		$s3, 0x54($sp)
	lw 		$s4, 0x58($sp)
	lw 		$s5, 0x5c($sp)
	lw 		$s6, 0x60($sp)
	lw 		$s7, 0x64($sp)
	lw 		$k0, 0x68($sp)
	lw 		$k1, 0x6c($sp)
	lw 		$gp, 0x70($sp)
	lw 		$fp, 0x78($sp)
	lw 		$ra, 0x7c($sp)
	lw 		$sp, 0x74($sp)
	# cp0 regs
	lw		$k0, 0x80($sp)
	mtc0	$k0, $14
	lw		$k0, 0x84($sp)
	mtc0	$k0, $13
	lw		$k0, 0x88($sp)
	ori		$k0, $k0, 0x2
	mtc0	$k0, $12
	lw		$k0, 0x8c($sp)
	mtc0	$k0, $8
	lw 		$k0, 0x68($sp)
	addiu	$sp,$sp,176
	nop
	
	eret
