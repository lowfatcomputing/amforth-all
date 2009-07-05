\ 2009-01-01 EW    ewlib/adc.fs
\
\ use local 8- or 10-bit adc on atmega32 (porta)
\ ADCSR -> ADCSRA 2009-06-17

\ needs ewlib/bitnames.frt
\ needs ewlib/portpin.fs

\ usage
\ -- definition
\ PORTA 0 portpin: adc_pin0
\ -- init
\ adc.init
\ adc.init-pin adc_pin0


: adc.init ( -- )
  \ ADMUX: (1<<ADLAR)
  [ 1 5 lshift ] literal ADMUX c!
  \ ADCSRA: (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1 | (1<<ADPS0)
  \ AD enabled, prescaler=128
  [ 1 7 lshift
    1 2 lshift or
    1 1 lshift or
    1          or ] literal ADCSRA c!
;
: adc.init.pin ( bitmask portaddr -- )
  over over high
  pin_input
;
  
1 6 lshift constant ADSC_MSK \ ADStartConversion bitmask
: adc.start
  \ start conversion
  ADSC_MSK ADCSRA or!
;
: adc.wait
  \ wait for completion of conversion
  begin
    ADCSRA c@ ADSC_MSK and 0=
  until
;
: adc.channel! ( channel -- )
  7 and                 \ clip channel to 0..7
  ADMUX c@ 7 invert and \ read ADMUX, clear old channel
  or                    \ add new channel
  ADMUX c!              \ write
;
: adc.get10 ( channel -- a )
  adc.channel! adc.start adc.wait
\ 10 bit
  ADCL c@
  ADCH c@ 8 lshift + 6 rshift
;
: adc.get ( channel -- a )
  adc.channel! adc.start adc.wait
\ 8 bit
  ADCH c@
;
