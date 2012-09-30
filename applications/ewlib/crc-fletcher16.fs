\ 2011-06-02  EW
\ calculate the fletcher-16 checksum
\ http://en.wikipedia.org/wiki/Fletcher%27s_checksum


variable crc.fl.sum1
variable crc.fl.sum2
: crc.fletcher16 ( addr len -- checksum )
  0 crc.fl.sum1 !
  0 crc.fl.sum2 !
  
  ( len ) 0 ?do
    dup i + c@                         \ -- addr d[i]
    crc.fl.sum1 @ + $00ff and          \ -- addr crc.fl.sum1
\    dup 4 u0.r space \ debug
    dup crc.fl.sum1 !                  \ -- addr crc.fl.sum1
    crc.fl.sum2 @ + $00ff and          \ -- addr crc.fl.sum2
\    dup 4 u0.r cr \ debug
    crc.fl.sum2 !
  loop
  drop

  crc.fl.sum1 @ crc.fl.sum2 @ +  0 swap -  $00ff and  \ -- -(c0+c1)
\  dup 4 u0.r space ." chb1" cr \ debug

  crc.fl.sum2 @
\  dup 4 u0.r space ." chb2" cr \ debug

  swap >< +
;

\ fin
