.globl _start

.data
nine: .word 0x9
.word 0xffffffd2
.word 0x15
.word 0xfffffffe
.word 0xe
.word 0x001a1001
.word 0xfffffffd

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
	lui	a5,0x10010
	sw	a0,28(a5) # 1001001c <.text+0x1001001c>
	li	a0,0
	addi	sp,sp,16
	ret

loop_init: 
	lw	a2,0(a0) # 10010000 <.text+0x10010000>
	li	a4,1
	
	srai	a5,a2,0x1f
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
	
	bge	a4,a1, end_loop
	
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
