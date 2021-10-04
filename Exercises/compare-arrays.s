.data
    .align 2                               # Needed by the CreatorSim
	string: .asciiz "Array C: "
    arrayA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    arrayB: .word 2, 3, 4, 1, 2, 3, 9, 9, 6, 24
    arrayC: .word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    # C expected: 0, 0, 0, 1, 1, 1, 0, 0, 1, 0

.text
.globl main
main:
	la $t1, arrayA							# $t1 = address of ArrayA
	la $t2, arrayB							# $t2 = address of ArrayB
    la $t3, arrayC							# $t3 = address of ArrayC

    li $t4, 0                               # $t4 = i = 0 (index)
    li $s1, 10                              # $s1 = arrayLength = 10

    li $v0, 4                               # Call Code: 4 -> print string on $a0
    la $a0, string                          # $a0 = address of string
    syscall                                 # print($a0)

    j for                                   # jump to loop

for:                                        # for (int i=0; i <array.length; i++)
    
    # beq $t4, $s1, reset    means jump to reset if $t4 == $s1
    beq $t4, $s1, reset                     # if $t4 == $s1, reset the stuff and print results

    # A[i] -> get (load) a value (word) from arrayA and store it in $t5
    lw $t5, ($t1)
    # B[i] -> get (load) a value (word) from arrayB and store it in $t6                           
    lw $t6, ($t2)                           

    # slt -> set on less than
    slt $t0, $t6, $t5                       # if B[i] < A[i], set $t0 to 1. Otherwise, 0.

    # If t0 == 1, it'll go to movePointer and don't change C[i]
    beq $t0, 1, movePointer                 # if $t0 == 1, go to movePointer

    # If t0 == 0, it will arrive this part
    sw $zero, ($t3)                         # store (save) 0 (word) in C[i]

    j movePointer

movePointer:                                # move the pointer in all the arrays
    # addi: Add an immediate number with overflow

    # We increment 4 as 8bits * 4 = 32 bits = 1 word:
    # same as saying "go to the next word" or "go to the next element in the array"
    addi $t1, $t1, 4                        # A[i + 1]
    addi $t2, $t2, 4                        # B[i + 1]
    addi $t3, $t3, 4                        # C[i + 1]
    
    # Remember that t4 = i. As it's just an iterate to iterate through the array, we'll
    # just need to add 1 (i = i + 1)
    addi $t4, $t4, 1                        

    j for                                   # repeat the for loop

reset:                                      # reset stuff to print
    li $t4, 0                               # t4 = i = 0

    # The pointer of $t3 is currently at the end of arrayC. To set it
    # at the beginning of arrayC, we just can load the address again:
    la $t3, arrayC                          

    j print                                 # print results

print:                                      # print arrayC
    beq $t4, $s1, exitProgram               # if t4 == s1, exit the program

    # Print C[i] 
    lw $s2, ($t3)                           # store C[i] into s2

    li $v0, 1                               # Call Code: 1 -> print integer on $a0
    move $a0, $s2                           # move the address pointing to the current cell of s2 into a0
    syscall

    # Print a space
    li $a0, 32                              # Print the ASCII representation of 32 (a space)
    li $v0, 11                              # Call Code: 11 -> print character on $a0 (byte)
    syscall

    addi $t3, $t3, 4                        # C[i + 1]
    addi $t4, $t4, 1                        # i = i + 1

    j print

exitProgram:
    li $v0, 10                              # Call Code: 10 -> exit the program
    syscall
