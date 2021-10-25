.data
    .align 2
    matrix: .word 2, 3, 0, 4, 5, 8, 3
            .word 3, 0, 3, 3, 3, 0, 9
            .word 3, 3, 8, 9, 6, 7, 4
            .word 3, 0, 3, 3, 0, 8, 9
    numRows:       .byte 4
    numColumns:    .byte 7
    numToSearch:   .byte 3
    numOccurences: .byte 2

.text
.globl main
main:
    la $a0, matrix          # a0 = Address of the matrix
    la $a1, 