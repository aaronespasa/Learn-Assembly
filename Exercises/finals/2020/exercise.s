.data
    A: .word 8, 4, 3, 3, 5
             2, 3, 0, 4, 5
             0, 0, 1, 2, 3
    M: .word 3
    N: .word 5

.text
.globl main
main:
    la $a0, A # $a0: matrix address
    lw $a1, M # $a1: M
    lw $a2, N # $a2: N
    li $a3, 1 # $a3: row

    addi $sp, $sp, -4
    li $t0, 2
    sw $t0, ($sp) # ($sp): number of row or column i

    jal ADD

    addi $sp, $sp, 4

    # Print the first value
    move $a0, $v0
    li $v0, 1
    syscall

    # Print the second value
    move $a0, $v1
    syscall

    li $v0, 10
    syscall

ADD:
    lw $t0, 0($sp)

    beqz $a3, addElementsInColumnI

sumElementsInRowI:
    # if t0 > N: v0=-1 and v1=0
    bgt $t0, $a2, outOfRange
    blt $t0, $0, outOfRange
    
    # It's not out of range
    li $v0, 0
    li $v1, 0      # this value will be updated
    li $t1, 0

    # Go to row i -> (numColumns * wordSize) * i
    mul $t2, $a2, 4
    mul $t2, $t2, $t0
    
    add $t3, $t2, $a0   # index in matrix

loopSumElementsInRowI:
    beq $t1, $a2, endProgram

    lw $t4, ($t3)
    add $v1, $v1, $t4   # sum matrix element

    addi $t3, $t3, 4    # matrix[i][idx++]
    addi $t1, $t1, 1    # idx++
    b loopSumElementsInRowI

sumElementsInColumnI:
    # if t0 > M: v0=-1 and v1=0
    bgt $t0, $a1, outOfRange
    blt $t0, $0, outOfRange

    # It's not out of range
    li $v0, 0
    li $v1, 0
    li $t1, 0

    # Go to column i -> (i * wordSize)
    mul $t2, $t0, 4

    add $t3, $t2, $a0   # index in matrix

    # t2 -> quantity needed to be sum to go to the next column[i]
    #       (numColumns * wordSize)
    mul $t2, $a2, 4

loopSumElementsInColumnI:
    beq $t1, $a1, endProgram

    lw $t4, ($t3)
    add $v1, $v1, $t4   # sum matrix element

    add $t3, $t3, $t2
    addi $t1, $t1, 1
    b loopSumElementsInColumnI

outOfRange:
    li $v0, -1
    li $v1, 0

endProgram:
    jr $ra

