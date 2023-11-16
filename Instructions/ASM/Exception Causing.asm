
.data
msg: .asciiz "Exception Causing Program\n"
.text
.globl main
main:
    li $v0, 4
    la $a0, msg
    syscall

    # Causes an exception by causing an overflow.
   	addi $t0, $0, 0x7FFF
	sll $t0, $t0, 16
	addi $t1, $0, 0xFFF
	sll $t1, $t1, 4
	addi $t1, $t1, 0xF
	add $t0, $t0, $t1

	addi $t0, $t0, 1


    # Ends the program
    li $v0, 10
    syscall
