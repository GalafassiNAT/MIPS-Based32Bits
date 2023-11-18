
	addi $t0, $0, 10
	addi $t1, $0, 5
	addi $t3, $0, 1
	add $t2, $0, $t0

	Loop:
		beq $t3, $t1, EXIT
		add $t0, $t2, $t0
		addi $t3, $t3, 1

		j Loop
	EXIT:

	addi $v0, $0, 10