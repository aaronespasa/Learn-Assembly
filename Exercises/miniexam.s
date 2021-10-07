.data
    .align 2 #next data aligned to 4
    vec: .space 400
    b: .word 5
.text
.glob main
main:
    li $t0, 5
    la $t1, vec
    li $t2, 0
    li $t3, 100
    li $t4, 0
loop:
    bge $t2, $t3, end
    sw $t0, vec($t4)
    addi $t2, $t2, 1
    addi $t4, $t4, 4
end:
    b loop