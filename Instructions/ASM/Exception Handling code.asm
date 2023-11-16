
mfc0 $k0
slt $k1, $k0, $0
beq $k1, $0, POSITIVE

# If the value in $k0 was negative.
add $k1, $0, $0
addi $k0, $0, 0x7fff
sll $k0, $k0, 16
addi $k1, $0, 0xfff
sll $k1, $k1, 4
addi $k1, $k1, 0xf 
add $k0,$k0, $k1
mtc0 $k0 
rfe

# If it was positive.
POSITIVE:
addi $k0, $0, 0x800
sll $k0, $k0, 20
mtc0 $k0
rfe