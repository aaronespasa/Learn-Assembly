.data
    matrix: .float 1.1,  2.4,   3.5
            .float 4.5,  5.33,  6.8
            .float 7.1,  8.9,   9.9
    vector: .float 10.1, 11.1,  12.1
    N:      .word  3
    jI:     .word  1
    # newLine: .asciiz "\n"

.text
.globl main
main:
    # addi $sp, $sp, -4
    # sw $ra, ($sp)       # save $ra on the stack

    la $a0, matrix
    la $a1, vector
    lw $a2, N           # N
    lw $a3, jI          # j

Insert:
    jal InsertInRow
    jal InsertInColumn

    li $t0, 0           # i
    li $t3, 1           # used to print an enter when it's 3
    li $t4, 3
    mul $t1, $a2, $a2   # N * N
    move $a1, $a0
    insertLoop:
        bge $t0, $t1, endProgram
        mul $t2, $t0, 4     # i * wordSize
        add $t2, $t2, $a1   # matrix pointer

        l.s $f12, ($t2)       # matrix element
        li $v0, 2
        syscall

        # print space, 32 is ASCII code for space
        li $a0, 32
        li $v0, 11  # syscall number for printing character
        syscall

        beq $t3, $t4, printEnter

        addi $t3, $t3, 1
        addi $t0, $t0, 1
        b insertLoop

    printEnter:
        li $a0, 10
        li $v0, 11
        syscall

        li $t3, 1
        addi $t0, $t0, 1
        b insertLoop

    endProgram:
        # lw $ra, ($sp)
        # addi $sp, $sp, 4
        # jr $ra
        li $v0, 10
        syscall

InsertInRow:
    # (j * totalCols + i) * wordSize
    li $t0, 0           # i

    insertInRowLoop:
        bge $t0, $a2, endInsertInRow
        
        mul $t1, $a3, $a2   # j * totalCols
        add $t1, $t1, $t0   # + i
        mul $t1, $t1, 4     # * wordSize

        add $t2, $t1, $a0   # index in matrix
        
        mul $t1, $t0, 4     # i * wordSize
        
        add $t3, $t1, $a1   # index in vector
        l.s $f4, ($t3)       # actual element

        # save vector[i] in matrix[j][i]
        s.s $f4, ($t2)

        addi $t0, $t0, 1
        b insertInRowLoop

    endInsertInRow:
        jr $ra

InsertInColumn:
    # (i * totalCols + j) * wordSize
    li $t0, 0           # i

    insertInColumnLoop:
        bge $t0, $a2, endInsertInColumn

        mul $t1, $t0, $a2   # i * totalCols
        add $t1, $t1, $a3   # + j
        mul $t1, $t1, 4     # * wordSize

        add $t2, $t1, $a0   # index in matrix

        mul $t1, $t0, 4     # i * wordSize

        add $t3, $t1, $a1   # index in vector
        l.s $f4, ($t3)       # actual element

        # save vector[i] in matrix[i][j]
        s.s $f4, ($t2)

        addi $t0, $t0, 1
        b insertInColumnLoop
    
    endInsertInColumn:
        jr $ra