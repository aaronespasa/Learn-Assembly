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
    matrix: .float 2.1,  3.4,  0.3,   4.4,   5.2,   8.0,  3.0
            .float 3.5,  0.0,  3.2,   3.43,  3.334, 0.09, 9.00
            .float 3.43, 3.43, 8.95,  9.95,  6.666, 7.32, 4.44
            .float 3.0,  0.0,  3.245, 3.245, 0.000, 8.4,  9.9
    numRows:       .word 4
    numColumns:    .word 7
    i:             .word 2
    j:             .word 3

.text
.globl main
main:
    lw $a0, matrix              
    move $s0, $a0               # Address of the matrix (A)
    lw $a1, numRows             # Number of rows of the matrix (M)
    lw $a2, numColumns          # Number of columns of the matrix (N).
    lw $a3, i                   # A row of the matrix

    # Remove this code to receive an element from the stack #
    lw $t0, j
    subu $sp, $sp, 4            # last 4 bytes are for the word
    sw $t0, ($sp)
    #########################################################
    
    lw $s1, ($sp) 	            # A column of the matrix
    addu $sp, $sp, 4            # Point the stack pointer to the end

    # Check that N is not negative or zero
    slt $t0, $zero, $a2         # if 0 < N, t0 = 1
    beqz $t0, errorInProgram

    # Check that M is not negative or zero
    slt $t0, $zero, $a1         # if 0 < M, t0 = 1
    beqz $t0, errorInProgram

    # Check that i is not negative
    slt $t0, -1, $a3         # if -1 < i, t0 = 1
    beqz $t0, errorInProgram

    # Check that i is less or equal to M-1
    sgt $t0, $a1, $a3         # if M > i, t0 = 1
    beqz $t0, errorInProgram

    # Check that j is not negative
    slt $t0, -1, $s1         # if -1 < i, t0 = 1
    beqz $t0, errorInProgram

    # Check that j is less or equal to N-1
    sgt $t0, $a2, $s1         # if N > j, t0 = 1
    beqz $t0, errorInProgram

    # If there's not an error in the program, it'll print zero
    li $v0, 1
    li $a0, 0
    syscall

    j modifyMatrix

errorInProgram:
    # Return -1
    li $v0, 1
    li $a0, -1
    syscall
    
    # End Program
    li $v0, 10
    syscall

modifyMatrix:
    # s0                # Address of the matrix (A)
    # s1                # A column of the matrix (j)
    li $t0, 0           # t0 = current row = 0
    li $t1, 0           # t1 = current column  = 0
    move $t2, $a1       # t2 = Number of rows of the matrix (M)
    move $t3, $a2       # t3 = Number of columns of the matrix (N)
    move $t4, $a3       # t4 = A row of the matrix

    # Save in the register $t7 the value of A[i][j] = A[$t4][$s1]
    li $t6, 0     
    # point to the beginning of the row t4  -> 4 * t4 * number of columns            
    mul $t6, 4, $t4   
    mul $t6, $t6, $t3

    # point to the element on column j ($s1)
    mul $t7, $s1, 4
    add $t6, $t6, $t7
    # |
    # V
    li $t7, $t6($s0)   # t7 = A[i][j]


iterateOverRows:
    beq $t0, $t2, endIterationOverRows
    
    jal iterateOverColumns

    j goToTheNextRow

###### LOOP OVER COLUMNS ######
iterateOverColumns:
    beq $t1, $t3, endIterationOverColumns

    # $f0 = ($s0) = A[$t0][$t1]
    mtc1 ($s0), $f0

    # Slides: https://aulaglobal.uc3m.es/pluginfile.php/4786936/mod_resource/content/4/Unit%202%20-%20Data%20representation%20-%202%20-%20v2.pdf

    # TODO: if $f0 is NaN, convert ($s0) into 0
    # a0 f0
    # a1 0 11111111 10000000000000000000001
    # igual podemos utilizar cmp
    # haz que t0 sea 0 si a0 es igual a a1
    # beqz $t0, floatingPointNaN

    # TODO: if $f0 is non-normalized (0 is considered NORMALIZED), convert ($s0) into $t7 ($t7 = A[i][j])
    # ...
    
    # Solo ejecuta la siguiente línea cuando $f0 sea non-normalized
    # ...
    # beqz $t0, floatingPointNonNormalized

    j goToTheNextColumns

floatingPointNaN:
    sw 0, ($s0)
    ...
    j goToTheNextColumns

floatingPointNonNormalized:
    sw $t7, ($s0)
    ...
    j goToTheNextColumns


goToTheNextColumns:
    # We're in A[$t0], so we just have to update the column
    add $s0, $s0, 4     # size of a floating point number = 4 bytes

    add $t1, $t1, 1     # go to the next column

    j iterateOverColumns

endIterationOverColumns:
    jr $ra
###############################

goToTheNextRow:
    addi $t0, $t0, 1    # i += 1
    
    # Go to the next row ($s0 + $t0 * $t3 * 4):
    # We've multiple rows in a matrix. $t4 will be a pointer pointing to the initial
    # address of the current row ($t0)
    li $t5, 0                    # row initial address ($t0 * $t3 * 4)
    mul $t5, $t0, $t3            # i * numColumns = $t0 * $t3
    mul $t5, $t5, 4              # i * numColumns * 4 = $t5 * 4  (4 is for arrays with floating p. num.)
    # |
    # V
    add $s0, $s0, $t5            # A[i+1][0]

    j iterateOverRows

endIterationOverRows:
    move $a0, $t1
    li $v0, 1
    syscall

    # End Program
    li $v0, 10
    syscall