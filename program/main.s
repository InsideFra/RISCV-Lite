
a.out:     file format elf32-littleriscv


Disassembly of section .init:

80000000 <_start>:
80000000:	00002197          	auipc	gp,0x2
80000004:	80018193          	addi	gp,gp,-2048 # 80001800 <__global_pointer$>
80000008:	08000117          	auipc	sp,0x8000
8000000c:	ff810113          	addi	sp,sp,-8 # 88000000 <__stack_top>
80000010:	00010433          	add	s0,sp,zero
80000014:	03c0006f          	j	80000050 <main>

Disassembly of section .text:

80000018 <mult>:
80000018:	fe010113          	addi	sp,sp,-32
8000001c:	00812e23          	sw	s0,28(sp)
80000020:	02010413          	addi	s0,sp,32
80000024:	3e800793          	li	a5,1000
80000028:	fef42623          	sw	a5,-20(s0)
8000002c:	00300793          	li	a5,3
80000030:	fef42423          	sw	a5,-24(s0)
80000034:	fec42703          	lw	a4,-20(s0)
80000038:	fe842783          	lw	a5,-24(s0)
8000003c:	02f707b3          	mul	a5,a4,a5
80000040:	00078513          	mv	a0,a5
80000044:	01c12403          	lw	s0,28(sp)
80000048:	02010113          	addi	sp,sp,32
8000004c:	00008067          	ret

80000050 <main>:
80000050:	ff010113          	addi	sp,sp,-16
80000054:	00112623          	sw	ra,12(sp)
80000058:	00812423          	sw	s0,8(sp)
8000005c:	01010413          	addi	s0,sp,16
80000060:	fb9ff0ef          	jal	80000018 <mult>
80000064:	00000793          	li	a5,0
80000068:	00078513          	mv	a0,a5
8000006c:	00c12083          	lw	ra,12(sp)
80000070:	00812403          	lw	s0,8(sp)
80000074:	01010113          	addi	sp,sp,16
80000078:	00008067          	ret
