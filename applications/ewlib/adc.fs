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

: -adc ( -- )
  \ ADCSRA[7] = 0
  [ 1 7 lshift invert
  ] literal ADCSRA c@ and ADCSRA c!
;

: +adc ( -- )
  \ result left adusted
  [ 1 5 lshift          \ ADLAR
  ] literal ADMUX c!
  \ AD enabled, prescaler=128
  [ 1 7 lshift          \ ADEN
    1 2 lshift or       \ ADPS2
    1 1 lshift or       \ ADPS1
    1          or       \ ADPS0
  ] literal ADCSRA c!
;
: +adc_internal ( -- )
  \ internal reference 2.56 V, left adjusted
  [ %11 6 lshift        \ REFS1,0
    5 bv         or     \ ADLAR
  ] literal ADMUX c!
  \ AD enabled, prescaler=128
  [ 7 bv                \ ADEN
    %111 or             \ ADPS2,1,0
  ] literal ADCSRA c!
;

: adc.init.pin ( bitmask portaddr -- )
  pin_highZ
;

\ ADStartConversion bitmask
1 6 lshift constant ADSC_MSK
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
  7 and                 \ clip channel 0..7
  ADMUX c@              \ read ADMUX
  7 invert and          \ clear old channel
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
