.data
	vector: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

.text
sumav:
    # Push $a0 (vector length) and $a1 (address to the vector) to the stack
    str $R1, ($SP)
    adds $SP, $SP, -4
    str $R0, ($SP)
    # $R5 = $v0 = sum of the vector elements
    mov $R5, 0
    mov $R8, 0 # $R8 = $0
    b1:
    	# Jump to f1 if $a0 == $0
    	cmp $R0, $R8
      beq f1
      
      ldr $R7, ($R1)     # $R7 = $t0 = word of the vector
      adds $R5, $R5, $R7
      adds $R1, $R1, 4
      adds $R0, $R0, -1
      
      # This condition will always will be satisfy, so it's like a `b b1`
      cmp $R8, $R8
      beq b1
      
    f1:
    	# Pop $a0 and $a1 from the stack and return
      ldr $R1, ($SP)
      adds $SP, $SP, 4
      ldr $R0, ($SP)
      bx $LR

main:
		# $R0 = $a0 = length of the vector
    # $R1 = $a1 = initial address of the vector
		mov $R0, 10
    mov $R1, vector
    bl sumav 
    # Exit the program
    halt