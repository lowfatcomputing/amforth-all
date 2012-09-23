\ 2011-08-28  EW   ewlib/spi.fs
\ spi, using hw interface
\ in dict_appl.inc:
\     .include "words/spirw.asm"
\     .include "words/2spirw.asm"
\ words:
\     +spi   ( -- )
\     -spi   ( -- )
\ transfer 1 byte:  c!@spi (  c -- c' )
\ transfer 1 cell:   !@spi ( n1 -- n2 )

\ needs these defined before loading:
PORTB 4 portpin: /ss
\ PORTB 5 portpin: _mosi
\ PORTB 6 portpin: _miso
\ PORTB 7 portpin: _clk

: +spi ( -- )
  /ss high \ activate pullup!
  _mosi high _mosi pin_output
  _clk  low  _clk  pin_output
  \ not needed, see datasheet:
  \ _miso pin_pullup_on

  \ enable, master mode
  \ f_cpu/128 speed
  $53 SPCR c! 
;
: -spi  0 SPCR c! ;
