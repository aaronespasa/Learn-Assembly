.text
.globl main
main:
    li $t0 0        # i
    li $t1 45       # number
    li $t2 32       # num bit on a register
    li $s0 0        # s -> counter

whileLoop:
    bge $t0, $t2, endProgram
    andi $t4, $t1, 1
    add $s0, $s0, $t4
    srl $t1, $t1, 1
    addi $t0, $t0, 1    # i++
    b whileLoop

endProgram:
    li $v0, 1
    move $a0, $s0
    syscall

    li $v0, 10
    syscall