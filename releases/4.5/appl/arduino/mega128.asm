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
.equ F_CPU = 16000000

; initial baud rate of terminal
.include "drivers/usart_0.asm"
.equ BAUD = 9600
.equ USART_B_VALUE = (1<<TXEN0) | (1<<RXEN0) | (1<<RXCIE0)
.equ USART_C_VALUE = (3<<UCSZ00)

.equ TIBSIZE  = $64    ; ANS94 needs at least 80 characters per line
.equ APPUSERSIZE = 10  ; size of application specific user area in bytes

; addresses of various data segments
.set rstackstart = RAMEND      ; start address of return stack, grows downward
.set stackstart  = RAMEND - 80 ; start address of data stack, grows downward
.equ amforth_interpreter = max_dict_addr ; the same value as NRWW_START_ADDR
; change only if you know what to you do
.equ NUMWORDLISTS = 8 ; number of word lists in the searh order, at least 8

.set WANT_TIMER_COUNTER_0 = 1
.set WANT_SPI = 1
.set WANT_PORTA = 1
.set WANT_PORTB = 1
.set WANT_PORTC = 1
.set WANT_PORTD = 1
.set WANT_PORTJ = 1
.set WANT_AD_CONVERTER = 1
; include the whole source tree.
.include "amforth.asm"
