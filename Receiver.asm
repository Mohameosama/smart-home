org 00H

LED EQU P0.0



RS BIT P2.0
RW BIT P2.1
E  BIT P2.2


; Serial initialization
SERIAL_INIT:
	MOV TMOD, #20H	; or 00100000B => Mode 2 for Timer1 (8bit Auto Reload)
	MOV TH1, #0FDH	;Setting BaudRate of 9600 (-3). SMOD is 0 by default
	MOV SCON, #50H	;Serial Mode 1, REN Enabled or 01010000B
	SETB TR1

;LCD INITIALIZATION
	MOV A, #38H	; INITIATE LCD ; 00 0011 1000 ; sets interface length , number of lines, and font
	ACALL COMMANDWRT
	ACALL DELAY

	MOV A, #0CH	; DISPLAY & CURSOR ON ; 00 0000 1100
	ACALL COMMANDWRT
	ACALL DELAY
		
	ACALL CLRLCD
	
	
RECIEVE:
	JNB RI, $
	MOV A, SBUF
	CLR RI
	MOV R5, A

COMPARE1:
	ACALL CLRLCD
	MOV A, R5
	SUBB A, #'1'
	JNZ COMPARE2
	JNB LED, LEDOFF ;JUMP TO TURN IT OFF IF IT IS ZERO (WHICH IS ON AS IT IS ACTIVE LOW)
	CLR LED
	MOV DPTR, #LED_ON
	SJMP STRING
LEDOFF:
	SETB LED
	MOV DPTR, #LED_OFF
	SJMP STRING	
COMPARE2:
	ACALL CLRLCD
	MOV A, R5
	SUBB A, #'3'
	JNZ RECIEVE
	MOV DPTR, #FAN_ON
	SJMP STRING
	
;PRINTING A STRING
STRING:	
	CLR A
	MOVC A, @A+DPTR ; move char from data in A register we khalas
	ACALL DATAWRT
	ACALL DELAY
	INC DPTR
	JZ HLT
	SJMP STRING
	
HLT:	
	SJMP RECIEVE
	

;DELAY SUBROUTINE
DELAY:
    	MOV R0, #10 ;DELAY. HIGHER VALUE FOR FASTER CPUS
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

    MOV P1, A ;SEND DATA TO P1
	CLR RS	;RS=0 FOR COMMAND
	CLR RW	;R/W=0 FOR WRITE
	SETB E	;E=1 FOR HIGH PULSE
	ACALL DELAY ;SOME DELAY
	CLR E	;E=0 FOR H-L PULSE
	
	RET

;SUBROUTINE FOR DATA LACTCHING TO LCD
DATAWRT:
	MOV P1, A
    	SETB RS	;;RS=1 FOR DATA and rw=0 for write data command from data lines
    	CLR RW
    	SETB E
	ACALL DELAY
	CLR E
	
	RET
	
ORG 300H
LED_ON:	 DB	"LED ON" ,0 
LED_OFF: DB	"LED OFF" ,0
FAN_ON:	 DB	"FAN ON" ,0
END