.data
    floating_num: .float 3.432

.text
.globl main
main:
    li.s $f12, floating_num
    li $v0, 2
    syscall
    