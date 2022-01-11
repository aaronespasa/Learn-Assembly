begin
{
    fetch:          (T2, C0),
                    (TA, R, BW=11, M1=1, C1=1),
                    (M2, C2, T1, C3),
                    (A0, B=0, C=0)
}


str RE1, (RE2) {
        co=010110,
        nwords=2,
        RE1=reg(20, 16),
        U32=inm(63, 32)
        {
                # MAR <- PC
                
                # MBR <- MM[MAR]
                
                # PC <- PC + 4
                
                # BR[R1] <- MBR
                
                # Go to fetch
                
        }
}

# El valor de R1 lo guarda en la posición
# de memoria de R2

registers
{
        0=($R0),
        1=($R1),
        2=($R2),
        3=($R3),
        4=($R4),
        5=($R5),
        6=($R6),
        7=($R7),
        8=($R8),
        9=($R9),
        10=($R10),
        11=($R11),
        12=($R12),
        13=($R13, $SP) (stack_pointer),
        14=($R14, $LR),  # return address
        15=($R15)
}