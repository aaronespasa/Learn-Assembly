######## Array Compare #######
#
# This file uses the library apoyo.o. Remember to load it as a library!
#
# This file expects the following arguments:
#   - $a0: Address of a vector of integers of dimension N.
#   - $a1: Length of the array.
#   - $a2: Number we're searching for.
#   - $a3: Number of occurences.
##############################
.data
    .align 2
    A: .word 7, 3, 6, 6, 0, 1, 6, 6, 6, 6, 0, 0, 6, 5, 2, 0, 2, 4, 5, 6, 6, 6

.text
.globl arraycompare
arraycompare:
    # a0 -> a3
    # li $a0, 2       # Number of occurences
    li $a3, 2       # Number of occurences

    # a1 is fine
    li $a1, 22      # N = length of the array

    # a2 -> a0
    # la $a2, A       # A (array)
    la $a0, A       # A (array)

    # a3 -> a2
    # li $a3, 6       # Number to search for
    li $a2, 6       # Number to search for

    # Check that N is not negative or zero
    slt $t0, $zero, $a1     # if 0 < N, t0 = 1
    beqz $t0, errorInProgram

    # Check that Num. Occurences is not negative or zero
    slt $t0, $zero, $a3     # if 0 < Num. Occurrences, t0 = 1
    beqz $t0, errorInProgram

    # If there's not an error in the program, it'll print zero
    li $v0, 1
    li $a0, 0
    syscall

    j arraycompareMainFunction

errorInProgram:
    # Return -1
    li $v0, 1
    li $a0, -1
    syscall
    
    # End Program
    li $v0, 10
    syscall

arraycompareMainFunction:
    move $t1, $a1     # t1 = N
    move $t2, $a3     # t2 = num. occurences
    li $t3, 0         # i = 0
    li $t4, 0         # counter of contiguous N
    li $t5, 0         # sum of number of different sequences

loop:
    beq $t3, $t1, end_loop

    # A[i] -> get (load) a value (word) from arrayA and store it in $t6
    lw $t6, ($a2)
    # cmp returns 1 if A[i] == N, 0 otherwise
    move $a0, $t6
    move $a1, $a3
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
    addi $a2, $a2, 4            # A[i + 1]
    addi $t3, $t3, 1            # i += 1
    j loop

end_loop:
    move $a0, $t5
    li $v0, 1
    syscall

    move $v0, $t1

    # End Program
    jr $ra
