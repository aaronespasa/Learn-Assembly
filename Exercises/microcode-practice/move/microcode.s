begin
{
    fetch:          (T2, C0),
                    (TA, R, BW=11, M1=1, C1=1),
                    (M2, C2, T1, C3),
                    (A0, B=0, C=0)
}


mov RE1, U32 {
        co=010010,
        nwords=2,
        RE1=reg(20, 16),
        U32=inm(63, 32)
        {
                # MAR <- PC
                (T2, C0),
                # MBR <- MM[MAR]
                (TA, R, BW=11, M1=1, C1=1),
                # PC <- PC + 4
                (M2=1, C2),
                # BR[R1] <- MBR
                (T1, SelC=10000, MR=0 ,LC=1),
                # Go to fetch
                (A0=1, B=1, C=0)
        }
}

str RE1, (RE2) {
        co=010000,
        nwords=2,
        RE1=reg(25, 21),
        RE2=reg(15, 11)
        {
                # MAR <- RF[RE2]
                (SelA=01011, MR=0, T9, C0),

                # MM[MAR] <- MAR
                (TA, R)

                # MBR <- RF[RE1]
                (SelB=10101,MR=0, T10, M1=0, C1),

                # M[MAR] <- MBR
                (BW=11, TD, W),

                # Go to fetch
                (A0=1, B=1, C=0)

        }
}

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