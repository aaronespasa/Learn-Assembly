# pbrox@ing.uc3m.es (we must use apoyo.o in CreatorSIM)
.data
    .align 2
    A: .word 7, 3, 6, 6, 0, 1, 6, 6, 6, 6, 0, 0, 6, 5, 2, 0, 2, 4, 5, 6, 6, 6

.text
.globl main
main:
    la $a0, A       # A (array)
    li $a1, 22      # N = length of the array
    li $a2, 2       # Number of occurences
    li $a3, 6       # Number to search for

    # Check that N is not negative or zero
    slt $t0, $zero, $a1     # if 0 < N, t0 = 1
    beqz $t0, errorInProgram

    # Check that N is not negative or zero
    slt $t0, $zero, $a2     # if 0 < Num.Occurrences, t0 = 1
    beqz $t0, errorInProgram

    # If there's not an error in the program, it'll print zero
    li $v0, 1
    li $a0, 0
    syscall

    j arrayCompare

errorInProgram:
    # Return -1
    li $v0, 1
    li $a0, -1
    syscall
    
    # End Program
    li $v0, 10
    syscall

arrayCompare:
    # move $t0, $a0     # t0 = A (array)
    la $t0, A
    move $t1, $a1     # t1 = N
    move $t2, $a2     # t2 = num. occurences
    li $t3, 0       # i = 0
    li $t4, 0       # counter of contiguous N
    li $t5, 0       # sum of number of different sequences

loop:
    beq $t3, $t1, end_loop

    # A[i] -> get (load) a value (word) from arrayA and store it in $t6
    lw $t6, ($t0)
    # cmp returns 1 if A[i] == N, 0 otherwise
    # if is sum, 
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
    addi $t0, $t0, 4            # A[i + 1]
    addi $t3, $t3, 1            # i += 1
    j loop

end_loop:
    move $a0, $t5
    li $v0, 1
    syscall

    # End Program
    li $v0, 10
    syscall
