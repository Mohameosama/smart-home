ORG 0

; Serial initialization
MOV TMOD, #20H	; or 00100000B => Mode 2 for Timer1 (8bit Auto Reload)
MOV TH1, #0FDH	;Setting BaudRate of 9600 (-3). SMOD is 0 by default
MOV SCON, #50H	;Serial Mode 1, REN Enabled or 01010000B
SETB TR1


RS BIT P3.3
RW BIT P3.4
E  BIT P3.5


;LCD INITIALIZATION
	MOV A, #38H	; INITIATE LCD ; 00 0011 1000 ; sets interface length , number of lines, and font
	ACALL COMMANDWRT
	ACALL DELAY

	MOV A, #0CH	; DISPLAY & CURSOR ON ; 00 0000 1100
	ACALL COMMANDWRT
	ACALL DELAY
		
	ACALL CLRLCD
	
	
; initializing and reading keypad continuously
;MOV DPTR,#DIGITS ;// moves starting address of DIGITS to DPTR

BACK:
     MOV P1,#11111111B ;// loads P1 with all 1's
     CLR P1.0  ;// makes row 1 low
     JB P1.4,NEXT1  ;// checks whether column 1 is low and jumps to NEXT1 if not low
     MOV A,#'1'   ;// loads a with 0D if column is low (that means key 1 is pressed)
     ACALL SEND  ;// calls SEND subroutine
     ACALL CLRLCD
     MOV DPTR, #LED
     ACALL STRING
NEXT1:
      JB P1.5,NEXT2 ;// checks whether column 2 is low and so on...
      MOV A,#'2'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #FAN
      ACALL STRING
NEXT2:
      JB P1.6,NEXT3
      MOV A,#'3'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #BUZZER
      ACALL STRING
NEXT3:
      JB P1.7,NEXT4
      MOV A,#'A'
      ACALL SEND
NEXT4:
      SETB P1.0
      CLR P1.1
      JB P1.4,NEXT5
      MOV A,#'4'
      ACALL SEND
NEXT5:
      JB P1.5,NEXT6
      MOV A,#'5'
      ACALL SEND
NEXT6:
      JB P1.6,NEXT7
      MOV A,#'6'
      ACALL SEND
NEXT7:
      JB P1.7,NEXT8
      MOV A,#'B'
      ACALL SEND
NEXT8:
      SETB P1.1
      CLR P1.2
      JB P1.4,NEXT9
      MOV A,#'7'
      ACALL SEND
NEXT9:
      JB P1.5,NEXT10
      MOV A,#'8'
      ACALL SEND
NEXT10:
      JB P1.6,NEXT11
      MOV A,#'9'
      ACALL SEND
NEXT11:
      JB P1.7,NEXT12
      MOV A,#'C'
      ACALL SEND
NEXT12:
      SETB P1.2
      CLR P1.3
      JB P1.4,NEXT13
      MOV A,#'*'
      ACALL SEND
NEXT13:
      JB P1.5,NEXT14
      MOV A,#'0'
      ACALL SEND
NEXT14:
      JB P1.6,NEXT15
      MOV A,#'#'
      ACALL SEND
NEXT15:
      JB P1.7,DONEKEYPAD
      MOV A,#'D'
      ACALL SEND
      LJMP BACK

DONEKEYPAD:
	LJMP BACK

SEND:
	; initializing transmission
	;MOVC A,@A+DPTR
        ;MOV P2,A 
	MOV SBUF, A
	JNB TI, $
	CLR TI
	ACALL DELAY
	ACALL DELAY	
	RET
	
STRING:	
	CLR A
	MOVC A, @A+DPTR ; move char from data in A register we khalas
	ACALL DATAWRT
	INC DPTR
	JZ FINISHED
	SJMP STRING
FINISHED:
	RET

	
DELAY:
    	MOV R0, #255 ;DELAY. HIGHER VALUE FOR FASTER CPUS
Y:	MOV R1, #255
	DJNZ R1, $
	DJNZ R0, Y
	RET

CLRLCD:
	MOV A, #01H	; CLEAR LCD ; 00 0000 0001 ; clears ram in lcd
	ACALL COMMANDWRT
	ACALL DELAY
	RET	

;COMMAND SUB-ROUTINE FOR LCD CONTROL
COMMANDWRT:

	MOV P2, A ;SEND DATA TO P1
	CLR RS	;RS=0 FOR COMMAND
	CLR RW	;R/W=0 FOR WRITE
	SETB E	;E=1 FOR HIGH PULSE
	ACALL DELAY ;SOME DELAY
	CLR E	;E=0 FOR H-L PULSE
	RET
	
DATAWRT:
	MOV P2, A
    	SETB RS	;;RS=1 FOR DATA and rw=0 for write data command from data lines
    	CLR RW
    	SETB E
	ACALL DELAY
	CLR E
	RET

ORG 300H
LED:	 DB	"LED" ,0 
FAN:	 DB	"FAN" ,0
BUZZER:  DB     "BUZZER", 0

END