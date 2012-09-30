\ 2011-05-29  EW  ewlib/rfm12.fs
\                               \ +rfm12 rfm12.init
\                               \ >wc wc? w? >w

10   constant w.maxtimeout \ in 1ms
     variable w.state
\ wait for wireless data tx ready
\ : w? ( -- ) _rfm12 low begin _miso pin_high? until ;
: w? ( -- )
  _rfm12 low
  1 w.state !
  w.maxtimeout 0 do
    1ms
    _miso pin_high? if
      0 w.state !
      leave
    then
  loop

  w.state @ 0= not if
    \ timeout
    #timeout throw
  then
;

\ write 1 cell to wireless control
: (>wc) ( x -- x' ) _rfm12 low !@spi _rfm12 high ;
\ write wireless control, drop reply
: >wc ( x -- )    (>wc) drop ;
\ read wireless status
: wc? ( -- x )  0 (>wc)      ;
: w.status wc? 4 hex u0.r ;

\ write wireless data
: >w ( c -- )   $00ff and $b800 +   w? (>wc) drop ;
\ read one byte
: <w ( -- c )   $b000               w? (>wc) ;

: +rfm12
  _rfm12 low _rfm12 pin_output
;
: -rfm12
  _rfm12 low _rfm12 pin_input
;
: rfm12.init
  \ init sequence
  $80d7 >wc
  $82d9 >wc \ 
\ $a67c >wc \ 434.150 MHz;  Band Mitte: 433.920 MHz
\ $a6b8 >wc \ 434.300 MHz
  $a530 >wc \ 433.620 MHz
\ $c647 >wc \ 4800 baud
  $c6a3 >wc \ 1200 baud
\ $c6ff >wc \  340 baud
  $94a0 >wc \ bandwith: 134 kHz
\ $9480 >wc \           200 kHz
  $c2ac >wc
  $ca81 >wc
  $c483 >wc \ AFC
\ $c400 >wc \ AFC test without
\ $9850 >wc \ (5+1)*15 = 90 kHz Hub,   0dB (max. power)
\ $9854 >wc \ (5+1)*15 = 90 kHz Hub, -12dB
  $9857 >wc \ (5+1)*15 = 90 kHz Hub, -21dB
\ $9894 >wc \ (9+1)*15 = 150 kHz
  $e000 >wc
  $c800 >wc
  $c000 >wc
;


\ Sende/Empfangsfrequenz
\ f = 10 * C1 * ( C2 + F/4000 ) [MHz]
\ 434 MHz: C1 = 1  C2 = 43
\ F:  96 <= F <= 3903
\ 
\ f = 10 * 1 * ( 43 +  F[0..11]/4000 )
\     10     * ( 43 +  $06b8/4000 )
\     10     * ( 43 +   1720/4000 )
\   = 434.300 MHz
\ f:  430.24 <= f <= 439.75 [MHz]
\ hub: Df = (M[0..3] + 1) * 15 kHz
\
