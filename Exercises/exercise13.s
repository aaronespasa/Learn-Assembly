.data
    .align 2
    vec: .space 4096

.text
.globl main
main:
    li $t0, 0       # i = 0
    li $t1, 1024    # length = 1024



# [-2^(n-1)+1, 2^(n-1)]

# 8 bits
# 3 bits <- 2^(n-1)-1 = 3

# 111 <- 7 - 3 = 4
# 110 <- 6 - 3 = 3
# 001 <- 1 - 3 = -2
# 000 <- 0 - 3 = -3
