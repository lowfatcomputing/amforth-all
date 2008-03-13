\ Echtzeituhr ueber timer 2 mit 32kHz Quarz

variable rtc_time

hex
\ interupt: zaehlt alle 2 sek. hoch
: rtc_int
    rtc_time @ 1+ dup
    a8c0 = if drop 0 then
    rtc_time !
\    1 rtc_time +!
;

hex
\ Schaltet die Uhr ein
: rtc
    6 45 c! ( alle 2 sek )
    8 42 c! ( ueber 32kHz Quarz )
    ['] rtc_int 5 int! ( setze Vektor )
    59 c@  ( enable only Timer2 irq )
    40 or
    59 c!
;

hex
\ Schaltet die Uhr aus
: /rtc
    59 c@   ( read TIMSK  )
    bf and  ( clr Timer 2 )
    59 c!   ( write TIMSK )
;

decimal
\ legt Uhrzeit auf Stack
: rtc@  (  --  mm  hh )
    rtc_time @
    30 u/mod
    swap drop ( sek loeschen )
    60 u/mod  ( min )
    24 u/mod  ( std )
    drop      ( rest loeschen )
;

decimal
\ setzt uhrzeit
: rtc!  (  mm hh --  )
    60 * + 30 *
    rtc_time !
;

decimal
\ druckt Uhrzeit
: rtc? 
    rtc@
    . 32 emit 58 emit . cr
;

\ Druckt endlos die uhr aus
: rtc_test
    rtc
    begin
      rtc? cr
    0 until
;