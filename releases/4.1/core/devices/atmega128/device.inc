; Partname:  ATmega128
; Built using part description XML file version 265
; generated automatically, no not edit

; ********
.if WANT_AD_CONVERTER == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; ADC Data Register High Byte
VE_ADCH:
	.dw $ff04
	.db "ADCH"
	.dw VE_HEAD
	.set VE_HEAD=VE_ADCH
XT_ADCH:
	.dw PFA_DOVARIABLE
PFA_ADCH:
	.dw $25
; ( -- addr ) System Constant
; R( -- )
; ADC Data Register Low Byte
VE_ADCL:
	.dw $ff04
	.db "ADCL"
	.dw VE_HEAD
	.set VE_HEAD=VE_ADCL
XT_ADCL:
	.dw PFA_DOVARIABLE
PFA_ADCL:
	.dw $24
; ( -- addr ) System Constant
; R( -- )
; The ADC Control and Status register
VE_ADCSRA:
	.dw $ff06
	.db "ADCSRA"
	.dw VE_HEAD
	.set VE_HEAD=VE_ADCSRA
XT_ADCSRA:
	.dw PFA_DOVARIABLE
PFA_ADCSRA:
	.dw $26
; ( -- addr ) System Constant
; R( -- )
; The ADC multiplexer Selection Register
VE_ADMUX:
	.dw $ff05
	.db "ADMUX",0
	.dw VE_HEAD
	.set VE_HEAD=VE_ADMUX
XT_ADMUX:
	.dw PFA_DOVARIABLE
PFA_ADMUX:
	.dw $27

.endif

; ********
.if WANT_ANALOG_COMPARATOR == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Analog Comparator Control And Status Register
VE_ACSR:
	.dw $ff04
	.db "ACSR"
	.dw VE_HEAD
	.set VE_HEAD=VE_ACSR
XT_ACSR:
	.dw PFA_DOVARIABLE
PFA_ACSR:
	.dw $28
; ( -- addr ) System Constant
; R( -- )
; Special Function IO Register
VE_SFIOR:
	.dw $ff05
	.db "SFIOR",0
	.dw VE_HEAD
	.set VE_HEAD=VE_SFIOR
XT_SFIOR:
	.dw PFA_DOVARIABLE
PFA_SFIOR:
	.dw $40

.endif

; ********
.if WANT_BOOT_LOAD == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Store Program Memory Control Register
VE_SPMCSR:
	.dw $ff06
	.db "SPMCSR"
	.dw VE_HEAD
	.set VE_HEAD=VE_SPMCSR
XT_SPMCSR:
	.dw PFA_DOVARIABLE
PFA_SPMCSR:
	.dw $68

.endif

; ********
.if WANT_CPU == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; MCU Control Register
VE_MCUCR:
	.dw $ff05
	.db "MCUCR",0
	.dw VE_HEAD
	.set VE_HEAD=VE_MCUCR
XT_MCUCR:
	.dw PFA_DOVARIABLE
PFA_MCUCR:
	.dw $55
; ( -- addr ) System Constant
; R( -- )
; MCU Control And Status Register
VE_MCUCSR:
	.dw $ff06
	.db "MCUCSR"
	.dw VE_HEAD
	.set VE_HEAD=VE_MCUCSR
XT_MCUCSR:
	.dw PFA_DOVARIABLE
PFA_MCUCSR:
	.dw $54
; ( -- addr ) System Constant
; R( -- )
; Oscillator Calibration Value
VE_OSCCAL:
	.dw $ff06
	.db "OSCCAL"
	.dw VE_HEAD
	.set VE_HEAD=VE_OSCCAL
XT_OSCCAL:
	.dw PFA_DOVARIABLE
PFA_OSCCAL:
	.dw $6F
; ( -- addr ) System Constant
; R( -- )
; RAM Page Z Select Register
VE_RAMPZ:
	.dw $ff05
	.db "RAMPZ",0
	.dw VE_HEAD
	.set VE_HEAD=VE_RAMPZ
XT_RAMPZ:
	.dw PFA_DOVARIABLE
PFA_RAMPZ:
	.dw $5B
; ( -- addr ) System Constant
; R( -- )
; Stack Pointer High
VE_SPH:
	.dw $ff03
	.db "SPH",0
	.dw VE_HEAD
	.set VE_HEAD=VE_SPH
XT_SPH:
	.dw PFA_DOVARIABLE
PFA_SPH:
	.dw $5E
; ( -- addr ) System Constant
; R( -- )
; Stack Pointer Low
VE_SPL:
	.dw $ff03
	.db "SPL",0
	.dw VE_HEAD
	.set VE_HEAD=VE_SPL
XT_SPL:
	.dw PFA_DOVARIABLE
PFA_SPL:
	.dw $5D
; ( -- addr ) System Constant
; R( -- )
; Status Register
VE_SREG:
	.dw $ff04
	.db "SREG"
	.dw VE_HEAD
	.set VE_HEAD=VE_SREG
XT_SREG:
	.dw PFA_DOVARIABLE
PFA_SREG:
	.dw $5F
; ( -- addr ) System Constant
; R( -- )
; XTAL Divide Control Register
VE_XDIV:
	.dw $ff04
	.db "XDIV"
	.dw VE_HEAD
	.set VE_HEAD=VE_XDIV
XT_XDIV:
	.dw PFA_DOVARIABLE
PFA_XDIV:
	.dw $5C
; ( -- addr ) System Constant
; R( -- )
; External Memory Control Register A
VE_XMCRA:
	.dw $ff05
	.db "XMCRA",0
	.dw VE_HEAD
	.set VE_HEAD=VE_XMCRA
XT_XMCRA:
	.dw PFA_DOVARIABLE
PFA_XMCRA:
	.dw $6D
; ( -- addr ) System Constant
; R( -- )
; External Memory Control Register B
VE_XMCRB:
	.dw $ff05
	.db "XMCRB",0
	.dw VE_HEAD
	.set VE_HEAD=VE_XMCRB
XT_XMCRB:
	.dw PFA_DOVARIABLE
PFA_XMCRB:
	.dw $6C

.endif

; ********
.if WANT_EEPROM == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; EEPROM Read/Write Access High Byte
VE_EEARH:
	.dw $ff05
	.db "EEARH",0
	.dw VE_HEAD
	.set VE_HEAD=VE_EEARH
XT_EEARH:
	.dw PFA_DOVARIABLE
PFA_EEARH:
	.dw $3F
; ( -- addr ) System Constant
; R( -- )
; EEPROM Read/Write Access Low Byte
VE_EEARL:
	.dw $ff05
	.db "EEARL",0
	.dw VE_HEAD
	.set VE_HEAD=VE_EEARL
XT_EEARL:
	.dw PFA_DOVARIABLE
PFA_EEARL:
	.dw $3E
; ( -- addr ) System Constant
; R( -- )
; EEPROM Control Register
VE_EECR:
	.dw $ff04
	.db "EECR"
	.dw VE_HEAD
	.set VE_HEAD=VE_EECR
XT_EECR:
	.dw PFA_DOVARIABLE
PFA_EECR:
	.dw $3C
; ( -- addr ) System Constant
; R( -- )
; EEPROM Data Register
VE_EEDR:
	.dw $ff04
	.db "EEDR"
	.dw VE_HEAD
	.set VE_HEAD=VE_EEDR
XT_EEDR:
	.dw PFA_DOVARIABLE
PFA_EEDR:
	.dw $3D

.endif

; ********
.if WANT_EXTERNAL_INTERRUPT == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; External Interrupt Control Register A
VE_EICRA:
	.dw $ff05
	.db "EICRA",0
	.dw VE_HEAD
	.set VE_HEAD=VE_EICRA
XT_EICRA:
	.dw PFA_DOVARIABLE
PFA_EICRA:
	.dw $6A
; ( -- addr ) System Constant
; R( -- )
; External Interrupt Control Register B
VE_EICRB:
	.dw $ff05
	.db "EICRB",0
	.dw VE_HEAD
	.set VE_HEAD=VE_EICRB
XT_EICRB:
	.dw PFA_DOVARIABLE
PFA_EICRB:
	.dw $5A
; ( -- addr ) System Constant
; R( -- )
; External Interrupt Flag Register
VE_EIFR:
	.dw $ff04
	.db "EIFR"
	.dw VE_HEAD
	.set VE_HEAD=VE_EIFR
XT_EIFR:
	.dw PFA_DOVARIABLE
PFA_EIFR:
	.dw $58
; ( -- addr ) System Constant
; R( -- )
; External Interrupt Mask Register
VE_EIMSK:
	.dw $ff05
	.db "EIMSK",0
	.dw VE_HEAD
	.set VE_HEAD=VE_EIMSK
XT_EIMSK:
	.dw PFA_DOVARIABLE
PFA_EIMSK:
	.dw $59

.endif

; ********
.if WANT_JTAG == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; On-Chip Debug Related Register in I/O Memory
VE_OCDR:
	.dw $ff04
	.db "OCDR"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCDR
XT_OCDR:
	.dw PFA_DOVARIABLE
PFA_OCDR:
	.dw $42

.endif

; ********
.if WANT_MISC == 1
; ********

.endif

; ********
.if WANT_PORTA == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Port A Data Direction Register
VE_DDRA:
	.dw $ff04
	.db "DDRA"
	.dw VE_HEAD
	.set VE_HEAD=VE_DDRA
XT_DDRA:
	.dw PFA_DOVARIABLE
PFA_DDRA:
	.dw $3A
; ( -- addr ) System Constant
; R( -- )
; Port A Input Pins
VE_PINA:
	.dw $ff04
	.db "PINA"
	.dw VE_HEAD
	.set VE_HEAD=VE_PINA
XT_PINA:
	.dw PFA_DOVARIABLE
PFA_PINA:
	.dw $39
; ( -- addr ) System Constant
; R( -- )
; Port A Data Register
VE_PORTA:
	.dw $ff05
	.db "PORTA",0
	.dw VE_HEAD
	.set VE_HEAD=VE_PORTA
XT_PORTA:
	.dw PFA_DOVARIABLE
PFA_PORTA:
	.dw $3B

.endif

; ********
.if WANT_PORTB == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Port B Data Direction Register
VE_DDRB:
	.dw $ff04
	.db "DDRB"
	.dw VE_HEAD
	.set VE_HEAD=VE_DDRB
XT_DDRB:
	.dw PFA_DOVARIABLE
PFA_DDRB:
	.dw $37
; ( -- addr ) System Constant
; R( -- )
; Port B Input Pins
VE_PINB:
	.dw $ff04
	.db "PINB"
	.dw VE_HEAD
	.set VE_HEAD=VE_PINB
XT_PINB:
	.dw PFA_DOVARIABLE
PFA_PINB:
	.dw $36
; ( -- addr ) System Constant
; R( -- )
; Port B Data Register
VE_PORTB:
	.dw $ff05
	.db "PORTB",0
	.dw VE_HEAD
	.set VE_HEAD=VE_PORTB
XT_PORTB:
	.dw PFA_DOVARIABLE
PFA_PORTB:
	.dw $38

.endif

; ********
.if WANT_PORTC == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Port C Data Direction Register
VE_DDRC:
	.dw $ff04
	.db "DDRC"
	.dw VE_HEAD
	.set VE_HEAD=VE_DDRC
XT_DDRC:
	.dw PFA_DOVARIABLE
PFA_DDRC:
	.dw $34
; ( -- addr ) System Constant
; R( -- )
; Port C Input Pins
VE_PINC:
	.dw $ff04
	.db "PINC"
	.dw VE_HEAD
	.set VE_HEAD=VE_PINC
XT_PINC:
	.dw PFA_DOVARIABLE
PFA_PINC:
	.dw $33
; ( -- addr ) System Constant
; R( -- )
; Port C Data Register
VE_PORTC:
	.dw $ff05
	.db "PORTC",0
	.dw VE_HEAD
	.set VE_HEAD=VE_PORTC
XT_PORTC:
	.dw PFA_DOVARIABLE
PFA_PORTC:
	.dw $35

.endif

; ********
.if WANT_PORTD == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Port D Data Direction Register
VE_DDRD:
	.dw $ff04
	.db "DDRD"
	.dw VE_HEAD
	.set VE_HEAD=VE_DDRD
XT_DDRD:
	.dw PFA_DOVARIABLE
PFA_DDRD:
	.dw $31
; ( -- addr ) System Constant
; R( -- )
; Port D Input Pins
VE_PIND:
	.dw $ff04
	.db "PIND"
	.dw VE_HEAD
	.set VE_HEAD=VE_PIND
XT_PIND:
	.dw PFA_DOVARIABLE
PFA_PIND:
	.dw $30
; ( -- addr ) System Constant
; R( -- )
; Port D Data Register
VE_PORTD:
	.dw $ff05
	.db "PORTD",0
	.dw VE_HEAD
	.set VE_HEAD=VE_PORTD
XT_PORTD:
	.dw PFA_DOVARIABLE
PFA_PORTD:
	.dw $32

.endif

; ********
.if WANT_PORTE == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Data Direction Register, Port E
VE_DDRE:
	.dw $ff04
	.db "DDRE"
	.dw VE_HEAD
	.set VE_HEAD=VE_DDRE
XT_DDRE:
	.dw PFA_DOVARIABLE
PFA_DDRE:
	.dw $22
; ( -- addr ) System Constant
; R( -- )
; Input Pins, Port E
VE_PINE:
	.dw $ff04
	.db "PINE"
	.dw VE_HEAD
	.set VE_HEAD=VE_PINE
XT_PINE:
	.dw PFA_DOVARIABLE
PFA_PINE:
	.dw $21
; ( -- addr ) System Constant
; R( -- )
; Data Register, Port E
VE_PORTE:
	.dw $ff05
	.db "PORTE",0
	.dw VE_HEAD
	.set VE_HEAD=VE_PORTE
XT_PORTE:
	.dw PFA_DOVARIABLE
PFA_PORTE:
	.dw $23

.endif

; ********
.if WANT_PORTF == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Data Direction Register, Port F
VE_DDRF:
	.dw $ff04
	.db "DDRF"
	.dw VE_HEAD
	.set VE_HEAD=VE_DDRF
XT_DDRF:
	.dw PFA_DOVARIABLE
PFA_DDRF:
	.dw $61
; ( -- addr ) System Constant
; R( -- )
; Input Pins, Port F
VE_PINF:
	.dw $ff04
	.db "PINF"
	.dw VE_HEAD
	.set VE_HEAD=VE_PINF
XT_PINF:
	.dw PFA_DOVARIABLE
PFA_PINF:
	.dw $20
; ( -- addr ) System Constant
; R( -- )
; Data Register, Port F
VE_PORTF:
	.dw $ff05
	.db "PORTF",0
	.dw VE_HEAD
	.set VE_HEAD=VE_PORTF
XT_PORTF:
	.dw PFA_DOVARIABLE
PFA_PORTF:
	.dw $62

.endif

; ********
.if WANT_PORTG == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Data Direction Register, Port G
VE_DDRG:
	.dw $ff04
	.db "DDRG"
	.dw VE_HEAD
	.set VE_HEAD=VE_DDRG
XT_DDRG:
	.dw PFA_DOVARIABLE
PFA_DDRG:
	.dw $64
; ( -- addr ) System Constant
; R( -- )
; Input Pins, Port G
VE_PING:
	.dw $ff04
	.db "PING"
	.dw VE_HEAD
	.set VE_HEAD=VE_PING
XT_PING:
	.dw PFA_DOVARIABLE
PFA_PING:
	.dw $63
; ( -- addr ) System Constant
; R( -- )
; Data Register, Port G
VE_PORTG:
	.dw $ff05
	.db "PORTG",0
	.dw VE_HEAD
	.set VE_HEAD=VE_PORTG
XT_PORTG:
	.dw PFA_DOVARIABLE
PFA_PORTG:
	.dw $65

.endif

; ********
.if WANT_SPI == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; SPI Control Register
VE_SPCR:
	.dw $ff04
	.db "SPCR"
	.dw VE_HEAD
	.set VE_HEAD=VE_SPCR
XT_SPCR:
	.dw PFA_DOVARIABLE
PFA_SPCR:
	.dw $2D
; ( -- addr ) System Constant
; R( -- )
; SPI Data Register
VE_SPDR:
	.dw $ff04
	.db "SPDR"
	.dw VE_HEAD
	.set VE_HEAD=VE_SPDR
XT_SPDR:
	.dw PFA_DOVARIABLE
PFA_SPDR:
	.dw $2F
; ( -- addr ) System Constant
; R( -- )
; SPI Status Register
VE_SPSR:
	.dw $ff04
	.db "SPSR"
	.dw VE_HEAD
	.set VE_HEAD=VE_SPSR
XT_SPSR:
	.dw PFA_DOVARIABLE
PFA_SPSR:
	.dw $2E

.endif

; ********
.if WANT_TIMER_COUNTER_0 == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Asynchronus Status Register
VE_ASSR:
	.dw $ff04
	.db "ASSR"
	.dw VE_HEAD
	.set VE_HEAD=VE_ASSR
XT_ASSR:
	.dw PFA_DOVARIABLE
PFA_ASSR:
	.dw $50
; ( -- addr ) System Constant
; R( -- )
; Output Compare Register
VE_OCR0:
	.dw $ff04
	.db "OCR0"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR0
XT_OCR0:
	.dw PFA_DOVARIABLE
PFA_OCR0:
	.dw $51
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter Control Register
VE_TCCR0:
	.dw $ff05
	.db "TCCR0",0
	.dw VE_HEAD
	.set VE_HEAD=VE_TCCR0
XT_TCCR0:
	.dw PFA_DOVARIABLE
PFA_TCCR0:
	.dw $53
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter Register 
VE_TCNT0:
	.dw $ff05
	.db "TCNT0",0
	.dw VE_HEAD
	.set VE_HEAD=VE_TCNT0
XT_TCNT0:
	.dw PFA_DOVARIABLE
PFA_TCNT0:
	.dw $52
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter Interrupt Flag register
VE_TIFR:
	.dw $ff04
	.db "TIFR"
	.dw VE_HEAD
	.set VE_HEAD=VE_TIFR
XT_TIFR:
	.dw PFA_DOVARIABLE
PFA_TIFR:
	.dw $56
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter Interrupt Mask Register
VE_TIMSK:
	.dw $ff05
	.db "TIMSK",0
	.dw VE_HEAD
	.set VE_HEAD=VE_TIMSK
XT_TIMSK:
	.dw PFA_DOVARIABLE
PFA_TIMSK:
	.dw $57

.endif

; ********
.if WANT_TIMER_COUNTER_1 == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Extended Timer/Counter Interrupt Flag register
VE_ETIFR:
	.dw $ff05
	.db "ETIFR",0
	.dw VE_HEAD
	.set VE_HEAD=VE_ETIFR
XT_ETIFR:
	.dw PFA_DOVARIABLE
PFA_ETIFR:
	.dw $7C
; ( -- addr ) System Constant
; R( -- )
; Extended Timer/Counter Interrupt Mask Register
VE_ETIMSK:
	.dw $ff06
	.db "ETIMSK"
	.dw VE_HEAD
	.set VE_HEAD=VE_ETIMSK
XT_ETIMSK:
	.dw PFA_DOVARIABLE
PFA_ETIMSK:
	.dw $7D
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Input Capture Register High Byte
VE_ICR1H:
	.dw $ff05
	.db "ICR1H",0
	.dw VE_HEAD
	.set VE_HEAD=VE_ICR1H
XT_ICR1H:
	.dw PFA_DOVARIABLE
PFA_ICR1H:
	.dw $47
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Input Capture Register Low Byte
VE_ICR1L:
	.dw $ff05
	.db "ICR1L",0
	.dw VE_HEAD
	.set VE_HEAD=VE_ICR1L
XT_ICR1L:
	.dw PFA_DOVARIABLE
PFA_ICR1L:
	.dw $46
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Output Compare Register High Byte
VE_OCR1AH:
	.dw $ff06
	.db "OCR1AH"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR1AH
XT_OCR1AH:
	.dw PFA_DOVARIABLE
PFA_OCR1AH:
	.dw $4B
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Output Compare Register Low Byte
VE_OCR1AL:
	.dw $ff06
	.db "OCR1AL"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR1AL
XT_OCR1AL:
	.dw PFA_DOVARIABLE
PFA_OCR1AL:
	.dw $4A
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Output Compare Register High Byte
VE_OCR1BH:
	.dw $ff06
	.db "OCR1BH"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR1BH
XT_OCR1BH:
	.dw PFA_DOVARIABLE
PFA_OCR1BH:
	.dw $49
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Output Compare Register Low Byte
VE_OCR1BL:
	.dw $ff06
	.db "OCR1BL"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR1BL
XT_OCR1BL:
	.dw PFA_DOVARIABLE
PFA_OCR1BL:
	.dw $48
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Output Compare Register High Byte
VE_OCR1CH:
	.dw $ff06
	.db "OCR1CH"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR1CH
XT_OCR1CH:
	.dw PFA_DOVARIABLE
PFA_OCR1CH:
	.dw $79
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Output Compare Register Low Byte
VE_OCR1CL:
	.dw $ff06
	.db "OCR1CL"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR1CL
XT_OCR1CL:
	.dw PFA_DOVARIABLE
PFA_OCR1CL:
	.dw $78
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Control Register A
VE_TCCR1A:
	.dw $ff06
	.db "TCCR1A"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCCR1A
XT_TCCR1A:
	.dw PFA_DOVARIABLE
PFA_TCCR1A:
	.dw $4F
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Control Register B
VE_TCCR1B:
	.dw $ff06
	.db "TCCR1B"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCCR1B
XT_TCCR1B:
	.dw PFA_DOVARIABLE
PFA_TCCR1B:
	.dw $4E
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Control Register C
VE_TCCR1C:
	.dw $ff06
	.db "TCCR1C"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCCR1C
XT_TCCR1C:
	.dw PFA_DOVARIABLE
PFA_TCCR1C:
	.dw $7A
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 High Byte
VE_TCNT1H:
	.dw $ff06
	.db "TCNT1H"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCNT1H
XT_TCNT1H:
	.dw PFA_DOVARIABLE
PFA_TCNT1H:
	.dw $4D
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter1 Low Byte
VE_TCNT1L:
	.dw $ff06
	.db "TCNT1L"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCNT1L
XT_TCNT1L:
	.dw PFA_DOVARIABLE
PFA_TCNT1L:
	.dw $4C

.endif

; ********
.if WANT_TIMER_COUNTER_2 == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Output Compare Register
VE_OCR2:
	.dw $ff04
	.db "OCR2"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR2
XT_OCR2:
	.dw PFA_DOVARIABLE
PFA_OCR2:
	.dw $43
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter Control Register
VE_TCCR2:
	.dw $ff05
	.db "TCCR2",0
	.dw VE_HEAD
	.set VE_HEAD=VE_TCCR2
XT_TCCR2:
	.dw PFA_DOVARIABLE
PFA_TCCR2:
	.dw $45
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter Register
VE_TCNT2:
	.dw $ff05
	.db "TCNT2",0
	.dw VE_HEAD
	.set VE_HEAD=VE_TCNT2
XT_TCNT2:
	.dw PFA_DOVARIABLE
PFA_TCNT2:
	.dw $44

.endif

; ********
.if WANT_TIMER_COUNTER_3 == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Input Capture Register High Byte
VE_ICR3H:
	.dw $ff05
	.db "ICR3H",0
	.dw VE_HEAD
	.set VE_HEAD=VE_ICR3H
XT_ICR3H:
	.dw PFA_DOVARIABLE
PFA_ICR3H:
	.dw $81
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Input Capture Register Low Byte
VE_ICR3L:
	.dw $ff05
	.db "ICR3L",0
	.dw VE_HEAD
	.set VE_HEAD=VE_ICR3L
XT_ICR3L:
	.dw PFA_DOVARIABLE
PFA_ICR3L:
	.dw $80
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Output Compare Register A High Byte
VE_OCR3AH:
	.dw $ff06
	.db "OCR3AH"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR3AH
XT_OCR3AH:
	.dw PFA_DOVARIABLE
PFA_OCR3AH:
	.dw $87
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Output Compare Register A Low Byte
VE_OCR3AL:
	.dw $ff06
	.db "OCR3AL"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR3AL
XT_OCR3AL:
	.dw PFA_DOVARIABLE
PFA_OCR3AL:
	.dw $86
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Output Compare Register B High Byte
VE_OCR3BH:
	.dw $ff06
	.db "OCR3BH"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR3BH
XT_OCR3BH:
	.dw PFA_DOVARIABLE
PFA_OCR3BH:
	.dw $85
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Output Compare Register B Low Byte
VE_OCR3BL:
	.dw $ff06
	.db "OCR3BL"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR3BL
XT_OCR3BL:
	.dw PFA_DOVARIABLE
PFA_OCR3BL:
	.dw $84
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Output compare Register C High Byte
VE_OCR3CH:
	.dw $ff06
	.db "OCR3CH"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR3CH
XT_OCR3CH:
	.dw PFA_DOVARIABLE
PFA_OCR3CH:
	.dw $83
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Output compare register C Low byte
VE_OCR3CL:
	.dw $ff06
	.db "OCR3CL"
	.dw VE_HEAD
	.set VE_HEAD=VE_OCR3CL
XT_OCR3CL:
	.dw PFA_DOVARIABLE
PFA_OCR3CL:
	.dw $82
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Control Register A
VE_TCCR3A:
	.dw $ff06
	.db "TCCR3A"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCCR3A
XT_TCCR3A:
	.dw PFA_DOVARIABLE
PFA_TCCR3A:
	.dw $8B
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Control Register B
VE_TCCR3B:
	.dw $ff06
	.db "TCCR3B"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCCR3B
XT_TCCR3B:
	.dw PFA_DOVARIABLE
PFA_TCCR3B:
	.dw $8A
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Control Register C
VE_TCCR3C:
	.dw $ff06
	.db "TCCR3C"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCCR3C
XT_TCCR3C:
	.dw PFA_DOVARIABLE
PFA_TCCR3C:
	.dw $8C
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 High Byte
VE_TCNT3H:
	.dw $ff06
	.db "TCNT3H"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCNT3H
XT_TCNT3H:
	.dw PFA_DOVARIABLE
PFA_TCNT3H:
	.dw $89
; ( -- addr ) System Constant
; R( -- )
; Timer/Counter3 Low Byte
VE_TCNT3L:
	.dw $ff06
	.db "TCNT3L"
	.dw VE_HEAD
	.set VE_HEAD=VE_TCNT3L
XT_TCNT3L:
	.dw PFA_DOVARIABLE
PFA_TCNT3L:
	.dw $88

.endif

; ********
.if WANT_TWI == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; TWI (Slave) Address register
VE_TWAR:
	.dw $ff04
	.db "TWAR"
	.dw VE_HEAD
	.set VE_HEAD=VE_TWAR
XT_TWAR:
	.dw PFA_DOVARIABLE
PFA_TWAR:
	.dw $72
; ( -- addr ) System Constant
; R( -- )
; TWI Bit Rate register
VE_TWBR:
	.dw $ff04
	.db "TWBR"
	.dw VE_HEAD
	.set VE_HEAD=VE_TWBR
XT_TWBR:
	.dw PFA_DOVARIABLE
PFA_TWBR:
	.dw $70
; ( -- addr ) System Constant
; R( -- )
; TWI Control Register
VE_TWCR:
	.dw $ff04
	.db "TWCR"
	.dw VE_HEAD
	.set VE_HEAD=VE_TWCR
XT_TWCR:
	.dw PFA_DOVARIABLE
PFA_TWCR:
	.dw $74
; ( -- addr ) System Constant
; R( -- )
; TWI Data register
VE_TWDR:
	.dw $ff04
	.db "TWDR"
	.dw VE_HEAD
	.set VE_HEAD=VE_TWDR
XT_TWDR:
	.dw PFA_DOVARIABLE
PFA_TWDR:
	.dw $73
; ( -- addr ) System Constant
; R( -- )
; TWI Status Register
VE_TWSR:
	.dw $ff04
	.db "TWSR"
	.dw VE_HEAD
	.set VE_HEAD=VE_TWSR
XT_TWSR:
	.dw PFA_DOVARIABLE
PFA_TWSR:
	.dw $71

.endif

; ********
.if WANT_USART0 == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; USART Baud Rate Register Hight Byte
VE_UBRR0H:
	.dw $ff06
	.db "UBRR0H"
	.dw VE_HEAD
	.set VE_HEAD=VE_UBRR0H
XT_UBRR0H:
	.dw PFA_DOVARIABLE
PFA_UBRR0H:
	.dw $90
; ( -- addr ) System Constant
; R( -- )
; USART Baud Rate Register Low Byte
VE_UBRR0L:
	.dw $ff06
	.db "UBRR0L"
	.dw VE_HEAD
	.set VE_HEAD=VE_UBRR0L
XT_UBRR0L:
	.dw PFA_DOVARIABLE
PFA_UBRR0L:
	.dw $29
; ( -- addr ) System Constant
; R( -- )
; USART Control and Status Register A
VE_UCSR0A:
	.dw $ff06
	.db "UCSR0A"
	.dw VE_HEAD
	.set VE_HEAD=VE_UCSR0A
XT_UCSR0A:
	.dw PFA_DOVARIABLE
PFA_UCSR0A:
	.dw $2B
; ( -- addr ) System Constant
; R( -- )
; USART Control and Status Register B
VE_UCSR0B:
	.dw $ff06
	.db "UCSR0B"
	.dw VE_HEAD
	.set VE_HEAD=VE_UCSR0B
XT_UCSR0B:
	.dw PFA_DOVARIABLE
PFA_UCSR0B:
	.dw $2A
; ( -- addr ) System Constant
; R( -- )
; USART Control and Status Register C
VE_UCSR0C:
	.dw $ff06
	.db "UCSR0C"
	.dw VE_HEAD
	.set VE_HEAD=VE_UCSR0C
XT_UCSR0C:
	.dw PFA_DOVARIABLE
PFA_UCSR0C:
	.dw $95
; ( -- addr ) System Constant
; R( -- )
; USART I/O Data Register
VE_UDR0:
	.dw $ff04
	.db "UDR0"
	.dw VE_HEAD
	.set VE_HEAD=VE_UDR0
XT_UDR0:
	.dw PFA_DOVARIABLE
PFA_UDR0:
	.dw $2C

.endif

; ********
.if WANT_USART1 == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; USART Baud Rate Register Hight Byte
VE_UBRR1H:
	.dw $ff06
	.db "UBRR1H"
	.dw VE_HEAD
	.set VE_HEAD=VE_UBRR1H
XT_UBRR1H:
	.dw PFA_DOVARIABLE
PFA_UBRR1H:
	.dw $98
; ( -- addr ) System Constant
; R( -- )
; USART Baud Rate Register Low Byte
VE_UBRR1L:
	.dw $ff06
	.db "UBRR1L"
	.dw VE_HEAD
	.set VE_HEAD=VE_UBRR1L
XT_UBRR1L:
	.dw PFA_DOVARIABLE
PFA_UBRR1L:
	.dw $99
; ( -- addr ) System Constant
; R( -- )
; USART Control and Status Register A
VE_UCSR1A:
	.dw $ff06
	.db "UCSR1A"
	.dw VE_HEAD
	.set VE_HEAD=VE_UCSR1A
XT_UCSR1A:
	.dw PFA_DOVARIABLE
PFA_UCSR1A:
	.dw $9B
; ( -- addr ) System Constant
; R( -- )
; USART Control and Status Register B
VE_UCSR1B:
	.dw $ff06
	.db "UCSR1B"
	.dw VE_HEAD
	.set VE_HEAD=VE_UCSR1B
XT_UCSR1B:
	.dw PFA_DOVARIABLE
PFA_UCSR1B:
	.dw $9A
; ( -- addr ) System Constant
; R( -- )
; USART Control and Status Register C
VE_UCSR1C:
	.dw $ff06
	.db "UCSR1C"
	.dw VE_HEAD
	.set VE_HEAD=VE_UCSR1C
XT_UCSR1C:
	.dw PFA_DOVARIABLE
PFA_UCSR1C:
	.dw $9D
; ( -- addr ) System Constant
; R( -- )
; USART I/O Data Register
VE_UDR1:
	.dw $ff04
	.db "UDR1"
	.dw VE_HEAD
	.set VE_HEAD=VE_UDR1
XT_UDR1:
	.dw PFA_DOVARIABLE
PFA_UDR1:
	.dw $9C

.endif

; ********
.if WANT_WATCHDOG == 1
; ********
; ( -- addr ) System Constant
; R( -- )
; Watchdog Timer Control Register
VE_WDTCR:
	.dw $ff05
	.db "WDTCR",0
	.dw VE_HEAD
	.set VE_HEAD=VE_WDTCR
XT_WDTCR:
	.dw PFA_DOVARIABLE
PFA_WDTCR:
	.dw $41

.endif
