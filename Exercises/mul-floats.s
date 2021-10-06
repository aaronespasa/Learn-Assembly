.text
.globl main
main:
    li.s $f0 3.1415
    li $t0 4

    mtc1 $t0 $f1        # 4 in Two's Complement
    cvt.s.w $f2 $f1
    mul.s $f0 $f2 $f1
