; ############## Pito's Five primitives #################
; ############## IEEE 754 single precision ##############
; ############## f/ f* f+ f- fsqrt words ################
;
; v.1.0 Pito 16-9-2010
; v.1.1 Pito 22-9-2010
; 22-9-2010 BUG FIXED: FDIV shall use R0, R1 instead R8, R9
; v.2.0 Pito 27-5-2011
; 27-5-2011 BUG FIXED: T flag dependency removed fully
;           Added: fsqrt
;
; The library is provided as-is, no guarantees or/and warrantees of any kind
; are given, no liability of any kind is provided for any and all direct, 
; indirect or consequent damages or losses caused by using this software
; library
;
;  This program is free software; you can redistribute it and/or
;  modify it under the terms of the GNU General Public License
;  as published by the Free Software Foundation; using version 2
;  of the License.

; Note:
; Please add in template.asm following float stack, 50bytes required (e.g):
; 
; addresses of various data segments
; .set rstackstart = RAMEND      ; start address of return stack, grows downward
; .set FLIBSTACK = RAMEND - 80    ; FLOATLIB space
; .set stackstart  = RAMEND - 130 ; start address of data stack, grows downward
;
; How to install:
; 1. put this file into amforth's ..\core\words library
; 2. do .include "words/float_5primitives" into your dict_appl.inc
; 3. compile amforth
; 4. flash it
; 5. load what you want
; 6. load Leon's float.lib ( !! DO NOT forget to cut-off 
;    or comment-out the words f/ f* f+ f- in Leon's lib !!!!)
; 7. enjoy the speed!
;
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FDIV:
    .dw $ff02 
    .db "f/"
    .dw VE_HEAD
    .set VE_HEAD = VE_FDIV
XT_FDIV:
    .dw PFA_FDIV
PFA_FDIV:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = A / B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch B 
	mov R22, tosl
	mov R23, tosh	
	ld R30, Y+
	ld R31, Y+
	; fetch A	
	ld R24, Y+
	ld R25, Y+
	ld R26, Y+
	ld R27, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	
	CALL __DIVF21
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FMUL:
    .dw $ff02 
    .db "f*"
    .dw VE_HEAD
    .set VE_HEAD = VE_FMUL
XT_FMUL:
    .dw PFA_FMUL
PFA_FMUL:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = A * B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch B 
	mov R22, tosl
	mov R23, tosh	
	ld R30, Y+
	ld R31, Y+
	; fetch A	
	ld R24, Y+
	ld R25, Y+
	ld R26, Y+
	ld R27, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29

	CALL __MULF12
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FADD:
    .dw $ff02 
    .db "f+"
    .dw VE_HEAD
    .set VE_HEAD = VE_FADD
XT_FADD:
    .dw PFA_FADD
PFA_FADD:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = A + B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch B 
	mov R22, tosl
	mov R23, tosh	
	ld R30, Y+
	ld R31, Y+
	; fetch A	
	ld R24, Y+
	ld R25, Y+
	ld R26, Y+
	ld R27, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29

	CALL __ADDF12
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FSUB:
    .dw $ff02 
    .db "f-"
    .dw VE_HEAD
    .set VE_HEAD = VE_FSUB
XT_FSUB:
    .dw PFA_FSUB
PFA_FSUB:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = A - B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; fetch B 
	ld R22, Y+
	ld R23, Y+	
	ld R30, Y+
	ld R31, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	
	CALL __SUBF12
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FSQRT:
    .dw $ff05 
    .db "fsqrt",0
    .dw VE_HEAD
    .set VE_HEAD = VE_FSQRT
XT_FSQRT:
    .dw PFA_FSQRT
PFA_FSQRT:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = sqrt(A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b= f(a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _sqrt
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
; ******************** Do not touch !!! *****************
	;.EQU SPL=0x3D
	;.EQU SPH=0x3E
	

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM
		
	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.CSEG

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1
__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES
__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24
__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET
__CFD1U:
	; ### SET
	CLR R14
	COM R14
	; ###
	RJMP __CFD1U0
__CFD1:
	; ### CLT
	CLR R14
	; ###
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	; ### BRTC __CFD19
	SBRS R14,7
	RJMP __CFD19
	; ###
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	; ### BLD  R23,7
	MOV R23, R14
	; ###
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET
__CDF1U:
	; ### SET
	CLR R14
	COM R14
	; ###
	RJMP __CDF1U0
__CDF1:
	; ### CLT
	CLR R14
	; ###
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	; ### BRTS __CDF11
	SBRC R14,7
	RJMP __CDF11
	; ###
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET
__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET
__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET
__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET
__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21
	RJMP __ADDF120
__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210
__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET
__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET
__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET
__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET
__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET
__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET
__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121
_sqrt:
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret
__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET
__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET
__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET
; ***************************** END OF LIB **************************
