\ 2011-05-29  EW  ewlib/rfm12.fs
\ wireless used as synonym for rfm12
\
\ words:
\    +rfm12 rfm12.init
\    >wc wc? w? >w
\    w.status

\ wait for wireless data tx ready
: w? ( -- )
  _rfm12 low
  begin
    _miso pin_high?
  until
;
\ write 1 cell to wireless control
: (>wc) ( x -- x' )
  _rfm12 low
  !@spi \ 2spirw
  _rfm12 high
;
\ write wireless control, drop reply
: >wc ( x -- )
  (>wc) drop
;
\ read wireless status
: wc? ( -- x )
  0 (>wc)
;
: w.status
  wc? 4 hex u0.r
;
\ write wireless data
: >w ( c -- )
  $00ff and  $b800 +
  w?
  (>wc) drop
;
\ read one byte
: <w ( -- c )
  $b000
  w?
  (>wc)
;
: +rfm12
  _rfm12 low
  _rfm12 pin_output
;
: rfm12.init
  \ init sequence
  $80d7 >wc
  $82d9 >wc \ 
  $a530 >wc \ 433.620 MHz
  $c647 >wc \ 4800 baud
  $94a0 >wc \ bandwith: 134 kHz
  $c2ac >wc
  $ca81 >wc
  $c483 >wc \ AFC
  $9854 >wc \ (5+1)*15 = 90 kHz Hub, -12dB
  $e000 >wc
  $c800 >wc
  $c000 >wc
;
