;;;; avr forth
;;;;
;;;; GPL V2 (only)

.set pc_ = pc

.org $0000
  rjmp amforthstart

.org pc_
; main entry point
amforthstart:
    clr zerol
    clr zeroh
    ; init first user data area
    ldi zl, low(heap)
    ldi zh, high(heap)
    movw upl, zl
    ; init return stack pointer
    ldi temp0,low(rstackstart)
    out SPL,temp0
    std Z+4, temp0
    ldi temp1,high(rstackstart)
    out SPH,temp1
    std Z+5, temp1

    ; init parameter stack pointer
    ldi yl,low(stackstart)
    std Z+6, yl
    ldi yh,high(stackstart)
    std Z+7, yh

    ; allocate space for User Area
    .set heap = heap + USERSIZE

    ; load Forth IP with starting word
    ldi XL, low(PFA_COLD)
    ldi XH, high(PFA_COLD)
    ; its a far jump...
    jmp_ DO_NEXT

.include "drivers/generic-isr.asm"
; lower part of the dictionary
.set VE_HEAD = $0000
.set VE_ENVHEAD = $0000

.include "dict_minimum.inc"
.include "dict_appl.inc"

.set lowflashlast = pc

.org amforth_interpreter
; the inner interpreter.
DO_DODOES:
    adiw wl, 1
    savetos
    movw tosl, wl
    ; the following takes the address from a real uC-call
    pop wh
    pop wl

    push XH
    push XL
    movw XL, wl
    rjmp DO_NEXT

DO_COLON: ; 31 CPU cycles to ijmp
    push XH
    push XL          ; PUSH IP
    adiw wl, 1       ; set W to PFA
    movw XL, wl

DO_NEXT: ; 24 CPU cycles to ijmp
    brts DO_INTERRUPT
    movw zl, XL        ; READ IP
    readflashcell wl, wh
    adiw XL, 1        ; INC IP

DO_EXECUTE: ; 12 cpu cycles to ijmp
    movw zl, wl
    readflashcell temp0,temp1
    movw zl, temp0
    ijmp

DO_INTERRUPT: ; 12 cpu cycles to rjmp (+12=24 to ijmp)
    ; here we deal with interrupts the forth way
    lds temp0, intcur
    ldi zl, LOW(intvec)
    ldi zh, HIGH(intvec)
    add zl, temp0
    adc zh, zeroh
    ldd wl, Z+0
    ldd wh, Z+1

    clt ; clear the t flag to indicate that the interrupt is handled
    rjmp DO_EXECUTE

.include "dict_core.inc"
.include "dict_appl_core.inc"

.set flashlast = pc

.eseg
    .dw -1           ; EEPROM Address 0 should not be used
    .dw lowflashlast ; HERE
    .dw VE_HEAD      ; HEAD
    .dw heap         ; HEAP
    .dw edp          ; EDP
    .dw XT_APPLTURNKEY  ; TURNKEY

; calculate baud rate error
.equ UBRR_VAL   = ((F_CPU+BAUD*8)/(BAUD*16)-1)  ; smart round
.equ BAUD_REAL  = (F_CPU/(16*(UBRR_VAL+1)))     ; effective baud rate
.equ BAUD_ERROR = ((BAUD_REAL*1000)/BAUD-1000)  ; error in pro mille

.if ((BAUD_ERROR>10) || (BAUD_ERROR<-10))       ; accept +/-10 error (pro mille)
  .error "Serial line cannot be set up properly (systematic baud error too high)"
.endif

    .dw (F_CPU/(BAUD * 16))-1    ; BAUDRATE
    .dw TIB          ; terminal input buffer
    .dw TIBSIZE      ; and its maximum length
    .dw VE_ENVHEAD   ; environmental queries
; 1st free address in EEPROM, see above
edp:
.cseg
