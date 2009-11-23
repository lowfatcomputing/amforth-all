( ------------------------------------------------------------------------ )
( --              communications line interface tandy 102               -- )
( ------------------------------------------------------------------------ )

hex

\ set baud rate
: com ( rate-code -- ) 030 + 0F65B c! ;

\ initialise communications line
: cl.init {cl ;

\ receive a byte from line
code cl.rx ( -- received-byte )
  06D7E call
  ( no error check )
  0 h ldbi
  a l ldb
  hpush

\ transmit a byte to line
code cl.tx ( transmit-byte -- )
  hl popw
  l a ldb
  06E32 call
  ( no error check )
  next

decimal

pr.rx   ' cl.rx   ' cl pr.set
pr.tx   ' cl.tx   ' cl pr.set
pr.init ' cl.init ' cl pr.set




