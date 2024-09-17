
sim/main.o:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	1fc18197          	auipc	gp,0x1fc18
   4:	01c18193          	addi	gp,gp,28 # 1fc1801c <end_loop+0x1fc17e94>
   8:	7fbff117          	auipc	sp,0x7fbff
   c:	ff410113          	addi	sp,sp,-12 # 7fbfeffc <end_loop+0x7fbfee74>
  10:	00010433          	add	s0,sp,zero
  14:	008000ef          	jal	1c <main>

00000018 <infinite_loop>:
  18:	0000006f          	j	18 <infinite_loop>

0000001c <main>:
  1c:	10010537          	lui	a0,0x10010
  20:	ff010113          	addi	sp,sp,-16
  24:	00700593          	li	a1,7
  28:	00050513          	mv	a0,a0
  2c:	00112623          	sw	ra,12(sp)
  30:	020000ef          	jal	50 <loop_init>
  34:	00c12083          	lw	ra,12(sp)
  38:	00000797          	auipc	a5,0x0
  3c:	00078793          	mv	a5,a5
  40:	00a7a023          	sw	a0,0(a5) # 38 <main+0x1c>
  44:	00000513          	li	a0,0
  48:	01010113          	addi	sp,sp,16
  4c:	00008067          	ret

00000050 <loop_init>:
  50:	00052603          	lw	a2,0(a0) # 10010000 <end_loop+0x1000fe78>
  54:	00100713          	li	a4,1
  58:	41f65793          	srai	a5,a2,0x1f
  5c:	00c7c633          	xor	a2,a5,a2
  60:	40f60633          	sub	a2,a2,a5
  64:	001478b3          	and	a7,s0,ra
  68:	00400937          	lui	s2,0x400
  6c:	03490913          	addi	s2,s2,52 # 400034 <end_loop+0x3ffeac>
  70:	11289c63          	bne	a7,s2,188 <end_loop>
  74:	001468b3          	or	a7,s0,ra
  78:	7ffff937          	lui	s2,0x7ffff
  7c:	ffc90913          	addi	s2,s2,-4 # 7fffeffc <end_loop+0x7fffee74>
  80:	11289463          	bne	a7,s2,188 <end_loop>
  84:	01200913          	li	s2,18
  88:	012418b3          	sll	a7,s0,s2
  8c:	bff00937          	lui	s2,0xbff00
  90:	0f289c63          	bne	a7,s2,188 <end_loop>
  94:	01200913          	li	s2,18
  98:	012458b3          	srl	a7,s0,s2
  9c:	00002937          	lui	s2,0x2
  a0:	fff90913          	addi	s2,s2,-1 # 1fff <end_loop+0x1e77>
  a4:	0f289263          	bne	a7,s2,188 <end_loop>
  a8:	01200913          	li	s2,18
  ac:	412458b3          	sra	a7,s0,s2
  b0:	00002937          	lui	s2,0x2
  b4:	fff90913          	addi	s2,s2,-1 # 1fff <end_loop+0x1e77>
  b8:	0d289863          	bne	a7,s2,188 <end_loop>
  bc:	01200913          	li	s2,18
  c0:	012428b3          	slt	a7,s0,s2
  c4:	00000913          	li	s2,0
  c8:	0d289063          	bne	a7,s2,188 <end_loop>
  cc:	80000937          	lui	s2,0x80000
  d0:	fff90913          	addi	s2,s2,-1 # 7fffffff <end_loop+0x7ffffe77>
  d4:	012428b3          	slt	a7,s0,s2
  d8:	00100913          	li	s2,1
  dc:	0b289663          	bne	a7,s2,188 <end_loop>
  e0:	fff00913          	li	s2,-1
  e4:	012428b3          	slt	a7,s0,s2
  e8:	00000913          	li	s2,0
  ec:	09289e63          	bne	a7,s2,188 <end_loop>
  f0:	fff00913          	li	s2,-1
  f4:	012438b3          	sltu	a7,s0,s2
  f8:	00100913          	li	s2,1
  fc:	09289663          	bne	a7,s2,188 <end_loop>
 100:	0f0f1437          	lui	s0,0xf0f1
 104:	f0f40413          	addi	s0,s0,-241 # f0f0f0f <end_loop+0xf0f0d87>
 108:	f0f0f337          	lui	t1,0xf0f0f
 10c:	0f030313          	addi	t1,t1,240 # f0f0f0f0 <end_loop+0xf0f0ef68>
 110:	0f047893          	andi	a7,s0,240
 114:	00000e17          	auipc	t3,0x0
 118:	000e0e13          	mv	t3,t3
 11c:	005e2023          	sw	t0,0(t3) # 114 <loop_init+0xc4>
 120:	00000913          	li	s2,0
 124:	07289263          	bne	a7,s2,188 <end_loop>
 128:	0f036393          	ori	t2,t1,240
 12c:	00000e17          	auipc	t3,0x0
 130:	000e0e13          	mv	t3,t3
 134:	007e2023          	sw	t2,0(t3) # 12c <loop_init+0xdc>
 138:	1002a393          	slti	t2,t0,256
 13c:	00000e17          	auipc	t3,0x0
 140:	000e0e13          	mv	t3,t3
 144:	007e2023          	sw	t2,0(t3) # 13c <loop_init+0xec>
 148:	10033393          	sltiu	t2,t1,256
 14c:	00000e17          	auipc	t3,0x0
 150:	000e0e13          	mv	t3,t3
 154:	007e2023          	sw	t2,0(t3) # 14c <loop_init+0xfc>
 158:	02b75863          	bge	a4,a1,188 <end_loop>
 15c:	00259593          	slli	a1,a1,0x2
 160:	00450713          	addi	a4,a0,4
 164:	00b50533          	add	a0,a0,a1

00000168 <loop_body>:
 168:	00072783          	lw	a5,0(a4)
 16c:	00470713          	addi	a4,a4,4
 170:	41f7d693          	srai	a3,a5,0x1f
 174:	00f6c7b3          	xor	a5,a3,a5
 178:	40d787b3          	sub	a5,a5,a3
 17c:	00c7d463          	bge	a5,a2,184 <label5>
 180:	00078613          	mv	a2,a5

00000184 <label5>:
 184:	fee512e3          	bne	a0,a4,168 <loop_body>

00000188 <end_loop>:
 188:	00060513          	mv	a0,a2
 18c:	00008067          	ret
