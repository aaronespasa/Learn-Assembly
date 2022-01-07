# Fill an array with values
.data
    .align 2            # next data aligned to 4
    vec:    .space 400     
    value:  .word  5       # word to be saved in vec

.text
.globl main
main:
    lw $t0, value
    la $t1, vec
    li $t2, 0               # i = 0
    li $t3, 100             # num of values in vec (400 / wordSize)
loop:
    bge $t2, $t3, end
    addi $t4, $t2, 4        # i * wordSize
    sw $t0, vec($t4)        # vec[i] = value
    addi $t2, $t2, 1        # i++
end:
    li $v0, 10
    syscall