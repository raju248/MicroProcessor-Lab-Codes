;*****************************************
;*     MDE-8086 EXPERIMENT PROGRAM       *
;*     Chapter 7-4 (Example 3)           *
;*     PROGRAM BY MiDAS ENGINEERING      *
;*****************************************
	;
        ;	FILENAME  : FND.ASM
        ;	PROCESSOR : I8086
        ;	VER.      : V1.1
        ;
CODE	SEGMENT
	ASSUME	CS:CODE,DS:CODE,ES:CODE,SS:CODE
	;

;port selection for 7 segment and led

PPIC_C	EQU	1FH
PPIC	EQU	1DH
PPIB	EQU	1BH
PPIA	EQU	19H


;port select for dot matrix

PPIC_C1	EQU	1EH ; control register
PPIC1	EQU	1CH 
PPIB1	EQU	1AH
PPIA1	EQU	18H



;initialize ppic1
	;	
	ORG	1000H
	MOV	AL,10000000B
	OUT	PPIC_C,AL
	;
	MOV	AL,11110000B ;clear 4 led
	OUT	PPIB,AL
	;
	MOV	AL,00000000B 
	OUT	PPIC,AL
	;


	;Starts from 7 segment

L2: 	MOV	AL,11111111B  ;clear 7 segment
	OUT	PPIA1,AL
	

	MOV	SI,OFFSET DATA

L1:	MOV	AL,BYTE PTR CS:[SI]
	CMP	AL,00H
	JE 	LED1	; moving to LED
	
	OUT	PPIA,AL
	CALL	TIMER
	INC	SI
	JMP	L1
	
	
		
	;
	INT	3
	;	


LED1:	MOV	AL, 11111111B ;clear 7 segment
	OUT 	PPIA, AL
	
	MOV	AL,11110001B  ;turn on led no 1

LED2:	OUT	PPIB,AL
	CALL	TIMER
	SHL	AL,1
	TEST	AL,00010000B
	JNZ	DOT1	; moving to dot matrix
	OR	AL,11110000B
	JMP	LED2		
	;
	

DOT1:	
	MOV	AL, 11110000B	;clear 4 led
	OUT 	PPIB, AL	

	MOV	AL,10000000B	
	OUT	PPIC_C1,AL
	;
	MOV	AL,11111111B	;select all column	
	OUT	PPIC1,AL
	;
	MOV	AL,11111111B	;turn off all red light
	OUT	PPIB1,AL
	;

	MOV	AL,11111110B

DOT2:	OUT	PPIA1,AL	;turn on row
	CALL	TIMER
	STC
	ROL	AL,1
	JC	DOT2	
	JMP	L2		;moving to 7 segment	
	;
	INT	3
	;

	
TIMER:	MOV	CX,0
TIMER1:	NOP
	NOP
	NOP
	NOP
	LOOP	TIMER1
	RET
	;
DATA:	DB	11000000B
	DB	11111001B
	DB	10100100B
	DB	10110000B
	DB	10011001B
	DB	10010010B
	DB	10000010B
	DB	11111000B
	DB	10000000B
	DB	10010000B
	DB	00H

CODE	ENDS
	END


