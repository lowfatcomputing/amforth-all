; Settings for the eval board with Atmega8 & 8 MHz
.include "macros.asm"

.equ dict_appl=1

; cpu clock in hertz
.equ cpu_frequency = 12000000
; baud rate of terminal
.equ baud_rate = 9600

; size of return stack in bytes
.equ rstacksize = 80

.include "devices/atmega644.asm"

  .set heap = ramstart
  .set VE_HEAD = $0000

.org codestart
device_init:
    ; just a dummy
    ret

.include "amforth.asm"
