# Sum all the elements of a matrix
.data
    acc: .word 0
    buffer: .word 1, 2, 3, 4
            .word 2, 3, 4, 5
            .word 3, 4, 5, 6

.text
.globl main
main:
    li $a0, buffer
    li $v0, 0           # acc = 0

    li $t1, 0           # i = 0
    li $t5, 3           # t5 = 3 = num of rows

    b1: bge $t1, $t5, endProgram
        li $t2, 0       # j = 0
        li $t6, 4       # t6 = 4 = num of cols
    
    b2: bge $t2, $t6, nextMainLoop

        # i * numColumns * wordSize = i * $t6 * 4 
        # +                                         
        # j * wordSize = j * 4                   
        # =
        # (i * $t6 + j) * 4 = $t4
        mul $t4, $t1, $t6
        add $t4, $t4, $t2
        mul $t4, $t4, 4
        
        # Get the element in the matrix
        add $t4, $t4, $a0               # index
        lw $t7, ($t4)                   # actual element

        add $v0, $v0, $t7

        addi $t2, $t2, 1    # j++
        b b2
    
    nextMainLoop:           
        addi $t1, $t1, 1    # i++
        b b1
    
    endProgram:
        move $a0, $v0
        li $v0, 1
        syscall

        li $v0, 10
        syscall