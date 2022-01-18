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
		
ACALL CLRLCD    ; clear lcd to prepare for other strings
	
	
; initializing and reading keypad continuously
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
      ACALL CLRLCD
      MOV DPTR, #SAPA
      ACALL STRING
NEXT4:
      SETB P1.0
      CLR P1.1
      JB P1.4,NEXT5
      MOV A,#'4'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #AP4
      ACALL STRING
NEXT5:
      JB P1.5,NEXT6
      MOV A,#'5'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #AP5
      ACALL STRING
NEXT6:
      JB P1.6,NEXT7
      MOV A,#'6'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #AP6
      ACALL STRING
NEXT7:
      JB P1.7,NEXT8
      MOV A,#'B'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #SAPB
      ACALL STRING
NEXT8:
      SETB P1.1
      CLR P1.2
      JB P1.4,NEXT9
      MOV A,#'7'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #AP7
      ACALL STRING
NEXT9:
      JB P1.5,NEXT10
      MOV A,#'8'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #AP8
      ACALL STRING
NEXT10:
      JB P1.6,NEXT11
      MOV A,#'9'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #AP9
      ACALL STRING
NEXT11:
      JB P1.7,NEXT12
      MOV A,#'C'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #SAPC
      ACALL STRING
NEXT12:
      SETB P1.2
      CLR P1.3
      JB P1.4,NEXT13
      MOV A,#'*'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #SAPS
      ACALL STRING
NEXT13:
      JB P1.5,NEXT14
      MOV A,#'0'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #ZERO
      ACALL STRING
NEXT14:
      JB P1.6,NEXT15
      MOV A,#'#'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #SAPT
      ACALL STRING
NEXT15:
      JB P1.7,DONEKEYPAD
      MOV A,#'D'
      ACALL SEND
      ACALL CLRLCD
      MOV DPTR, #SAPD
      ACALL STRING
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
ZERO:    DB	"ZERO", 0
LED:	 DB	"LED" ,0 
FAN:	 DB	"FAN" ,0
BUZZER:  DB     "BUZZER", 0
AP4:     DB	"AP4", 0
AP5:     DB	"AP5", 0
AP6:     DB	"AP6", 0
AP7:     DB	"AP7", 0
AP8:     DB	"AP8", 0
AP9:     DB	"AP9", 0
SAPA:    DB	"SAPA", 0
SAPB:    DB	"SAPB", 0
SAPC:    DB	"SAPC", 0
SAPD:    DB	"SAPD", 0
SAPS:    DB	"SAPS", 0
SAPT:	 DB	"SAPH", 0

END