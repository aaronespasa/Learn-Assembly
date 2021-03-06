######## Matrix Compare #######
#
# This file uses the library apoyo.o. Remember to load it as a library!
#
# This file expects the following arguments:
#   - $a0: Address of the matrix.
#   - $a1: Number of rows of the matrix (M).
#   - $a2: Number of columns of the matrix (N).
#   - $a3: Number we're searching for.
#   - First word on the stack: Number of occurences.
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
    la $a0, matrix              
    move $t7, $a0               # Address of the matrix (A)    
    sw $t7, 28($sp)

    lw $a1, numRows             # Number of rows of the matrix (M)
    lw $a2, numColumns          # Number of columns of the matrix (N).
    lw $a3, numToSearch         # Number we're searching for (x)

    # Remove this code to receive an element from the stack #
    lw $t0, numOccurences
    sw $t0, 4($sp)
    #########################################################
    
    lw $s1, 4($sp) 	       
    move $t1, $s1               # Number of occurences (i)
    sw $t1, 4($sp)

    # Check that N is not negative or zero
    slt $t0, $zero, $a2         # if 0 < N, t0 = 1
    beqz $t0, errorInProgram

    # Check that M is not negative or zero
    slt $t0, $zero, $a1         # if 0 < M, t0 = 1
    beqz $t0, errorInProgram

    # Check that Num. Occurences is not negative or zero
    slt $t0, $zero, $t1         # if 0 < Num.Occurrences, t0 = 1
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
    # t7                # Address of the matrix (A)
    # t1                # Number of occurences
    li $t2, 0           # t2 = i = current row = 0
    sw $t2, 8($sp)

    li $t3, 0           # t3 = sum of number of different sequences
    sw $t3, 12($sp)

    move $t4, $a1       # t4 = Number of rows of the matrix (M)
    sw $t4, 16($sp)

    move $t5, $a2       # t5 = Number of columns of the matrix (N)
    sw $t5, 20($sp)

    move $t6, $a3       # t6 = Number we're searching for    
    sw $t6, 24($sp)

iterateOverRows:
    beq $t2, $t4, endIteration

    # The function arraycompare receives the following arguments:
    #   - $a0: Address of a vector of integers of dimension N.
    #   - $a1: Length of the array.
    #   - $a2: Number we're searching for.
    #   - $a3: Number of occurences.
    move $a0, $t7
    move $a1, $t5
    move $a2, $t6
    move $a3, $t1
    # Update a row of arraycompare
    jal arraycompare

    # Load all the values of the temporary registers
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    lw $t4, 16($sp)
    lw $t5, 20($sp)
    lw $t6, 24($sp)
    lw $t7, 28($sp)

    # Update the number of different sequences
    add $t3, $t3, $v0

goToTheNextRow:
    addi $t2, $t2, 1    # i += 1
    
    # Go to the next row ($t7 + $t5 * 4):
    # We've multiple rows in a matrix. $t5 will be a pointer pointing to the initial
    # address of the current row ($t2)
    li $t0, 4                      # t5 = Size of a word = 4
    mul $t5, $t5, $t0              # numColumns * 4 = $t5 * $t0        
    # |
    # V
    add $t7, $t7, $t0            # A[i+1][0]

    j iterateOverRows

endIteration:
    move $a0, $t3
    li $v0, 1
    syscall

    # End Program
    li $v0, 10
    syscall


####### ARRAYCOMPARE #######
arraycompare:
    sw $ra, 32($sp)               # upload the $ra into the stack
    
    move $s0, $a0   # A (array)
    sw $s0, 36($sp)
    
    # Check that N is not negative or zero
    slt $t0, $zero, $a1     # if 0 < N, t0 = 1
    beqz $t0, errorInProgram

    # Check that Num. Occurences is not negative or zero
    slt $t0, $zero, $a3     # if 0 < Num. Occurrences, t0 = 1
    beqz $t0, errorInProgram

    j arraycompareMainFunction

arraycompareMainFunction:
    move $t1, $a1     # t1 = N
    move $t2, $a3     # t2 = num. occurences
    li $t3, 0         # i = 0
    li $t4, 0         # counter of contiguous N
    li $t5, 0         # sum of number of different sequences

loop:
    beq $t3, $t1, endLoop

    # A[i] -> get (load) a value (word) from arrayA and store it in $t6
    lw $t6, ($s0) 
    # cmp returns 1 if A[i] == N, 0 otherwise
    move $a0, $t6
    move $a1, $a2
    jal cmp
    move $t7, $v0
    beq $t7, 1, addOneToCounter

    j resetContiguousCounter

addOneToCounter:
    addi $t4, $t4, 1

    # Add one to the sum of different sequences (t5)
    # if t4 == 2
    move $a0, $t4  
    li $a1, 2 
    # move $a1, $t2
    jal cmp
    move $t7, $v0
    # Only go to addOneToSum if t4 == 2.
    beq $t7, 1, addOneToSum
    j movePointer

addOneToSum:
    addi $t5, $t5, 1
    j movePointer

resetContiguousCounter:
    li $t4, 0

movePointer:
    addi $s0, $s0, 4            # A[i + 1]
    addi $t3, $t3, 1            # i += 1
    j loop

endLoop:
    move $v0, $t5

    lw $ra, 32($sp) 	        # Load the $ra from the stack

    # End Subroutine
    jr $ra
#########################