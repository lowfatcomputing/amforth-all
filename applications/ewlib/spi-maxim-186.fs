\ 2010-05-24  EW  spi-maxim-186.fs

\ words:
\     max186.init ( -- )
\     @max186.ch3 ( -- x )

\ needs portpin: _sel defined before loading

\ needs some more stuff to be generally useful
\     max186.pin>ch ( n -- addr_bits )
\     @max186  ( pin_nr -- value )

\ cleanup: _sel is maybe too short: sel_max186 ?

: max186.init
  _sel  high
  _sel pin_output
;

\ control byte
\ 7  START  1. bit after /cs falling edge indicates control byte
\ 6  SEL2   channel addr
\ 5  SEL1   .
\ 4  SEL0   .
\ 3  UNI    1 unipolar, 0 bipolar -V/2 .. +V/2
\ 2  SGL    1 single ended, 0 differential
\ 1  PD1    . 11 external clock mode
\ 0  PD0
\ ==> %1___1111  == $8f | channel_addr<<4


\ pin Nr -> channel addr, single ended (datasheet Ch.
\           sel2,1,0]
\ 1         0 0 0
\ 2         1 0 0
\ 3         0 0 1
\ 4         1 0 1
\ 5         0 1 0
\ 6         1 1 0
\ 7         0 1 1
\ 8         1 1 1

: max186.pin>channel ( pinNr -- channel-addr )
  $07 and \ clip to 3 bit
  >r
  r@ $01 and 2 lshift \ -- sel2
  r@ $04 and 1 rshift \ -- sel2 sel1
  r> $02 and 1 rshift \ -- sel2 sel1 sel0
  or or
;

\ 1 clock cycle is lost; we should wait for SSTRB to become high
\ instead. However, we are slow enough. So "3 rshift" not "4 rshift"
: max186.get ( pinNr -- value )
  max186.pin>channel 4 lshift
  $8f or                        \ 1___1111 | _ccc____
  _sel low
  spirw drop
  0 spirw 0 spirw
  _sel high
  swap 8 lshift + 3 rshift
;

\ : @max186.ch3 ( -- value )
\   _sel low
\   [ $8f  %01010000 or ] literal \ pin4 == ch3 == %_101____
\     spirw drop
\   0 spirw 0 spirw
\   _sel high
\   swap 8 lshift + 3 rshift
\ ;

\ fin