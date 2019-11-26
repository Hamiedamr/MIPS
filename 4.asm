addi $s0, $0, 1
ori $s1, $s0, 2
sw $s0, 0($0)
sw $s1, 4($0)
addi $s2, $0, 2
or $s3, $s2, $s0
sw $s3, 8($0)
beq $s3, $s1, 2
sw $s1, 12($0)
addi $s4, $0, 2
or $s5, $s2, $s0