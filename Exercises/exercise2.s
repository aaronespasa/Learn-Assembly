.data
    .align 2
    v: .word 7, 8, 3, 4, 5, 6

.text
.globl main
main:
    la $a0 v
    li $a1 5            # v.size()
    li $a2 5            # sum this value to each v[i]
    jal AddValue        # update v

    # Print v
    li $t0, 0           # i
    move $t1, $a0       # v

printValues:
    beq $t0, $a1, endProgram

    # Print v[i]
    li $v0, 1
    lw $a0, ($t1)
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    addi $t0, $t0, 1
    addi $t1, $t1, 4
    b printValues


endProgram:
    li $v0, 10
    syscall

AddValue:
    # Add the last value of int_array as a third
    # parameteer to all components of the array.
    li $t0, 0
    move $t1, $a0

loop:
    beq $t0, $a1, endAddValue
    lw $t2, ($t1)
    addi $t2, $t2, $a2
    sw $t2, ($t1)       # store v[i] + a2 in v[i]
    addi $t0, $t0, 1    # i + 1
    addi $t1, $t1, 4    # v[i + 1]
    b loop

endAddValue:
    jr $ra