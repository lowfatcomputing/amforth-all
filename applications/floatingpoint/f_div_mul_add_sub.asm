
; ############## Pito's four primitives #################
; ############## IEEE 754 single precision ##############
; ############## f/ f* f+ f- words ######################
; v.1.0 Pito 16-9-2010
; v.1.1 Pito 22-9-2010
; 22-9-2010 BUG FIXED: FDIV shall use R0, R1 instead R8, R9
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
; it may show you up to 116 warnings (template's register redefinition)
; the f/ and f* are dependent
; the f+ and f- are dependent
;
; How to install:
; 1. put this file into amforth's ..\core\words library
; 2. do .include "words/f_div_mul_add_sub.asm" into your dict_appl.inc
; 3. compile amforth
; 4. flash it
; 5. load what you want
; 6. load Leon's float.lib ( !! DO NOT forget to cut-off 
;    or comment-out the words f/ f* f+ f- in Leon's lib)
; 7. enjoy the speed!
;
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; amforth 4.0
; Pito 16-9-2010
; ..core\words\f_div.asm
; ( a b --  c ) Function c = a / b
; R( ? -- ? )

VE_FDIV:
    .dw $ff02 
    .db "f/"
    .dw VE_HEAD
    .set VE_HEAD = VE_FDIV
XT_FDIV:
    .dw PFA_FDIV
PFA_FDIV:
		.cseg
; $$$ REDEFINITION $$$$$$$$$$$$$$$$$$$$$
	.def	_tmp0 = R0
	.def	_tmp1 = R1
;	.def	_tmp2 = Rx
;	.def	_tmp3 = Rx
;	.def	_tmp4 = Rx
;	.def	_tmp5 = Rx
;	.def	_tmp6 = Rx
;	.def	_tmp7 = Rx
;	.def	_tmp8 = Rx
;	.def	_tmp9 = Rx
;	.def	_tmp10 = Rx
;	.def	_tmp11 = Rx
;	.def	_tmp12 = Rx
;	.def	_tmp13 = Rx
;	.def	_tmp14 = Rx
;	.def	_tmp15 = Rx
;	.def	_tmp16 = Rx
	.def	_tmp17 = R13
 	.def	_tmp18 = R18		; 	word used
	.def	_tmp19 = R19
	.def	_tmp20 = R20
	.def	_tmp21 = R21

	.def	_tmp22 = R22
	.def	_tmp23 = R23
	.def	_tmp24 = R16		;24 tosl
	.def	_tmp25 = R17		;25	tosh

	.def	_tmp26 = R26		;26 X	word used
	.def	_tmp27 = R27		;27 X	
	.def	_tmp28 = R14			;28 Y	do not use,	word used	
	.def	_tmp29 = R15			;29 Y	do not use,
	.def	_tmp30 = R30		;30 Z  	Word used
	.def	_tmp31 = R31		;31 Z
;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; save registers
	push R0
	push R1
	; R2 you may use, restore to 0	
	; R3 you may use, restore to 0	
	;push R4
	;push R5
	;push R6
	;push R7
	;push R8
	;push R9
	;push R10
	;push R11
	;push R12
	push R13
	;push R14 ; you may use, no need to push/pop, = temp4
	;push R15 ; you may use, no need to push/pop, = temp5
	;push R16 ; you may use, no need to push/pop, = temp0
	;push R17 ; you may use, no need to push/pop, = temp1
	;push R18 ; you may use, no need to push/pop, = temp2
	;push R19 ; you may use, no need to push/pop, = temp3
	;push R20 ; you may use, no need to push/pop, = temp6
	;push R21 ; you may use, no need to push/pop, = temp7
	push R22
	push R23
	; R24 do not push/pop, = tosl
	; R25 do not push/pop, = tosh
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
	push R30 	; R30 you may use, no need to push/pop, = Z
	push R31 	; R31 you may use, no need to push/pop, = Z
;######################################################	
;main body
; Floating point B = A / B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT
f_div:
	; B and the result
	mov _tmp22, tosl
	mov _tmp23, tosh	
	ld _tmp30, Y+
	ld _tmp31, Y+
	; A	
	ld _tmp24, Y+
	ld _tmp25, Y+
	ld _tmp26, Y+
	ld _tmp27, Y+

	CALL __DIVF21

	; B
	st -Y , _tmp31
	st -Y , _tmp30
	mov tosh, _tmp23
	mov tosl, _tmp22

	jmp end_fdiv

;########## DO NOT TOUCH >>> ####################################	
__DIVF21:
	PUSH _tmp21
	RCALL __UNPACK
	CPI  _tmp23, 0x80
	BRNE __DIVF210
	TST  _tmp1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  _tmp25, 0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  _tmp0,_tmp1
	SEC
	SBC  _tmp25,_tmp23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  _tmp0
	RJMP __DIVF211
__DIVF216:
	MOV  _tmp23,_tmp25
	PUSH _tmp17
	PUSH _tmp18
	PUSH _tmp19
	PUSH _tmp20
	CLR  _tmp1
	CLR  _tmp17
	CLR  _tmp18
	CLR  _tmp19
	CLR  _tmp20
	CLR  _tmp21
	LDI  _tmp25, 32
__DIVF212:
	CP   _tmp26,_tmp30
	CPC  _tmp27,_tmp31
	CPC  _tmp24,_tmp22
	CPC  _tmp20,_tmp17
	BRLO __DIVF213
	SUB  _tmp26,_tmp30
	SBC  _tmp27,_tmp31
	SBC  _tmp24,_tmp22
	SBC  _tmp20,_tmp17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  _tmp21
	ROL  _tmp18
	ROL  _tmp19
	ROL  _tmp1
	ROL  _tmp26
	ROL  _tmp27
	ROL  _tmp24
	ROL  _tmp20
	DEC  _tmp25
	BRNE __DIVF212
	MOVW _tmp30,_tmp18
	MOV  _tmp22,_tmp1
	POP  _tmp20
	POP  _tmp19
	POP  _tmp18
	POP  _tmp17
	TST  _tmp22
	BRMI __DIVF215
	LSL  _tmp21
	ROL  _tmp30
	ROL  _tmp31
	ROL  _tmp22
	DEC  _tmp23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  _tmp21
	RET
;######################################################		
	
end_fdiv:

	pop R31
	pop R30 
	
	pop R27	
	pop R26
	
	pop R23
	pop R22
	
	;pop R21
	;pop R20
	;pop R19
	;pop R18
	;pop R17
	;pop R16
	;pop R15
	;pop R14
	
	pop R13

	pop R1
	pop R0
			
   jmp_ DO_NEXT		; this is the end of the word "f_div"
   
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


; amforth 4.0
; Pito 9-2010
; ..core\words\f_mul.asm
; ( a b --  c ) Function c = a * b
; R( ? -- ? )

VE_FMUL:
    .dw $ff02    
    .db "f*"
    .dw VE_HEAD
    .set VE_HEAD = VE_FMUL
XT_FMUL:
    .dw PFA_FMUL
PFA_FMUL:
		.cseg

; $$$ REDEFINITION $$$$$$$$$$$$$$$$$$$$$
	.def	_tmp0 = R0   ; !!!! MULT AND DIV USES IT !!!
	.def	_tmp1 = R1
;	.def	_tmp2 = Rx
;	.def	_tmp3 = Rx
;	.def	_tmp4 = Rx
;	.def	_tmp5 = Rx
;	.def	_tmp6 = Rx
;	.def	_tmp7 = Rx
;	.def	_tmp8 = Rx
;	.def	_tmp9 = Rx
;	.def	_tmp10 = Rx
;	.def	_tmp11 = Rx
;	.def	_tmp12 = Rx
;	.def	_tmp13 = Rx
;	.def	_tmp14 = Rx
;	.def	_tmp15 = Rx
;	.def	_tmp16 = Rx
	.def	_tmp17 = R13
 	.def	_tmp18 = R18		; 	word used
	.def	_tmp19 = R19
	.def	_tmp20 = R20
	.def	_tmp21 = R21

	.def	_tmp22 = R22
	.def	_tmp23 = R23
	.def	_tmp24 = R16		;24 tosl
	.def	_tmp25 = R17		;25	tosh

	.def	_tmp26 = R26		;26 X	word used
	.def	_tmp27 = R27		;27 X	
	.def	_tmp28 = R14			;28 Y	do not use,	word used	
	.def	_tmp29 = R15			;29 Y	do not use,
	.def	_tmp30 = R30		;30 Z  	Word used
	.def	_tmp31 = R31		;31 Z
;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; save registers
	push R0
	push R1
	; R2 you may use, restore to 0	
	; R3 you may use, restore to 0	
	;push R4
	;push R5
	;push R6
	;push R7
	;push R8
	;push R9
	;push R10
	;push R11
	push R13
	;push R14 ; you may use, no need to push/pop, = temp4
	;push R15 ; you may use, no need to push/pop, = temp5
	;push R16 ; you may use, no need to push/pop, = temp0
	;push R17 ; you may use, no need to push/pop, = temp1
	;push R18 ; you may use, no need to push/pop, = temp2
	;push R19 ; you may use, no need to push/pop, = temp3
	;push R20 ; you may use, no need to push/pop, = temp6
	;push R21 ; you may use, no need to push/pop, = temp7
	push R22
	push R23
	; R24 do not push/pop, = tosl
	; R25 do not push/pop, = tosh
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
	push R30 ; R30 you may use, no need to push/pop, = Z
	push R31 ; R31 you may use, no need to push/pop, = Z
;######################################################	
;main body
; Floating point B = A * B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN/OUT
f_mul:
	; B and the result
	mov _tmp22, tosl
	mov _tmp23, tosh	
	ld _tmp30, Y+
	ld _tmp31, Y+
	
	; A	
	ld _tmp24, Y+
	ld _tmp25, Y+
	ld _tmp26, Y+
	ld _tmp27, Y+
		
	CALL __MULF12

	; B
	st -Y , _tmp31
	st -Y , _tmp30
	mov tosh, _tmp23
	mov tosl, _tmp22

	jmp end_fmul
	
;########## DO NOT TOUCH >>> ####################################
__ROUND_REPACK:
	TST  _tmp21
	BRPL __REPACK
	CPI  _tmp21,0x80
	BRNE __ROUND_REPACK0
	SBRS _tmp30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW _tmp30,1
	ADC  _tmp22,_tmp25
	ADC  _tmp23,_tmp25
	BRVS __REPACK1
__REPACK:
	LDI  _tmp21,0x80
	EOR  _tmp21,_tmp23
	BRNE __REPACK0
	PUSH _tmp21
	RJMP __ZERORES
__REPACK0:
	CPI  _tmp21,0xFF
	BREQ __REPACK1
	LSL  _tmp22
	LSL  _tmp0
	ROR  _tmp21
	ROR  _tmp22
	MOV  _tmp23,_tmp21
	RET
__REPACK1:
	PUSH _tmp21
	TST  _tmp0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES
__UNPACK:
	LDI  _tmp21,0x80
	MOV  _tmp1,_tmp25
	AND  _tmp1,_tmp21
	LSL  _tmp24
	ROL  _tmp25
	EOR  _tmp25,_tmp21
	LSL  _tmp21
	ROR  _tmp24
__UNPACK1:
	LDI  _tmp21,0x80
	MOV  _tmp0,_tmp23
	AND  _tmp0,_tmp21
	LSL  _tmp22
	ROL  _tmp23
	EOR  _tmp23,_tmp21
	LSL  _tmp21
	ROR  _tmp22
	RET
__ZERORES:
	CLR  _tmp30
	CLR  _tmp31
	CLR  _tmp22
	CLR  _tmp23
	POP  _tmp21
	RET
__MINRES:
	SER  _tmp30
	SER  _tmp31
	LDI  _tmp22, 0x7F
	SER  _tmp23
	POP  _tmp21
	RET
__MAXRES:
	SER  _tmp30
	SER  _tmp31
	LDI  _tmp22, 0x7F
	LDI  _tmp23, 0x7F
	POP  _tmp21
	RET


__MULF12:
	PUSH _tmp21
	RCALL __UNPACK
	CPI  _tmp23,0x80
	BREQ __ZERORES
	CPI  _tmp25,0x80
	BREQ __ZERORES
	EOR  _tmp0,_tmp1
	SEC
	ADC  _tmp23,_tmp25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  _tmp0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH _tmp0
	PUSH _tmp17
	PUSH _tmp18
	PUSH _tmp19
	PUSH _tmp20
	CLR  _tmp17
	CLR  _tmp18
	CLR  _tmp25
	MUL  _tmp22,_tmp24
	MOVW _tmp20,_tmp0
	MUL  _tmp24,_tmp31
	MOV  _tmp19,_tmp0
	ADD  _tmp20,_tmp1
	ADC  _tmp21,_tmp25
	MUL  _tmp22,_tmp27
	ADD  _tmp19,_tmp0
	ADC  _tmp20,_tmp1
	ADC  _tmp21,_tmp25
	MUL  _tmp24,_tmp30
	RCALL __MULF126
	MUL  _tmp27,_tmp31
	RCALL __MULF126
	MUL  _tmp22,_tmp26
	RCALL __MULF126
	MUL  _tmp27,_tmp30
	RCALL __MULF127
	MUL  _tmp26,_tmp31
	RCALL __MULF127
	MUL  _tmp26,_tmp30
	ADD  _tmp17,_tmp1
	ADC  _tmp18,_tmp25
	ADC  _tmp19,_tmp25
	ADC  _tmp20,_tmp25
	ADC  _tmp21,_tmp25
	MOV  _tmp30,_tmp19
	MOV  _tmp31,_tmp20
	MOV  _tmp22,_tmp21
	MOV  _tmp21,_tmp18
	POP  _tmp20
	POP  _tmp19
	POP  _tmp18
	POP  _tmp17
	POP  _tmp0
	TST  _tmp22
	BRMI __MULF122
	LSL  _tmp21
	ROL  _tmp30
	ROL  _tmp31
	ROL  _tmp22
	RJMP __MULF123
__MULF122:
	INC  _tmp23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  _tmp21
	RET
__MULF127:
	ADD  _tmp17,_tmp0
	ADC  _tmp18,_tmp1
	ADC  _tmp19,_tmp25
	RJMP __MULF128
__MULF126:
	ADD  _tmp18,_tmp0
	ADC  _tmp19,_tmp1
__MULF128:
	ADC  _tmp20,_tmp25
	ADC  _tmp21,_tmp25
	RET
;######################################################		
	
end_fmul:

	pop R31
	pop R30 
	
	pop R27	
	pop R26
	
	pop R23
	pop R22
	
	;pop R21
	;pop R20
	;pop R19
	;pop R18
	;pop R17
	;pop R16
	;pop R15
	;pop R14
	
	pop R13

	pop R1
	pop R0
			
   jmp_ DO_NEXT		; this is the end of the word "f_mul"
   
;**********************************************************   

; amforth 4.0
; Pito 9-2010
; ..core\words\f_add.asm
; ( a b --  c ) Function c = a + b
; R( ? -- ? )

VE_FADD:
    .dw $ff02    
    .db "f+"
    .dw VE_HEAD
    .set VE_HEAD = VE_FADD
XT_FADD:
    .dw PFA_FADD
PFA_FADD:

		.cseg

; $$$ REDEFINITION $$$$$$$$$$$$$$$$$$$$$
	.def	_tmp0 = R8
	.def	_tmp1 = R9
;	.def	_tmp2 = Rx
;	.def	_tmp3 = Rx
;	.def	_tmp4 = Rx
;	.def	_tmp5 = Rx
;	.def	_tmp6 = Rx
;	.def	_tmp7 = Rx
;	.def	_tmp8 = Rx
;	.def	_tmp9 = Rx
;	.def	_tmp10 = Rx
;	.def	_tmp11 = Rx
;	.def	_tmp12 = Rx
;	.def	_tmp13 = Rx
;	.def	_tmp14 = Rx
;	.def	_tmp15 = Rx
;	.def	_tmp16 = Rx
	.def	_tmp17 = R13
 	.def	_tmp18 = R18		; 	word used
	.def	_tmp19 = R19
	.def	_tmp20 = R20
	.def	_tmp21 = R21

	.def	_tmp22 = R22
	.def	_tmp23 = R23
	.def	_tmp24 = R16		;24 tosl
	.def	_tmp25 = R17		;25	tosh

	.def	_tmp26 = R26		;26 X	word used
	.def	_tmp27 = R27		;27 X	
	.def	_tmp28 = R14			;28 Y	do not use,	word used	
	.def	_tmp29 = R15			;29 Y	do not use,
	.def	_tmp30 = R30		;30 Z  	Word used
	.def	_tmp31 = R31		;31 Z
;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; save registers
	;push R0
	;push R1
	; R2 you may use, restore to 0	
	; R3 you may use, restore to 0	
	;push R4
	;push R5
	;push R6
	;push R7
	push R8
	push R9
	;push R10
	;push R11
	push R13
	;push R14 ; you may use, no need to push/pop, = temp4
	;push R15 ; you may use, no need to push/pop, = temp5
	;push R16 ; you may use, no need to push/pop, = temp0
	;push R17 ; you may use, no need to push/pop, = temp1
	;push R18 ; you may use, no need to push/pop, = temp2
	;push R19 ; you may use, no need to push/pop, = temp3
	;push R20 ; you may use, no need to push/pop, = temp6
	;push R21 ; you may use, no need to push/pop, = temp7
	push R22
	push R23
	; R24 do not push/pop, = tosl
	; R25 do not push/pop, = tosh
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
	push R30 	; R30 you may use, no need to push/pop, = Z
	push R31 	; R31 you may use, no need to push/pop, = Z
;######################################################	
;main body
; Floating point B = A + B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN/OUT
f_add:
	; B and the result
	mov _tmp22, tosl
	mov _tmp23, tosh	
	ld _tmp30, Y+
	ld _tmp31, Y+
	
	; A	
	ld _tmp24, Y+
	ld _tmp25, Y+
	ld _tmp26, Y+
	ld _tmp27, Y+

	CALL __ADDF12

	; B
	st -Y , _tmp31
	st -Y , _tmp30
	mov tosh, _tmp23
	mov tosl, _tmp22

	jmp end_fadd
	
;########## DO NOT TOUCH >>> ####################################	
	.CSEG
__aREPACK:
	LDI  _tmp21,0x80
	EOR  _tmp21,_tmp23
	BRNE __aREPACK0
	PUSH _tmp21
	RJMP __aZERORES
__aREPACK0:
	CPI  _tmp21,0xFF
	BREQ __aREPACK1
	LSL  _tmp22
	LSL  _tmp0
	ROR  _tmp21
	ROR  _tmp22
	MOV  _tmp23,_tmp21
	RET
__aREPACK1:
	PUSH _tmp21
	TST  _tmp0
	BRMI __aREPACK2
	RJMP __aMAXRES
__aREPACK2:
	RJMP __aMINRES
__aUNPACK:
	LDI  _tmp21,0x80
	MOV  _tmp1,_tmp25
	AND  _tmp1,_tmp21
	LSL  _tmp24
	ROL  _tmp25
	EOR  _tmp25,_tmp21
	LSL  _tmp21
	ROR  _tmp24
__aUNPACK1:
	LDI  _tmp21,0x80
	MOV  _tmp0,_tmp23
	AND  _tmp0,_tmp21
	LSL  _tmp22
	ROL  _tmp23
	EOR  _tmp23,_tmp21
	LSL  _tmp21
	ROR  _tmp22
	RET
__SWAPACC:
	PUSH R20
	MOVW R20,_tmp30
	MOVW _tmp30,_tmp26
	MOVW _tmp26,R20
	MOVW R20,_tmp22
	MOVW _tmp22,_tmp24
	MOVW _tmp24,R20
	MOV  R20,_tmp0
	MOV  _tmp0,_tmp1
	MOV  _tmp1,R20
	POP  R20
	RET
__UADD12:
	ADD  _tmp30,_tmp26
	ADC  _tmp31,_tmp27
	ADC  _tmp22,_tmp24
	RET
__NEGMAN1:
	COM  _tmp30
	COM  _tmp31
	COM  _tmp22
	SUBI _tmp30,-1
	SBCI _tmp31,-1
	SBCI _tmp22,-1
	RET
__ADDF12:
	PUSH _tmp21
	RCALL __aUNPACK
	CPI  _tmp25,0x80
	BREQ __ADDF129
__ADDF120:
	CPI  _tmp23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  _tmp21,_tmp23
	SUB  _tmp21,_tmp25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  _tmp21,24
	BRLO __ADDF123
	CLR  _tmp26
	CLR  _tmp27
	CLR  _tmp24
__ADDF123:
	CPI  _tmp21,8
	BRLO __ADDF124
	MOV  _tmp26,_tmp27
	MOV  _tmp27,_tmp24
	CLR  _tmp24
	SUBI _tmp21,8
	RJMP __ADDF123
__ADDF124:
	TST  _tmp21
	BREQ __ADDF126
__ADDF125:
	LSR  _tmp24
	ROR  _tmp27
	ROR  _tmp26
	DEC  _tmp21
	BRNE __ADDF125
__ADDF126:
	MOV  _tmp21,_tmp0
	EOR  _tmp21,_tmp1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  _tmp22
	ROR  _tmp31
	ROR  _tmp30
	INC  _tmp23
	BRVC __ADDF129
	RJMP __aMAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __aREPACK
	POP  _tmp21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  _tmp30,_tmp26
	SBC  _tmp31,_tmp27
	SBC  _tmp22,_tmp24
	BREQ __aZERORES
	BRCC __ADDF1210
	COM  _tmp0
	RCALL __NEGMAN1
__ADDF1210:
	TST  _tmp22
	BRMI __ADDF129
	LSL  _tmp30
	ROL  _tmp31
	ROL  _tmp22
	DEC  _tmp23
	BRVC __ADDF1210
__aZERORES:
	CLR  _tmp30
	CLR  _tmp31
	CLR  _tmp22
	CLR  _tmp23
	POP  _tmp21
	RET
__aMINRES:
	SER  _tmp30
	SER  _tmp31
	LDI  _tmp22,0x7F
	SER  _tmp23
	POP  _tmp21
	RET
__aMAXRES:
	SER  _tmp30
	SER  _tmp31
	LDI  _tmp22,0x7F
	LDI  _tmp23,0x7F
	POP  _tmp21
	RET
;########## DO NOT TOUCH >>> ####################################	
__SUBF12:
	PUSH _tmp21
	RCALL __aUNPACK
	CPI  _tmp25,0x80
	BREQ __ADDF129
	LDI  _tmp21,0x80
	EOR  _tmp1,_tmp21
	RJMP __ADDF120
;######################################################	
;######################################################		
	
end_fadd:

	pop R31
	pop R30 
	
	pop R27	
	pop R26
	
	pop R23
	pop R22
	
	;pop R21
	;pop R20
	;pop R19
	;pop R18
	;pop R17
	;pop R16
	;pop R15
	;pop R14
	
	pop R13

	pop R9
	pop R8
			
   jmp_ DO_NEXT		; this is the end of the word "f_add"
   
   
   
;**********************************************************   

; amforth 4.0
; Pito 9-2010
; ..core\words\f_sub.asm
; ( a b --  c ) Function c = a - b
; R( ? -- ? )

VE_FSUB:
    .dw $ff02    
    .db "f-"
    .dw VE_HEAD
    .set VE_HEAD = VE_FSUB
XT_FSUB:
    .dw PFA_FSUB
PFA_FSUB:

		.cseg

; $$$ REDEFINITION $$$$$$$$$$$$$$$$$$$$$
	.def	_tmp0 = R8
	.def	_tmp1 = R9
;	.def	_tmp2 = Rx
;	.def	_tmp3 = Rx
;	.def	_tmp4 = Rx
;	.def	_tmp5 = Rx
;	.def	_tmp6 = Rx
;	.def	_tmp7 = Rx
;	.def	_tmp8 = Rx
;	.def	_tmp9 = Rx
;	.def	_tmp10 = Rx
;	.def	_tmp11 = Rx
;	.def	_tmp12 = Rx
;	.def	_tmp13 = Rx
;	.def	_tmp14 = Rx
;	.def	_tmp15 = Rx
;	.def	_tmp16 = Rx
	.def	_tmp17 = R13
 	.def	_tmp18 = R18		; 	word used
	.def	_tmp19 = R19
	.def	_tmp20 = R20
	.def	_tmp21 = R21

	.def	_tmp22 = R22
	.def	_tmp23 = R23
	.def	_tmp24 = R16		;24 tosl
	.def	_tmp25 = R17		;25	tosh

	.def	_tmp26 = R26		;26 X	word used
	.def	_tmp27 = R27		;27 X	
	.def	_tmp28 = R14			;28 Y	do not use,	word used	
	.def	_tmp29 = R15			;29 Y	do not use,
	.def	_tmp30 = R30		;30 Z  	Word used
	.def	_tmp31 = R31		;31 Z
;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; save registers
	;push R0
	;push R1
	; R2 you may use, restore to 0	
	; R3 you may use, restore to 0	
	;push R4
	;push R5
	;push R6
	;push R7
	push R8
	push R9
	;push R10
	;push R11
	push R13
	;push R14 ; you may use, no need to push/pop, = temp4
	;push R15 ; you may use, no need to push/pop, = temp5
	;push R16 ; you may use, no need to push/pop, = temp0
	;push R17 ; you may use, no need to push/pop, = temp1
	;push R18 ; you may use, no need to push/pop, = temp2
	;push R19 ; you may use, no need to push/pop, = temp3
	;push R20 ; you may use, no need to push/pop, = temp6
	;push R21 ; you may use, no need to push/pop, = temp7
	push R22
	push R23
	; R24 do not push/pop, = tosl
	; R25 do not push/pop, = tosh
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
	push R30 
	; R30 you may use, no need to push/pop, = Z
	push R31 
	; R31 you may use, no need to push/pop, = Z
;######################################################	
;main body
; Floating point B = A - B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN/OUT
f_sub:
	; A	
	mov _tmp24, tosl
	mov _tmp25, tosh
	ld _tmp26, Y+
	ld _tmp27, Y+	
	
	; B 
	ld _tmp22, Y+
	ld _tmp23, Y+	
	ld _tmp30, Y+
	ld _tmp31, Y+

	CALL __SUBF12

	; B
	st -Y , _tmp31
	st -Y , _tmp30
	mov tosh, _tmp23
	mov tosl, _tmp22
;*************************************
	pop R31
	pop R30 
	
	pop R27	
	pop R26
	
	pop R23
	pop R22
	
	;pop R21
	;pop R20
	;pop R19
	;pop R18
	;pop R17
	;pop R16
	;pop R15
	;pop R14
	
	pop R13

	pop R9
	pop R8
			
   jmp_ DO_NEXT		; this is the end of the word "f_sub"
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
; %%%%%%%%%%%%%%%%% END OF LIBRARY %%%%%%%%%%%%%%%%%%%%%%
