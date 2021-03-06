; Settings for the eval board with Atmega32 & 16 MHz
.include "macros.asm"
.include "device.asm"

  .equ TIBSIZE  = $64    ; 80 characters is one line...
  .equ APPUSERSIZE = 10  ; size of user area

; cpu clock in hertz
.equ F_CPU = 16000000
; baud rate of terminal
.include "drivers/usart.asm"
.equ USART_B_VALUE = (1<<TXEN) | (1<<RXEN) | (1<<RXCIE)
.equ USART_C_VALUE = (3<<UCSZ0)
.equ BAUD = 9600

; size of return stack in bytes
.set rstackstart = RAMEND
.set stackstart  = RAMEND - 80
.set amforth_interpreter = max_dict_addr

.set NUMWORDLISTS = 8
.include "amforth.asm"
