; Settings for the eval board with Atmega8 & 8 MHz
.include "macros.asm"
.include "devices/atmega328p.asm"

  .equ HLDSIZE  = $10 ; 16 bit cellsize with binary representation
  .equ TIBSIZE  = $64 ; 80 characters is one line...
  .equ CELLSIZE = 2   ;
  .equ APPUSERSIZE = 0  ; size of user area

; cpu clock in hertz
.equ F_CPU = 12000000
; baud rate of terminal
.equ BAUD = 9600
.equ USART_B_VALUE = (1<<TXEN0) | (1<<RXEN0) ; | (1<<RXCIE0)
.equ USART_C_VALUE = (1<<UCSZ01) | ( 1<<UCSZ00)

.set heap = ramstart
.set rstackstart = RAMEND
.set stackstart  = RAMEND - 80
.set amforth_interpreter = max_dict_addr

.set NUMWORDLISTS = 8
.equ want_fun = 1
.include "amforth.asm"
