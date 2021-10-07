.data
    cadena: .asciiz "Haoala"

.text
Vowels:
	li $t0, -1
    move $t1, $a0		# t1 = string
    beqz $t1, end
    li $t0, 0			# t0 = counter = output
    li $t2, 'a'			# t2 = letter

loop:
    lbu $t3 ($a1)
    
    beqz $t3, end
    bne $t3, $t2, continue
    # the character == "a"
    addi $t0, $t0, 1

continue:
    addi $t1, $t1, 1
    b loop

end:
	move $v0, $t0
	jr $ra
    
main:
    la $a0 cadena           
    jal Vowels
    
    move $a0, $v0
    li $v0, 1
    syscall
    
    li $v0, 10
    syscall