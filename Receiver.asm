org 00H

LED EQU P2.0
FAN EQU P2.1
BUZ EQU P2.2


; Serial initialization
SERIAL_INIT:
	MOV TMOD, #20H	; or 00100000B => Mode 2 for Timer1 (8bit Auto Reload)
	MOV TH1, #0FDH	;Setting BaudRate of 9600 (-3). SMOD is 0 by default
	MOV SCON, #50H	;Serial Mode 1, REN Enabled or 01010000B
	SETB TR1
	
	
; PORTS INIT
 MOV P2, #00H
	
RECIEVE:
	JNB RI, $
	MOV A, SBUF
	CLR RI
	MOV R5, A
	MOV P1, R5
	;ACALL DELAY
	
COMPARE1:
	MOV A, R5
	SUBB A, #'1'
	JNZ COMPARE2
	JB LED, LEDOFF
	SETB LED
	LJMP RECIEVE
LEDOFF:
	CLR LED
	LJMP RECIEVE
	
	
COMPARE2:
	MOV A, R5
	SUBB A, #'2'
	JNZ COMPARE3
	JB FAN, FANOFF
	SETB FAN
	LJMP RECIEVE
FANOFF:
	CLR FAN
	LJMP RECIEVE
	
	
	
COMPARE3:
	MOV A, R5
	SUBB A, #'3'
	JNZ RECIEVE
	JB BUZ, BUZZOFF
	SETB BUZ
	LJMP RECIEVE
BUZZOFF:
	CLR BUZ
	LJMP RECIEVE
	
	
HLT:	
	SJMP RECIEVE
	

;DELAY SUBROUTINE
DELAY:
    	MOV R0, #10 ;DELAY. HIGHER VALUE FOR FASTER CPUS
Y:	MOV R1, #255
	DJNZ R1, $
	DJNZ R0, Y

END