.text
.globl main
main:
    li $a0, 5
    jal function
    # v0 = 15
    # a0 = v0 = 15
    move $a0, $v0
    li $v0, 1
    syscall # print(15)

    li $v0, 10
    syscall
function:
    li $t0, 10
    # a0 = 5; t0 = 10
    bgt $a0, $t0, et1       # if a0 > t0: go to et1
    li $t0, 10
    add $v0, $t0, $a0
    b et2
et1:
    li $t0, 8
    add $v0, $t0, $a0
et2:
    jr $ra