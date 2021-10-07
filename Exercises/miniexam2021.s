.text
.globl main
main:
    li $t0 0        # i = 0
    li $t1 7        # length = 7
    li $t2 0        # sum = 0
    b while

while:
    bge $t0, $t1, endProgram
    add $t2, $t2, $t0          # sum = sum + i
    addi $t0, $t0, 1           # i = i + 1    
    b while

endProgram:
    # $t2 is our result, we can move it to $v0 if we're asked for:
    # move $v0, $t2

    # Exit the program
    li $v0, 10
    syscall
