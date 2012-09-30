\ 2008-10-11 EW  i2c_lmXX.fs
\ read an lm75,lm92 temperature sensors on
\ i2c bus

\ words:
\     lm.get ( i2c_addr -- xh xl ok | err )
\     lm75.decode ( xh xl -- T*100 )
\     lm92.decode ( xh xl -- T*100 )

\ read 2 bytes from sensor, if available
: lm.get ( i2c_addr -- xh xl ok | err )
  dup twi.ping? if
      >r
  0 &1 r@ >i2c
    &2 r> <i2c
    0 \ ok
  else
    drop   \ addr
    -1 \ err
  then
;
\ lm75: decode 2 bytes into T*100
\ 9bit signed
: lm75.decode ( xh xl -- T*100 )
  $80 and swap $08 lshift +
  &100 &256 */
;
\ lm92: decode 2 bytes into T*100,
\ 11bit signed
: lm92.decode ( xh xl -- T*100 )
  $f8 and swap $08 lshift +
  &100 &128 */
;
