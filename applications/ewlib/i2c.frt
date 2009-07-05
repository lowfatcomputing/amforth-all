\ 2008-01-10 EW

hex
: init-twi
  7f 03 +twi
;

decimal
\ send n bytes to addr
: >i2c ( x1 .. xN.msB N addr -- )
  twi.start
  twi.tx    \ uses addr
  0 do      \ uses N
    twi.tx  \ uses xN .. x1
  loop
  twi.stop
;

: <i2c ( N addr -- xN.msB .. x1 )
  twi.start
  1+ twi.tx \ uses addr
  1- dup 0 > if
    0 do twi.rx loop
  else
    drop
  then
  twi.rxn
  twi.stop
;

