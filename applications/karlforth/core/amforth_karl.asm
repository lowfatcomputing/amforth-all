;;;; avr forth
;;;;
;;;; GPL V2 (only)

.set pc_ = pc

.org $0000
  jmp_ amforthstart
.org pc_
; main entry point
amforthstart:
    in_ r10, MCUSR
    clr r11
    clr zerol
    clr zeroh
    out_ MCUSR, zerol
    ; init first user data area
    ldi zl, low(here)
    ldi zh, high(here)
    movw upl, zl
    ; init return stack pointer
    ldi temp0,low(rstackstart)
    out_ SPL,temp0
    std Z+4, temp0
    ldi temp1,high(rstackstart)
    out_ SPH,temp1
    std Z+5, temp1

    ; init parameter stack pointer
    ldi yl,low(stackstart)
    std Z+6, yl
    ldi yh,high(stackstart)
    std Z+7, yh

    ; allocate space for User Area
    .set here = here + SYSUSERSIZE + APPUSERSIZE
    ; load Forth IP with starting word
    ldi XL, low(PFA_COLD)
    ldi XH, high(PFA_COLD)
    ; its a far jump...
    jmp_ DO_NEXT

.include "drivers/generic-isr.asm"
; lower part of the dictionary
.set VE_HEAD = $0000
.set VE_ENVHEAD = $0000

.include "dict_appl.inc"


;
;  The following code lives in the high (NRWW) flash area.
;
;  This test version of asmforth.asm puts a very small bootloader
;  at the start of high flash.  If the device's fuse is set to enable
;  the bootloader, control will reach this location following reset.
;

.set lowflashlast = pc

.org amforth_interpreter

.EQU PIN_BOOTSEL = PIND			; port for reading the boot selector line
.EQU BIT_BOOTSEL = 7			; bit on the boot selector port for selection

.EQU PORT_BOOTENABLE = PORTB	; port for enabling the boot serial eeprom
.EQU DDR_BOOTENABLE = DDRB		; DDR for enabling the boot serial eeprom
.EQU BIT_BOOTENABLE = 2			; bit on the serial eeprom enable port

.EQU DDR_SPI = DDRB
.EQU SCK = 5					; port B bit for SCK
.EQU MOSI = 3					; port B bit for MOSI

.EQU SEE25256_READOP = 3

.EQU SEE25256_VALID = 0x5a




;
;  Entry following reset
;
	clr		temp0						; need to clear SPE bit to free SS (PB2)
	out		SPCR, temp0					; update SPI control reg

	ldi		temp0, (1<<BIT_BOOTENABLE)	; mask for boot-enable line
	out 	PORT_BOOTENABLE, temp0		; force line high
	out 	DDR_BOOTENABLE, temp0		; now make pin an output

	sbic 	PIN_BOOTSEL, BIT_BOOTSEL	; if boot-select line is high...
	jmp		BootExit					; done, start the Forth kernel

    ldi 	temp0, low(rstackstart)		; set up the system stack pointer
    out_ 	SPL, temp0
    ldi 	temp0, high(rstackstart)
    out_	SPH, temp0

	in		temp0, DDR_SPI				; get current SPI port config
	ori 	temp0, (1<<MOSI)|(1<<SCK)	; MOSI and SCK must be outputs
	out 	DDR_SPI, temp0				; set SPI port properly

	ldi 	temp0, (1<<SPE)|(1<<MSTR)|(1<<SPR0)	; enable SPI, Master, set clock rate fck/16
	out 	SPCR, temp0

	in		temp0, PORT_BOOTENABLE		; get latest contents of chip-select port
	andi	temp0, ~(1<<BIT_BOOTENABLE)	; make sure chip-select is low
	out		PORT_BOOTENABLE, temp0		; enable serial EEPROM select (active low)

	ldi		temp0, SEE25256_READOP		; need to read data from serial EEPROM
	call	SPI_MstrXchg				; send the read command

	clr		temp0						; start read at address 0
	rcall	SPI_MstrXchg				; send MSB of addr
	rcall	SPI_MstrXchg				; send LSB of addr

	rcall	SPI_MstrXchg				; dummy write, we only want the response
	cpi		temp1, SEE25256_VALID		; test the byte we got back
	brne	FinishedLoading				; not valid image, what else can we do?

;
;  Copy data from serial EEPROM to internal EEPROM.
;
;  The following code assumes the serial EEPROM contains the following
;  information:
;
;  Byte 0:		VALID flag
;  Byte 1:  	number of EEPROM bytes (MSB)
;  Byte 2:  	number of EEPROM bytes (LSB)
;  Bytes 3-->n:	bytes to write to internal EEPROM
;

	rcall	SPI_MstrXchg				; get MSB of EEPROM data length
	mov		tosh, temp1					; save in TOS reg
	rcall	SPI_MstrXchg				; get LSB of EEPROM data length
	mov		tosl, temp1					; save in TOS reg
	clr		YL							; start at EEPROM address 0
	clr		YH

EELoad:
	cpi		tosl, 0						; done if no bytes left to load
	brne	EELoad1						; branch if still more to do
	cpi		tosh, 0						; check both bytes
	breq	EELoadX						; branch if all bytes are read/written
EELoad1:
	rcall	SPI_MstrXchg				; read next byte from serial EEPROM
	mov		temp0, temp1				; set up the argument
	rcall	EEWrite						; write byte to internal EEPROM
	adiw	Y, 1						; point to next internal address
	sbiw	tosl, 1						; count this byte
	rjmp	EELoad						; do another byte

EELoadX:

;
;  Copy data from serial EEPROM to flash.
;
;  The following code assumes the serial EEPROM contains the following
;  information:
;
;  Byte n+1:		number of flash bytes (MSB)
;  Byte n+2:		number of flash bytes (LSB)
;  Bytes n+3-->k	data to write to flash
;
;  WARNING!  As written, this code assumes an even number of bytes will
;  be written to flash.  It will exit if the remaining byte count goes
;  negative, but the best protection is always use an even number of
;  bytes.
;

	rcall	SPI_MstrXchg				; get MSB of flash data length
	mov		tosh, temp1					; save in A
	rcall	SPI_MstrXchg				; get LSB of flash data length
	mov		tosl, temp1					; save in A
	clr		YL							; start at flash address 0
	clr		YH

FlashLoad:
	cpi		tosh, 0xff					; protect against an odd number of bytes
	breq	FlashLoadX					; this catches wrap to 0xffff
	cpi		tosl, 0						; done if no bytes left to load
	brne	FlashLoad1					; branch if still more to do
	cpi		tosh, 0						; check both bytes
	breq	FlashLoadX					; branch if all bytes are read/written
FlashLoad1:
	rcall	SPI_MstrXchg				; read LSB of next cell from serial EEPROM
	mov		tosl, temp1					; set up the argument
	call	SPI_MstrXchg				; read MSB of next cell from serial EEPROM
	mov		tosh, temp1					; set up the argument
	rcall	FlashWrite					; write two bytes to flash
	adiw	Y, 2						; point to next internal WORD address
	sbiw	tosl, 2						; count this word
	rjmp	FlashLoad					; do another word

FlashLoadX:
		
FinishedLoading:
	ldi	Xl, (1<<BIT_BOOTENABLE)			; done with serial EEPROM, need to disable it
	out	PORT_BOOTENABLE, XL				; raise the chip-select line

BootExit:
	jmp_			$0000


;
;  EERead      read byte from EEPROM; address is in Y, byte returned in temp0
;
EERead:
	in		temp0, EECR					; make sure EEPROM isn't busy
	andi	temp0, ~(1<<EEPE)			; leave only status bit
	brne	EERead						; loop until OK to read

	out		EEARL, YL					; set the address to read
	out		EEARH, YH

	in		temp0, EECR					; get current command reg
	ori		temp0, (1<<EERE)			; mark a read op
	out		EECR, temp0					; start the read

	ldi		temp0, 0					; need to leave EEPROM addr at 0
	out		EEARL, temp0
	out		EEARH, temp0

	in		temp0, EEDR					; now fetch the data byte we read
	ret


;
;  EEWrite      write byte in temp0 to EEPROM at address in Y
;
;  This code assumes interrupts are disabled upon entry.  This code does
;  not disable interrupts during writes, nor does it modify the interrupt
;  enable flags.
;

EEWrite:
	push	temp1						; need a scratch reg

EEWrite1:
	mov		temp1, temp0				; save a copy of the data to write
	rcall	EERead						; get the value already at this addr
	cp		temp1, temp0				; is the value we want already there?
	breq	EEWriteX					; if so, done already

	out		EEDR, temp0					; EE addr is OK, now set EE data
	in		temp1, EECR					; get EE cmd/status reg
	ori		temp1, (1<<EEMPE)			; set flag to enable writes
	out		EECR, temp1					; send the cmd
	ori		temp1, (1<<EEPE)			; set flag to start write
	out		EECR, temp1					; send the cmd
	rjmp	EEWrite1					; now go see if the write worked

EEWriteX:
	pop		temp1						; ready to leave
	ret


;
;  FlashWrite      write 16-bit value in tosl/tosh to flash at addr in Y
;
;  For simplicity, this routine sets up registers as expected by the amforth
;  internal routine DO_ISTORE_atmega, then invokes that routine to do the write.
;
;  DO_ISTORE_atmega wants the following setup:
;		Addr in flash to write in temp2/temp3,
;		Data to write to flash in tosl/tosh AND temp4/temp5
;
;  DO_ISTORE_atmega trashs all temp registers.  Save them if you need them!
;
FlashWrite:
	push	YL							; save the critical registers
	push	YH
	push	XL
	push	XH
	movw	temp2, YL					; need address in flash in temp2/temp3
	movw	temp4, tosl				; need word to write in tosl/tosh AND temp4/temp5
	rcall	DO_ISTORE_atmega			; do the flash write
	pop		XH							; restore the regs
	pop		XL
	pop		YH
	pop		YL
	ret






;
;  SPI_MstrXchg      send byte in temp0 to SPI, return slave response in temp1
;
SPI_MstrXchg:
	out 	SPDR, temp0

WaitXchg:
	in 		temp0, SPSR
	sbrs 	temp0, SPIF
	rjmp 	WaitXchg

	in		temp0, SPDR
	ret




; the inner interpreter.
DO_DODOES:
    savetos
    movw tosl, wl
    adiw tosl, 1
    ; the following takes the address from a real uC-call
.if (pclen==3)
    pop wh ; some 128K Flash devices use 3 cells for call/ret
.endif
    pop wh
    pop wl

    push XH
    push XL
    movw XL, wl
    rjmp DO_NEXT

DO_COLON:
    push XH
    push XL          ; PUSH IP
    movw XL, wl
    adiw xl, 1
DO_NEXT:
    brts DO_INTERRUPT
    movw zl, XL        ; READ IP
    readflashcell wl, wh
    adiw XL, 1        ; INC IP

DO_EXECUTE:
    movw zl, wl
    readflashcell temp0,temp1
    movw zl, temp0
    ijmp

DO_INTERRUPT:
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

.include "dict_appl_core.inc"

.set flashlast = pc
.if (pc>FLASHEND)
  .error "*** Flash size exceeded, please edit your dict_appl_core file to use less space! Aborting."
.endif
  
.eseg
    .dw -1           ; EEPROM Address 0 should not be used
EE_DP:
    .dw lowflashlast ; DP
EE_HERE:
    .dw here         ; HERE
EE_EDP:
    .dw edp          ; EDP
EE_TURNKEY:
    .dw XT_APPLTURNKEY  ; TURNKEY
EE_ISTORE:
    .dw XT_DO_ISTORE  ; Store a cell into flash

; calculate baud rate error
.equ UBRR_VAL   = ((F_CPU+BAUD*8)/(BAUD*16)-1)  ; smart round
.equ BAUD_REAL  = (F_CPU/(16*(UBRR_VAL+1)))     ; effective baud rate
.equ BAUD_ERROR = ((BAUD_REAL*1000)/BAUD-1000)  ; error in pro mille

.if ((BAUD_ERROR>10) || (BAUD_ERROR<-10))       ; accept +/-10 error (pro mille)
  .error "Serial line cannot be set up properly (systematic baud error too high)"
.endif

EE_UBRRVAL:
    .dw UBRR_VAL     ; BAUDRATE
EE_ENVIRONMENT:
    .dw VE_ENVHEAD   ; environmental queries
EE_WL_FORTH:
    .dw EE_FORTHWORDLIST; forth-wordlist
EE_CURRENT:
    .dw EE_FORTHWORDLIST
EE_FORTHWORDLIST:
    .dw VE_HEAD      ; pre-defined (compiled in) wordlist
EE_ORDERLIST: ; list of wordlist id
    .dw EE_FORTHWORDLIST      ; get/set-order
    .dw -1
    .dw -1
    .dw -1
    .dw -1
    .dw -1
    .dw -1
    .dw -1
    .dw -1 ; NUMWORDLISTS + 1 entry, this entry has to be -1
; default user area
EE_INITUSER:
    .dw 0  ; USER_STATE
    .dw 0  ; USER_FOLLOWER
    .dw rstackstart  ; USER_RP
    .dw stackstart   ; USER_SP0
    .dw stackstart   ; USER_SP
    
    .dw 0  ; USER_HANDLER
    .dw 10 ; USER_BASE
    
    .dw XT_TX  ; USER_EMIT
    .dw XT_TXQ ; USER_EMITQ
    .dw XT_RX  ; USER_KEY
    .dw XT_RXQ ; USER_KEYQ
    .dw XT_NOOP ; USER_SKEY

; 1st free address in EEPROM.
edp:
.cseg
