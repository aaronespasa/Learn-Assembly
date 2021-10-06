.data
  a: .word 5
  b: .word 10
.text
main:
  li $t0 1
  lw $t1, a
  lw $t2, b
label1:
  bgt $t0, $t1, label2  # if t0 > t1: go to label2
  addi $t2, $t2, 2      # t2 = 12; 14; 16; 18; 20
  addi $t0, $t0, 1      # t0 = 2; 3; 4; 5; 6
  b label1
label2:
  sw $t0, a             # a = 6
  sw $t2, b             # b = 20