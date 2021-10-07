# A function called func that receives three arguments (integer) and returns an integer

# Write in assembly the 

.data
    myString: .asciiz "Hello world!"
    myArray: .word 5, 3, 4, 2 
    a: .word 5
    b: .word 7
    c: .word 9

.text
.globl main
main:
    lw $a0 a
    lw $a1 b
    lw $a2 c
    jal func
    
    lw $t0, ($sp) 		# load $a2 = c
    addu $sp, $sp, 4
    
    li $v0, 1
    move $a0 $t0
    syscall
    
    li $v0, 10
    syscall
    
func:
	subu $sp, $sp, 4
    sw $a0, ($sp)
    
    subu $sp, $sp, 4
    sw $a1, ($sp)
    
    subu $sp, $sp, 4
    sw $a2, ($sp)
    
    jr $ra