;
;  myproj.asm      a simple AVRStudio4 assembly-language project for amforth
;
;
; The order of the entries (esp the include order) must not be
; changed since it is very important that the settings are in the
; right order
;
; first is to include the macros from the amforth
; directory
	.include "macros.asm"

; include the amforth device definition file. These
; files include the *def.inc from atmel internally.
	.include "device.asm"

; amforth needs two essential parameters
; cpu clock in hertz, 1MHz is factory default
	.equ F_CPU = 8000000

; terminal settings
	.set WANT_ISR_RX = 1 ; interrupt driven receive
	.set WANT_ISR_TX = 0 ; send slowly but with less code space

; initial baud rate of terminal
	.include "drivers/usart_0.asm"
	.equ BAUD = 38400

	.if WANT_ISR_RX == 1
  	.set USART_B_VALUE = (1<<TXEN0) | (1<<RXEN0)| (1<<RXCIE0)
	.else
  	.set USART_B_VALUE = (1<<TXEN0) | (1<<RXEN0)
	.endif

	.equ USART_C_VALUE = (3<<UCSZ00)


;
;  Customize Forth access to MCU ports and registers.  The following
;  WANT_ equates are found in the device.asm file for your target
;  MCU.
;
	.set	WANT_SPI = 1				; create the SPI words
	.set	WANT_PORTD = 1				; create port D words
	.set	WANT_PORTC = 1				; create port C words
	.set	WANT_PORTB = 1				; create port B words
	.set	WANT_AD_CONVERTER = 1		; create ADC words
	.set 	WANT_TIMER_COUNTER_0 = 1	; create TC0 words
	.set 	WANT_TIMER_COUNTER_1 = 1	; create TC1 words
	.set 	WANT_TIMER_COUNTER_2 = 1	; create TC2 words
	.set 	WANT_TWI = 1				; create I2C words
	.set	WANT_CPU = 1				; create MCU registers


	.equ TIBSIZE  = $64    ; ANS94 needs at least 80 characters per line
	.equ APPUSERSIZE = 10  ; size of application specific user area in bytes

; addresses of various data segments
	.set here = ramstart           ; start address of HERE, grows upward
	.set rstackstart = RAMEND      ; start address of return stack, grows downward
	.set stackstart  = RAMEND - 80 ; start address of data stack, grows downward
	.equ amforth_interpreter = max_dict_addr ; the same value as NRWW_START_ADDR
; change only if you know what to you do
	.equ NUMWORDLISTS = 8 ; number of word lists in the searh order, at least 8

	.equ want_fun = 1 ; in case of an error out print an additional line with an caret indicating the error position

; include the whole source tree.
	.include "custom/amforth_karl.asm"		; test version of amforth.asm



