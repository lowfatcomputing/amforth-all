\ 2010-05-24  EW   ewlib/spi.fs
\ spi, using hw interface

\ PORTB 4 portpin: /ss
\ PORTB 5 portpin: _mosi
\ PORTB 6 portpin: _miso
\ PORTB 7 portpin: _clk

: +spi ( -- )
  /ss high \ activate pullup!
  _mosi high _mosi pin_output
  _clk  low  _clk  pin_output
\  _miso pin_pullup_on  \ not needed, see datasheet
  $53 SPCR c! \ enable, master mode, f/128 data rate
;
: -spi
  0 SPCR c!
  _mosi low _mosi pin_input
  _miso low _miso pin_input
  _clk  low _clk  pin_input
;

\ transfer 1 byte: c!@spi (  c -- c' )
\ transfer 1 cell:  !@spi ( n1 -- n2 )
