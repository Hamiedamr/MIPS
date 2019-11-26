addi $s0, $0, 1
ori $s1, $s0, 2
sw $s0, 0($0)
sw $s1, 4($0)
addi $s2, $0, 2
or $s3, $s2, $s0
sw $s3, 8($0)