.data
    cadena: .asciiz "Hola"

.text
.globl main
main:
    la $a0 cadena
    lw $a1 "a"      # 
Vowels:
    ...
loop:
    ...