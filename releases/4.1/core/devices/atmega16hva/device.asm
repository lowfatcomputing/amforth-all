; Partname:  ATmega16HVA
; Built using part description XML file version 38
; generated automatically, do not edit

.nolist
	.include "m16HVAdef.inc"
.list

.equ ramstart =  $100
.equ max_dict_addr = 0 
.equ CELLSIZE = 2
.macro jmp_
	jmp @0
.endmacro
.macro call_
	call @0
.endmacro
.macro readflashcell
	lsl zl
	rol zh
	lpm @0, Z+
	lpm @1, Z+
.endmacro
.macro writeflashcell
	lsl zl
	rol zh
.endmacro

; the following definitions are shortcuts for the respective forth source segments if set to 1
.set WANT_AD_CONVERTER = 0
.set WANT_BANDGAP = 0
.set WANT_BATTERY_PROTECTION = 0
.set WANT_BOOT_LOAD = 0
.set WANT_COULOMB_COUNTER = 0
.set WANT_CPU = 0
.set WANT_EEPROM = 0
.set WANT_EXTERNAL_INTERRUPT = 0
.set WANT_FET = 0
.set WANT_PORTA = 0
.set WANT_PORTB = 0
.set WANT_PORTC = 0
.set WANT_SPI = 0
.set WANT_TIMER_COUNTER_0 = 0
.set WANT_TIMER_COUNTER_1 = 0
.set WANT_VOLTAGE_REGULATOR = 0
.set WANT_WATCHDOG = 0


.ifndef SPMEN
 .equ SPMEN = SELFPRGEN
.endif

.ifndef SPMCSR
 .equ SPMCSR = SPMCR
.endif

.ifndef EEPE
 .equ EEPE = EEWE
.endif

.ifndef EEMPE
 .equ EEMPE = EEMWE
.endif
.equ intvecsize = 2 ; please verify; flash size: 16384 bytes
.equ pclen = 2 ; please verify
.overlap
.equ INTVECTORS = 21
.org $0002
	 rcall isr ; Battery Protection Interrupt
.org $0004
	 rcall isr ; Voltage regulator monitor interrupt
.org $0006
	 rcall isr ; External Interrupt Request 0
.org $0008
	 rcall isr ; External Interrupt Request 1
.org $000A
	 rcall isr ; External Interrupt Request 2
.org $000C
	 rcall isr ; Watchdog Timeout Interrupt
.org $000E
	 rcall isr ; Timer 1 Input capture
.org $0010
	 rcall isr ; Timer 1 Compare Match A
.org $0012
	 rcall isr ; Timer 1 Compare Match B
.org $0014
	 rcall isr ; Timer 1 overflow
.org $0016
	 rcall isr ; Timer 0 Input Capture
.org $0018
	 rcall isr ; Timer 0 Comapre Match A
.org $001A
	 rcall isr ; Timer 0 Compare Match B
.org $001C
	 rcall isr ; Timer 0 Overflow
.org $001E
	 rcall isr ; SPI Serial transfer complete
.org $0020
	 rcall isr ; Voltage ADC Conversion Complete
.org $0022
	 rcall isr ; Coulomb Counter ADC Conversion Complete
.org $0024
	 rcall isr ; Coloumb Counter ADC Regular Current
.org $0026
	 rcall isr ; Coloumb Counter ADC Accumulator
.org $028
	 rcall isr ; EEPROM Ready
.nooverlap
mcustring:
	.dw 11
	.db "ATmega16HVA",0
.set codestart=pc
