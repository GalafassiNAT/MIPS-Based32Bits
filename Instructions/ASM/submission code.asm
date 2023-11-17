MAIN:
addi $s0, $0, 10 # a=10
addi $s1, $0, 5 # b=5
add $s3, $0, $s1 # c=a

add $t0, $zero, $zero #i=0
add $t1, $0, $0 #j=0


LOOPA:
	slt $t3, $t0, $s1
	# se i >= b, pula pra ENDA
	beq $t3, $0, ENDA # diferente do Jump, beq recebe um imediato no lugar da label
	LOOPB:
		# if a < j, t4 = 1
		slt $t4, $t1, $s0
		addi $s6, $0, 1
		bne $t4, $s6, ENDB
			add $s3, $s3, $s3
			addi $t5, $0, 80
			beq $s3, $t5, ENDA
		
		addi $t1, $t1, 1
		j LOOPB
		ENDB:
		addi $s0, $s0, 1
	j LOOPA

ENDA:
add $a0, $0, $s3 #c => a
add $a1, $0, $s0 #a => b

JAL ASubDobroB

add $s4, $0, $v0 # d = ASubDobroB(c, a)
addi $s5, $0, 0x7fff
sll $s5, $s5, 16
addi $s6, $0, 0xfff
sll $s6, $s6, 4
addi $s6, $s6, 0xf
add $s5, $s5, $s6
addi $s5, $s5, 1

j GEXIT



ASubDobroB:
	addi $sp, $sp, -8
	sw $s0, 4($sp)
	sw $t0, 0($sp)
	add $a1, $a1, $a1
	#if a < b
	slt $t0, $a0, $a1
	# if a > b 
	beq $t0, $0, ELSE
		sub $v0, $a1, $a0
		j EXIT

	ELSE:
		sub $v0, $a0, $a1
	EXIT:
	lw $s0, 4($sp)
	lw $t0, 0($sp)
	addi, $sp, $sp, 8
	jr $ra

GEXIT:
add $t0, $0, $0


		
