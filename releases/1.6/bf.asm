; Settings for the avr butterfly demo board

; cpu clock in hertz
.equ cpu_frequency = 8000000
; baud rate of terminal
.equ baud_rate = 9600

.include "devices/atmega169.asm"

  .set heap = ramstart
  .set VE_HEAD = $0000

device_init:
    ; just a dummy, for now
    ret

.include "amforth.asm"

    