.text
.globl main
main:
    li $a0, 5
    jal f1          # v0 = 15
    move $a0, $v0   # a0 = 15
    li $v0, 1
    syscall         # print(15)

    li $v0, 10
    syscall
f1: 
    li $t0, 10
    bgt $a0, $t0, et1
    move $t0, $a0       # t0 = 5
    li $t1, 0           # t1 = 0
 b1:
    beq $t0, $0, end
    add $t1, $t1, $t0   # t1 = 5; 9; 12; 14; 15;
    sub $t0, $t0, 1     # t0 = 4; 3; 2; 1; 0;
    b b1
 end:
    move $v0, $t1       # v0 = 15
    b et2
 et1:
    li $v0, 0
 et2:
    jr $ra