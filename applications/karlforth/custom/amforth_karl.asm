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



.EQU SEE_READOP = 3
.EQU SEE_VALID_FLAG = $5a


.EQU		PAGESIZEB = PAGESIZE*2 ;PAGESIZEB is page size in BYTES, not words


;
;  What a f***ing kludge!  The '328P self-program enable bit name is SELFPRGEN;
;  the same bit on the '644P is named SPMEN.  Eventually, I need a translation
;  file that adjusts all of these different names to a single, standard name
;  I can use in my source files.  Or, Atmel could just use the same name for
;  the same functional bit across all MCUs.  (Guess which is gonna happen first...)
;
.if !defined(SELFPRGEN)
.set  SELFPRGEN = SPMEN
.endif



;
;  Entry following reset
;
	clr		temp0						; need to clear SPE bit to free SS (PB2)
	out		SPCR, temp0					; update SPI control reg

	ldi		temp0, (1<<SEE_CS_A_BIT)	; mask for device select line
	out 	SEE_CS_A_PORT, temp0		; force line high
	out 	SEE_CS_A_DDR, temp0			; now make pin an output

	sbic 	PIN_BOOTSEL, BIT_BOOTSEL	; if boot-select line is high...
	jmp		BootExit					; done, start the Forth kernel

    ldi 	temp0, low(rstackstart)		; set up the system stack pointer
    out_ 	SPL, temp0
    ldi 	temp0, high(rstackstart)
    out_	SPH, temp0

debugloop:
	in		temp0, DDR_SPI				; get current SPI port config
	ori 	temp0, (1<<MOSI)|(1<<SCK)	; MOSI and SCK must be outputs
	out 	DDR_SPI, temp0				; set SPI port properly

	ldi 	temp0, (1<<SPE)|(1<<MSTR)|(1<<SPR0)	; enable SPI, Master, set clock rate fck/16
	out 	SPCR, temp0

	in		temp0, SEE_CS_A_PORT		; get latest contents of chip-select port
	andi	temp0, ~(1<<SEE_CS_A_BIT)	; make sure chip-select is low
	out		SEE_CS_A_PORT, temp0		; enable serial EEPROM select (active low)

	ldi		temp0, SEE_READOP			; need to read data from serial EEPROM
	call	SPI_MstrXchg				; send the read command

	clr		temp0						; start read at address 0

	.if		SEE_ADDR_BYTES == 3			; if using 3-byte addresses...
	rcall	SPI_MstrXchg				; always send 0 as MSB
	.endif

	rcall	SPI_MstrXchg				; send MSB of addr
	rcall	SPI_MstrXchg				; send LSB of addr

	rcall	SPI_MstrXchg				; dummy write, we only want the response

;; debug
;	in		temp0, SEE_CS_A_PORT		; get latest contents of chip-select port
;	ori		temp0, (1<<SEE_CS_A_BIT)	; make sure chip-select is high
;	out		SEE_CS_A_PORT, temp0		; disable serial EEPROM select (active low)
;	rjmp	debugloop					; repeat so I can use a scope
;; end of debug


	cpi		temp1, SEE_VALID_FLAG		; test the byte we got back
	brne	FinishedLoading				; not valid image, what else can we do?
	rcall	SPI_MstrXchg				; read flags (not used)

;
;  Copy data from serial EEPROM to internal EEPROM.
;
;  The following code assumes the serial EEPROM contains the following
;  information:
;
;  Byte 0:		VALID flag
;  Byte 1:      flags (not used)
;  Byte 2:  	number of EEPROM bytes (MSB)
;  Byte 3:  	number of EEPROM bytes (LSB)
;  Bytes 4-->n:	bytes to write to internal EEPROM
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
	adiw	YH:YL, 1					; point to next internal address
	sbiw	tosh:tosl, 1				; count this byte
	rjmp	EELoad						; do another byte

EELoadX:
	ldi		temp0, 0					; need to leave EEPROM addr at 0
	out		EEARL, temp0
	out		EEARH, temp0

;; debug
;	jmp		FinishedLoading

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
	clr		ZL							; start at flash address 0
	clr		ZH
	clr		wl							; count of 0 forces a page erase
	clr		wh

FlashLoad:
	cpi		tosh, 0xff					; protect against an odd number of bytes
	breq	FlashLoadX					; this catches wrap to 0xffff
	cpi		tosl, 0						; done if no bytes left to load
	brne	FlashLoad1					; branch if still more to do
	cpi		tosh, 0						; check both bytes
	breq	FlashLoadX					; branch if all bytes are read/written
FlashLoad1:
	rcall	SPI_MstrXchg				; read MSB of next cell from serial EEPROM
	mov		r1, temp1					; set up the argument
	call	SPI_MstrXchg				; read LSB of next cell from serial EEPROM
	mov		r0, temp1					; set up the argument
	rcall	FlashWrite					; write two bytes to flash
	sbiw	tosh:tosl, 2				; count this word
	rjmp	FlashLoad					; do another word

FlashLoadX:
	cpi		wl, 0						; need to check for incomplete flash page
	breq	FinishedLoading				; byte count of 0 means we ended on a page boundary, done
	rcall	ForceFlashWrite				; force-write the last page
		
FinishedLoading:
	ldi		XL, (1<<SEE_CS_A_BIT)		; done with serial EEPROM, need to disable it
	out		SEE_CS_A_PORT, XL			; raise the chip-select line

BootExit:
	jmp_			$0000


;
;  EERead      read byte from EEPROM; address is in Y, byte returned in temp0
;
EERead:
	sbic	EECR, EEPE					; loop until previous write, if any, finishes
	rjmp	EERead
	out		EEARL, YL					; set the address to read
	out		EEARH, YH
	sbi		EECR,EERE					; do the read
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
	sbic	EECR, EEPE			; spin until any previous write finishes
	rjmp	EEWrite

	out		EEARH, YH
	out		EEARL, YL			; set the address to read
	out		EEDR, temp0			; EE addr is OK, now set EE data

	sbi		EECR, EEMPE			; enable write
	sbi		EECR, EEPE			; do the write

	ret


;
;  FlashWrite      write 16-bit value in r1/r0 to flash at addr in ZH:ZL
;
;  This routine borrows heavily from the example code in the Atmel
;  docs for the ATmega328P; see the bootloader section.
;
;  This routine has an alternate entry point, ForceFlashWrite.  This
;  entry point is used when the entire image in EEPROM has been processed
;  but there is an unfinished flash page left to write.
;
FlashWrite:
	cpi		wl, 0				; if called at start of page, need to erase page
	brne	WriteToPage			; branch if no need to erase page
	cpi		wh, 0				; must check both bytes
	brne	WriteToPage			; branch if no need to erase page

	ldi		temp6, (1<<PGERS) | (1<<SELFPRGEN)	; erase page addressed in ZH:ZL
	rcall	Do_spm

	ldi		temp6, (1<<RWWSRE) | (1<<SELFPRGEN)	; need to reenable RWW section
	rcall	Do_spm

	ldi		wl, low(PAGESIZEB)	; reload counter for number of bytes in a page
	ldi		wh, high(PAGESIZEB)

WriteToPage:
	ldi		temp6, (1<<SELFPRGEN)	; write word in R1:R0 to page buffer
	rcall	Do_spm

	adiw	ZH:ZL, 2			; move to next flash word addr
	subi	wl, 2				; count the two bytes we just stored
	sbci	wh, 0
	cpi		wl, 0				; if finished storing a full page, need to write to flash
	brne	CheckRWW			; branch if not done with page

;
;  Need to write page buffer to flash memory
;
	push	ZL					; need to save the flash pointer
	push	ZH
	subi	ZL, low(PAGESIZEB)	; back up to start of current page
	sbci	ZH, high(PAGESIZEB)	; 
	rjmp	ForceFlashWrite_1

;
;  Alternate entry point.  Enter at this address in order to
;  force a write of a final, incomplete flash page.
;
ForceFlashWrite:
	push	ZL
	push	ZH

ForceFlashWrite_1:
	ldi		temp6, (1<<PGWRT) | (1<<SELFPRGEN)
	rcall	Do_spm
	pop 	ZH
	pop		ZL

;
;  This code loops until the RWW section is stable and can be read.
;
CheckRWW:
	in		temp1, SPMCSR
	sbrs	temp1, RWWSB		; If RWWSB is set, the RWW section is not ready yet
	rjmp	FlashExit
; re-enable the RWW section
	ldi		temp6, (1<<RWWSRE) | (1<<SELFPRGEN)
	rcall	Do_spm
	rjmp	CheckRWW

FlashExit:
	ret



Do_spm:
	in		temp2, SPMCSR		; loop until any pending SPM operation finishes
	sbrc	temp2, SELFPRGEN
	rjmp	Do_spm

	in		temp2, SREG			; save current interrupt state (not really necessary here)
	cli							; make sure no interrupts

Wait_ee:
	sbic	EECR, EEPE			; loop until any pending EE write finishes
	rjmp	Wait_ee

	out		SPMCSR, temp6		; invoke requested action
	spm

	out		SREG, temp2			; restore SREG (to enable interrupts if originally enabled)
	ret




;
;  SPI_MstrXchg      send byte in temp0 to SPI, return slave response in temp1
;
;  All registers are preserved.
;
SPI_MstrXchg:
	push	temp0
	out 	SPDR, temp0

WaitXchg:
	in 		temp1, SPSR
	sbrs 	temp1, SPIF
	rjmp 	WaitXchg

	in		temp1, SPDR
	pop		temp0
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
    .dw -1 					; NUMWORDLISTS + 1 entry, this entry has to be -1

; default user area
EE_INITUSER:
    .dw 0  					; USER_STATE
    .dw 0  					; USER_FOLLOWER
    .dw rstackstart  		; USER_RP
    .dw stackstart   		; USER_SP0
    .dw stackstart   		; USER_SP
    
    .dw 0  					; USER_HANDLER
    .dw 10 					; USER_BASE
    
    .dw XT_TX  				; USER_EMIT
    .dw XT_TXQ 				; USER_EMITQ
    .dw XT_RX  				; USER_KEY
    .dw XT_RXQ 				; USER_KEYQ
    .dw XT_NOOP 			; USER_SKEY

	.dw 0					; USER_BLK			added by KEL 21 Oct 2010, 0 uses console for refill
	.dw 0					; USER_CURRBLK		added by KEL 24 Oct 2010
	.dw 0					; USER_BLKOFFSET	added by KEL 24 Oct 2010
	.dw 0					; USER_BUFFER		added by KEL 22 Oct 2010
;
;  The following 1022 bytes in RAM will hold the buffer used for editing
;


; 1st free address in EEPROM.
edp:
.cseg
