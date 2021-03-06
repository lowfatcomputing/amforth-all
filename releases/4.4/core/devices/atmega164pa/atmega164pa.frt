\ Partname: ATmega164PA
\ Built using part description XML file version 1
\ generated automatically

hex

\ AD_CONVERTER
79 constant ADCH	\ ADC Data Register High Byte
78 constant ADCL	\ ADC Data Register Low Byte
7A constant ADCSRA	\ The ADC Control and Status register A
7B constant ADCSRB	\ The ADC Control and Status register B
7C constant ADMUX	\ The ADC multiplexer Selection Register
7E constant DIDR0	\ Digital Input Disable Register

\ ANALOG_COMPARATOR
50 constant ACSR	\ Analog Comparator Control And Status Register
7F constant DIDR1	\ Digital Input Disable Register 1

\ BOOT_LOAD
57 constant SPMCSR	\ Store Program Memory Control Register

\ CPU
61 constant CLKPR	\ 
3E constant GPIOR0	\ General Purpose IO Register 0
4A constant GPIOR1	\ General Purpose IO Register 1
4B constant GPIOR2	\ General Purpose IO Register 2
55 constant MCUCR	\ MCU Control Register
54 constant MCUSR	\ MCU Status Register
66 constant OSCCAL	\ Oscillator Calibration Value
64 constant PRR0	\ Power Reduction Register0
53 constant SMCR	\ Sleep Mode Control Register
5E constant SPH	\ Stack Pointer High
5D constant SPL	\ Stack Pointer Low
5F constant SREG	\ Status Register

\ EEPROM
42 constant EEARH	\ EEPROM Address Register Low Byte
41 constant EEARL	\ EEPROM Address Register Low Byte
3F constant EECR	\ EEPROM Control Register
40 constant EEDR	\ EEPROM Data Register

\ EXTERNAL_INTERRUPT
69 constant EICRA	\ External Interrupt Control Register A
3C constant EIFR	\ External Interrupt Flag Register
3D constant EIMSK	\ External Interrupt Mask Register
68 constant PCICR	\ Pin Change Interrupt Control Register
3B constant PCIFR	\ Pin Change Interrupt Flag Register
6B constant PCMSK0	\ Pin Change Mask Register 0
6C constant PCMSK1	\ Pin Change Mask Register 1
6D constant PCMSK2	\ Pin Change Mask Register 2
73 constant PCMSK3	\ Pin Change Mask Register 3

\ JTAG
51 constant OCDR	\ On-Chip Debug Related Register in I/O Memory

\ PORTA
21 constant DDRA	\ Port A Data Direction Register
20 constant PINA	\ Port A Input Pins
22 constant PORTA	\ Port A Data Register

\ PORTB
24 constant DDRB	\ Port B Data Direction Register
23 constant PINB	\ Port B Input Pins
25 constant PORTB	\ Port B Data Register

\ PORTC
27 constant DDRC	\ Port C Data Direction Register
26 constant PINC	\ Port C Input Pins
28 constant PORTC	\ Port C Data Register

\ PORTD
2A constant DDRD	\ Port D Data Direction Register
29 constant PIND	\ Port D Input Pins
2B constant PORTD	\ Port D Data Register

\ SPI
4C constant SPCR0	\ SPI Control Register
4E constant SPDR0	\ SPI Data Register
4D constant SPSR0	\ SPI Status Register

\ TIMER_COUNTER_0
43 constant GTCCR	\ General Timer/Counter Control Register
47 constant OCR0A	\ Timer/Counter0 Output Compare Register
48 constant OCR0B	\ Timer/Counter0 Output Compare Register
44 constant TCCR0A	\ Timer/Counter  Control Register A
45 constant TCCR0B	\ Timer/Counter Control Register B
46 constant TCNT0	\ Timer/Counter0
35 constant TIFR0	\ Timer/Counter0 Interrupt Flag register
6E constant TIMSK0	\ Timer/Counter0 Interrupt Mask Register

\ TIMER_COUNTER_1
87 constant ICR1H	\ Timer/Counter1 Input Capture Register High Byte
86 constant ICR1L	\ Timer/Counter1 Input Capture Register Low Byte
89 constant OCR1AH	\ Timer/Counter1 Output Compare Register A High Byte
88 constant OCR1AL	\ Timer/Counter1 Output Compare Register A Low Byte
8B constant OCR1BH	\ Timer/Counter1 Output Compare Register B High Byte
8A constant OCR1BL	\ Timer/Counter1 Output Compare Register B Low Byte
80 constant TCCR1A	\ Timer/Counter1 Control Register A
81 constant TCCR1B	\ Timer/Counter1 Control Register B
82 constant TCCR1C	\ Timer/Counter1 Control Register C
85 constant TCNT1H	\ Timer/Counter1 High Byte
84 constant TCNT1L	\ Timer/Counter1 Low Byte
36 constant TIFR1	\ Timer/Counter Interrupt Flag register
6F constant TIMSK1	\ Timer/Counter1 Interrupt Mask Register

\ TIMER_COUNTER_2
B6 constant ASSR	\ Asynchronous Status Register
B3 constant OCR2A	\ Timer/Counter2 Output Compare Register A
B4 constant OCR2B	\ Timer/Counter2 Output Compare Register B
B0 constant TCCR2A	\ Timer/Counter2 Control Register A
B1 constant TCCR2B	\ Timer/Counter2 Control Register B
B2 constant TCNT2	\ Timer/Counter2
37 constant TIFR2	\ Timer/Counter Interrupt Flag Register
70 constant TIMSK2	\ Timer/Counter Interrupt Mask register

\ TWI
BD constant TWAMR	\ TWI (Slave) Address Mask Register
BA constant TWAR	\ TWI (Slave) Address register
B8 constant TWBR	\ TWI Bit Rate register
BC constant TWCR	\ TWI Control Register
BB constant TWDR	\ TWI Data register
B9 constant TWSR	\ TWI Status Register

\ USART0
C5 constant UBRR0H	\ USART Baud Rate Register High Byte
C4 constant UBRR0L	\ USART Baud Rate Register Low Byte
C0 constant UCSR0A	\ USART Control and Status Register A
C1 constant UCSR0B	\ USART Control and Status Register B
C2 constant UCSR0C	\ USART Control and Status Register C
C6 constant UDR0	\ USART I/O Data Register

\ USART1
CD constant UBRR1H	\ USART Baud Rate Register High Byte
CC constant UBRR1L	\ USART Baud Rate Register Low Byte
C8 constant UCSR1A	\ USART Control and Status Register A
C9 constant UCSR1B	\ USART Control and Status Register B
CA constant UCSR1C	\ USART Control and Status Register C
CE constant UDR1	\ USART I/O Data Register

\ WATCHDOG
60 constant WDTCSR	\ Watchdog Timer Control Register

\ Interrupts
002  constant INT0Addr \ External Interrupt Request 0
004  constant INT1Addr \ External Interrupt Request 1
006  constant INT2Addr \ External Interrupt Request 2
008  constant PCINT0Addr \ Pin Change Interrupt Request 0
00A  constant PCINT1Addr \ Pin Change Interrupt Request 1
00C  constant PCINT2Addr \ Pin Change Interrupt Request 2
00E  constant PCINT3Addr \ Pin Change Interrupt Request 3
010  constant WDTAddr \ Watchdog Time-out Interrupt
012  constant TIMER2_COMPAAddr \ Timer/Counter2 Compare Match A
014  constant TIMER2_COMPBAddr \ Timer/Counter2 Compare Match B
016  constant TIMER2_OVFAddr \ Timer/Counter2 Overflow
018  constant TIMER1_CAPTAddr \ Timer/Counter1 Capture Event
01A  constant TIMER1_COMPAAddr \ Timer/Counter1 Compare Match A
01C  constant TIMER1_COMPBAddr \ Timer/Counter1 Compare Match B
01E  constant TIMER1_OVFAddr \ Timer/Counter1 Overflow
020  constant TIMER0_COMPAAddr \ Timer/Counter0 Compare Match A
022  constant TIMER0_COMPBAddr \ Timer/Counter0 Compare Match B
024  constant TIMER0_OVFAddr \ Timer/Counter0 Overflow
026  constant SPI_STCAddr \ SPI Serial Transfer Complete
028  constant USART0_RXAddr \ USART0, Rx Complete
02A  constant USART0_UDREAddr \ USART0 Data register Empty
02C  constant USART0_TXAddr \ USART0, Tx Complete
02E  constant ANALOG_COMPAddr \ Analog Comparator
030  constant ADCAddr \ ADC Conversion Complete
032  constant EE_READYAddr \ EEPROM Ready
034  constant TWIAddr \ 2-wire Serial Interface
036  constant SPM_READYAddr \ Store Program Memory Read
038  constant USART1_RXAddr \ USART1 RX complete
3A  constant USART1_UDREAddr \ USART1 Data Register Empty
3C  constant USART1_TXAddr \ USART1 TX complete
