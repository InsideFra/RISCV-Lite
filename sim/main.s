.globl _start

.data
.word 0x9
.word 0xffffffd2
.word 0x15
.word 0xfffffffe
.word 0xe
.word 0x001a1001
.word 0xfffffffd

result: .word 0xffffffff

result_andi: .word 1
result_ori:  .word 1
result_slti: .word 1
result_sltiu: .word 1

.text
_start:
	auipc	gp,0x1fc18
	addi	gp,gp,28 # 1fc1801c <.text+0x1fc1801c>
	auipc	sp,0x7fbff
	addi	sp,sp,-12 # 7fbfeffc <.text+0x7fbfeffc>
	add	s0,sp,zero
	jal	main
infinite_loop:
	j	infinite_loop
main:
	lui	a0,0x10010
	addi	sp,sp,-16
	li	a1,7
	mv	a0,a0
	sw	ra,12(sp)
	jal	loop_init

	lw	ra,12(sp)

	la	a5,result
	sw	a0,0(a5) # 1001001c <.text+0x1001001c>
	li	a0,0

	addi	sp,sp,16
	ret

loop_init:
	lw	a2,0(a0) # 10010000 <.text+0x10010000>
	li	a4,1

	srai a5,a2,0x1f
	xor	a2,a5,a2
	sub	a2,a2,a5

	and 	a7, s0, ra
	li	s2, 0x00400034
	bne	a7, s2, end_loop

	or 	a7, s0, ra
	li	s2, 0x7fffeffc
	bne	a7, s2, end_loop

	li 	s2, 0x12
	sll 	a7, s0, s2
	li	s2, 0xbff00000
	bne	a7, s2, end_loop

	li 	s2, 0x12
	srl a7, s0, s2
	li	s2, 0x1fff
	bne	a7, s2, end_loop

	li 	s2, 0x12
	sra a7, s0, s2
	li	s2, 0x1fff
	bne	a7, s2, end_loop

	li 	s2, 0x12
	slt 	a7, s0, s2
	li	s2, 0x0
	bne	a7, s2, end_loop

	li 	s2, 0x7fffffff
	slt 	a7, s0, s2
	li	s2, 0x1
	bne	a7, s2, end_loop

	li 	s2, 0xffffffff
	slt 	a7, s0, s2
	li	s2, 0x0
	bne	a7, s2, end_loop

	li 	s2, 0xffffffff
	sltu 	a7, s0, s2
	li	s2, 0x1
	bne	a7, s2, end_loop

    # Initialize registers
    li s0, 0x0F0F0F0F  # Load immediate value into t0
    li t1, 0xF0F0F0F0  # Load immediate value into t1

    # Test ANDI instruction
    andi a7, s0, 0x0F0  # t2 = t0 & 0x0F0
    la t3, result_andi  # Load address of result_andi into t3
    sw t0, 0(t3)        # Store result in memory
    li	s2, 0x00000000
	bne	a7, s2, end_loop

    # Test ORI instruction
    ori t2, t1, 0x0F0   # t2 = t1 | 0x0F0
    la t3, result_ori   # Load address of result_ori into t3
    sw t2, 0(t3)        # Store result in memory

    # Test SLTI instruction
    slti t2, t0, 0x100  # t2 = (t0 < 0x100) ? 1 : 0
    la t3, result_slti  # Load address of result_slti into t3
    sw t2, 0(t3)        # Store result in memory

    # Test SLTIU instruction
    sltiu t2, t1, 0x100 # t2 = (t1 < 0x100) ? 1 : 0
    la t3, result_sltiu # Load address of result_sltiu into t3
    sw t2, 0(t3)        # Store result in memory

	bge	a4,a1, end_loop

	rdcycle x0

	slli	a1,a1,0x2
	addi	a4,a0,4
	add	a0,a0,a1

loop_body:
	lw	a5,0(a4) # a5 is loaded with the content of the memory at address a4
	addi	a4,a4,4 # a4 contains a memory address which is incremented each iteration

	srai	a3,a5,0x1f
	xor	a5,a3,a5
	sub	a5,a5,a3

	bge	a5,a2, label5
	mv	a2,a5
label5:
	bne	a0, a4, loop_body # A0 contains the address where we should write 2 to stop the simulation

end_loop:
	mv	a0, a2
ret
