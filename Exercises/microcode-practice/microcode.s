begin
{
    fetch:          (T2, C0),
                    (TA, R, BW=11, M1=1, C1=1),
                    (M2, C2, T1, C3),
                    (A0, B=0, C=0)
}


mov RE1, U32 {					 #li/la
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
                # BR[RE1] <- MBR
                (T1, SelC=10000, MR=0 ,LC=1),
                # Go to fetch
                (A0=1, B=1, C=0)
        }
}

str RE1, (RE2) {					#sw
        co=010000,
        nwords=1,
        RE1=reg(25, 21),
        RE2=reg(15, 11)
        {
          	# MM[RE2] <- BR[RE1] 
            		# MAR <- RF[RE2]
                	(SelA=01011, MR=0, T9, C0),
                # MBR <- RF[RE1]
                	(SelB=10101, MR=0, T10, M1=0, C1),
                # M[MAR] <- MBR
                	(TA, BW=11, SE=0, TD, W),
                # Go to fetch
                	(A0=1, B=1, C=0)

        }
}

ldr RE1, (RE2) {					#lw
        co=010011,
        nwords=1,
        RE1=reg(25, 21),
        RE2=reg(15, 11)
        {
          	#  BR[RE1] <- MM[RE2]
            		# MAR <- RF[RE2]
                	(SelA=01011, MR=0, T9, C0),
                # MBR <- MM[MAR]
                	(TA, R, BW=11, M1, C1),
                # RF[RE1] <- MBR,
                	(T1, LC=1, SELC=10101, MR=0),
                # Go to fetch
                	(A0=1, B=1, C=0)

        }
}


adds RE1, RE2, RE3 {					
        co=011000,
        nwords=1,
        RE1=reg(25,21),
        RE2=reg(20,16),
  			RE3=reg(15,11)
        {
          	#  BR[RE1] ← BR[RE2] + BR[RE3]
            		# RF[RE1] <- RF[RE2] + RF[RE3]
                	(SELA=10000, MR=0, SELB=01011, 
                   SELCOP=1010, MC=1, SELP=11, M7, C7, T6, LC=1, SELC=10101),
          			# Go to fetch
                	(A0=1, B=1, C=0)
        
        }
}

adds RE1, RE2, S16 {					
        co=011010,
        nwords=1,
        RE1=reg(25,21),
        RE2=reg(20,16),
  			S16=inm(15,0)
        {
          	#  BR[RE1] ← BR[RE2] + S16
          			# RT2 <- IR[S16]
          				(SE=1, SIZE=10000, OFFSET=0, T3, C5),
            		# RF[RE1] <- RF[RE2] + RT2
                	(SELA=10000, MR=0, MB, MA=0
                   SELCOP=1010, MC=1, SELP=11, M7, C7, T6, LC=1, SELC=10101),
          			# Go to fetch
                	(A0=1, B=1, C=0)
        
        }
}

mvns RE1, RE2 {			# Transforms a number into its CA1 and stores it in the RF
        co=011011,
        nwords=1,
        RE1=reg(25,21),
        RE2=reg(15,11)
        {
          	#  BR[RE1] ← NOT BR[RE2]
          			# RF[RE1] <- NOT RF[RE2]
          				(SELA=01011, MR=0, MA=0,
                  SELCOP=0011, MC=1, SELP=11, M7, C7, T6, LC, SELC=10101),
          			# Go to fetch
                	(A0=1, B=1, C=0)
        
        }
}

cmp RE1, RE2 {		#compare 2 numbers in register to check if they are equal
        co=010110,
        nwords=1,
        RE1=reg(25,21),
        RE2=reg(15,11)
        {
          	#  BR[RE1] - BR[RE2]
          			# SR <- RF[RE1] - RF[RE2]   (only update status reg)
                # If Z in SR = 1 -> numbers eq; else: neq
          				(SELA=10101, SELB=01011, MR=0, MA=0, MB=0
                  SELCOP=1011, MC=1, SELP=11, M7, C7),
          			# Go to fetch
                	(A0=1, B=1, C=0)
        
        }
}

beq S16 {		      	# Checks if the status register, after performing an   										                                                                                                                                     operation, has a 1 in the Z (zero) byte, and then adds a										                                                                                                                                     signed number (S16) to the PC register if the condition is 										 																																																																met, else, it jumps to fetch to execute another instruction
  		co=110100,
        nwords=1,
        S16=address(15,0)rel
  			{
           # IF (bit Z of SR == 1): 
           #    BR[PC] ← BR[PC] + S16
           		# IF Z in SR !=1 -> execute next instruction
                (C=110, B=1, A0=0, MADDR=endinstruction),
                # Else: PC = PC + S16
                # RT2 <- IR(S16)
                (SE=1, SIZE=10000, OFFSET=0, T3, C5),
          			# RT1 <- PC
                (T2, C4),
          			# PC <- RT1 + RT2
                (MA=1, MB=01, SELCOP=1010, MC=1, T6, M2=0, C2),
          			
                # endinstruction (fetch)
                endinstruction: (A0=1,B=1,C=0)
          
         }
}

bl U16 {								#jal
  		co=100001,
        nwords=1,
        U16=address(15,0)abs
  			{
           # BR[LR] ← BR[PC]  &  BR[PC] ← U16
                # RF[RE14] <- PC
                (T2, LC, SELC=01110, MR=1)  #MR=1 because we have a $14 (W/out anything in IR)
                # PC <- IR(U16)
                (SIZE=10000, OFFSET=0, T3, M2=0, C2)
          			# Go to fetch
                (A0=1, B=1, C=0)
           
         }
}

bx RE {								#jr
  			co=100010,
        nwords=1,
        RE=reg(20,16)
  			{
           # BR[PC] ← BR[RE]
                # PC <- RF[RE]
                (SELA=10000, MR=0, T9, M2=0, C2)  
          			# Go to fetch
                	(A0=1, B=1, C=0)
           
         }
}


halt {								#stop program
  		co=100011
      nwords=1
      {
        # BR[PC] ← 0x00    &   SP ← 0x00
        		#	PC <- RF[RE0] & RF[RE14] <- RF[RE0]   (RE0 is the $zero register)
            (SELA=00000, MR=1, T9, M2=0, C2, LC, SELC=01110, MR=1)
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