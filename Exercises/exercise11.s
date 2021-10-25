.data
    a: .word 10
    b: .word 5
.align 2
    v: .space 800

.text
.globl main
main:
    lw $t0 a
    lw $t1 b
    li $t2 0    # i = 0
    
    li $t3 200  # array_length: 800 / 4 -> 200
    
    # v[20]
    li $t4 80   # 20 * 4
    li $t5 120  # 30 * 4
    sw v($t5), v($t4) 

    # v[10] = b
    li $t6 40           # 10 * 4
    sw $t1, v($t6)
