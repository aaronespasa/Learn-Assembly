.data
    myString: .asciiz "Hello world!"

.text
.globl main
main:
    la $a0 myString
    li $a1 'o'
    li $a2 'x'

while:
    lbu $t0, ($a0)
    # See that the last element of myString is
    # a 0 because it's in asciiz
    beqz $t0, endProgram
    bne $t0, $a1, continue
    # If the program continues, we have to replace
    # the string letter by 'x'
    sb $a2, ($a0)

continue:
    addi $a0, $a0, 1
    b while

endProgram:
    li $v0, 4
    la $a0 myString
    syscall

    li $v0, 10
    syscall
