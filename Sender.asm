ORG 0

MOV TMOD, #20H	; or 00100000B => Mode 2 for Timer1 (8bit Auto Reload)
MOV TH1, #0FDH	;Setting BaudRate of 9600 (-3). SMOD is 0 by default
MOV SCON, #50H	;Serial Mode 1, REN Enabled or 01010000B
SETB TR1

; initializing and reading keypad continuously
MOV DPTR,#DIGITS ;// moves starting address of DIGITS to DPTR

BACK:MOV P1,#11111111B ;// loads P1 with all 1's
     CLR P1.0  ;// makes row 1 low
     JB P1.4,NEXT1  ;// checks whether column 1 is low and jumps to NEXT1 if not low
     MOV A,#0D   ;// loads a with 0D if column is low (that means key 1 is pressed)
     ACALL SEND  ;// calls SEND subroutine
NEXT1:JB P1.5,NEXT2 ;// checks whether column 2 is low and so on...
      MOV A,#1D
      ACALL SEND
NEXT2:JB P1.6,NEXT3
      MOV A,#2D
      ACALL SEND
NEXT3:JB P1.7,NEXT4
      MOV A,#3D
      ACALL SEND
NEXT4:SETB P1.0
      CLR P1.1
      JB P1.4,NEXT5
      MOV A,#4D
      ACALL SEND
NEXT5:JB P1.5,NEXT6
      MOV A,#5D
      ACALL SEND
NEXT6:JB P1.6,NEXT7
      MOV A,#6D
      ACALL SEND
NEXT7:JB P1.7,NEXT8
      MOV A,#7D
      ACALL SEND
NEXT8:SETB P1.1
      CLR P1.2
      JB P1.4,NEXT9
      MOV A,#8D
      ACALL SEND
NEXT9:JB P1.5,NEXT10
      MOV A,#9D
      ACALL SEND
NEXT10:JB P1.6,NEXT11
       MOV A,#10D
       ACALL SEND
NEXT11:JB P1.7,NEXT12
       MOV A,#11D
       ACALL SEND
NEXT12:SETB P1.2
       CLR P1.3
       JB P1.4,NEXT13
       MOV A,#12D
       ACALL SEND
NEXT13:JB P1.5,NEXT14
       MOV A,#13D
       ACALL SEND
NEXT14:JB P1.6,NEXT15
       MOV A,#14D
       ACALL SEND
NEXT15:JB P1.7,BACK
       MOV A,#15D
       ACALL SEND
       LJMP BACK

SEND:
	; initializing transmission
	MOVC A,@A+DPTR
        ;MOV P2,A 
	MOV SBUF, A
	JNB TI, $
	CLR TI
	ACALL DELAY
	ACALL DELAY	
	RET
	
	
	
DELAY:
    	MOV R0, #255 ;DELAY. HIGHER VALUE FOR FASTER CPUS
Y:	MOV R1, #255
	DJNZ R1, $
	DJNZ R0, Y
	RET
	
	
DIGITS:
	DB "1" ;PATTERN FOR "7"
 	DB "2" ;PATTERN FOR "8"
  	DB "3" ;PATTERN FOR "9"
  	DB "A" ;PATTERN FOR "/
  	DB "4" ;PATTERN FOR "4"
  	DB "5" ;PATTERN FOR "5"
	DB "6" ;PATTERN FOR "6"
	DB "B" ;PATTERN FOR "/"
	DB "7" ;PATTERN FOR "1"
	DB "8" ;PATTERN FOR "2"
	DB "9" ;PATTERN FOR "3"
 	DB "B" ;PATTERN FOR "/"
  	DB "*" ;PATTERN FOR "/"
   	DB "0" ;PATTERN FOR "0"
    	DB "#" ;PATTERN FOR "/"
    	DB "D" ;PATTERN FOR "/"
     
END