.data
    evenString: .asciiz "It's an even number"
    oddString: .asciiz "It's an odd number"

.text
.globl main
main:
    li $t0 45
    li $t2, 2
    li $t6 1
    rem $t1, $t0, $t2
    slt $t3, $t1, $t6     # t3 = 1 if t0 is even, 0 otherwise
    beq $t3, 0, oddNumber
    
    li $v0, 4
    la $a0, evenString
    syscall
    b endProgram

oddNumber:
    li $v0, 4
    la $a0, oddString
    syscall

endProgram:
    li $v0, 10
    syscall