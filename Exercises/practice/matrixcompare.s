######## Matrix Compare #######
#
# This file uses the library arraycompare.o. Remember to load it as a library!
#
###############################

.data
    .align 2
    matrix: .word 2, 3, 0, 4, 5, 8, 3
            .word 3, 0, 3, 3, 3, 0, 9
            .word 3, 3, 8, 9, 6, 7, 4
            .word 3, 0, 3, 3, 0, 8, 9
    numRows:       .word 4
    numColumns:    .word 7
    numToSearch:   .word 3
    numOccurences: .word 2

.text
.globl main
main:
    lw $a0, numOccurences       # Number of occurences
    lw $a1, numColumns          # Length of the array
    la $a2, matrix              # Address of the matrix
    lw $a3, numToSearch         # Number we're searching for

    # Remove this code to receive an element from the stack #
    lw $s0, numOccurences
    subu $sp, $sp, 4        # 1024 -> 1020 (the last 4 bytes are the word)
    sw $t0, ($sp)
    #########################################################
    
    lw $s0, ($sp) 	        # 
    addu $sp, $sp, 4    # Point the stack pointer to the end 1020 -> 1024

    # Check that N is not negative or zero
    slt $t0, $zero, $a1     # if 0 < N, t0 = 1
    beqz $t0, errorInProgram

    # Check that M is not negative or zero
    lb $t1, numRows
    slt $t0, $zero, $t1     # if 0 < M, t0 = 1
    beqz $t0, errorInProgram

    # Check that Num. Occurences is not negative or zero
    slt $t0, $zero, $a0     # if 0 < Num.Occurrences, t0 = 1
    beqz $t0, errorInProgram

    # If there's not an error in the program, it'll print zero
    li $v0, 1
    li $a0, 0
    syscall

    j matrixCompare

errorInProgram:
    # Return -1
    li $v0, 1
    li $a0, -1
    syscall
    
    # End Program
    li $v0, 10
    syscall

matrixCompare:
    li $t0, 0           # t0 = i = current row = 0
    lb $t1, numRows     # t1 = number of rows of the matrix
    li $t2, 0           # t2 = sum of number of different sequences

iterateOverRows:
    beq $t0, $t1, endIteration

    # Update a row of arraycompare
    jal arraycompare

    # Update the number of different sequences
    add $t2, $t2, $v0

movePointer:
    addi $t0, $t0, 1    # i += 1
    
    # Go to the next row ($a2 + $t0 * $a1 * 4):
    li $t3, 0                    # row initial address ($t0 * $a1 * 4)
    mul $t3, $t0, $a1            # i * numColumns = $t0 * $a1
    mul $t3, $t3, 4              # i * numColumns * 4 = $t3 * 4 <- for arrays with words
    add $a2, $a2, $t3            # A[i+1][0]

    j iterateOverRows

endIteration:
    move $a0, $t2
    li $v0, 1
    syscall

    # End Program
    li $v0, 10
    syscall