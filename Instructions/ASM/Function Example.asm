main:
	addi $a0, ,$0, 2
	addi $a1, $0, 3
	jal EXEMPLO
	add $t0, $v0, $0
	li $v0, 10
EXEMPLO:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	add $s0, $a0, $a1
	add $v0, $0, $s0
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
