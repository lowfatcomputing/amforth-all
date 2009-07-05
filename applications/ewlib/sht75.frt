\ 2009-01-05   EW   ewlib/sht75.fs
\ 
\ words to control a Sensirion SHT75 Humidity Sensor
\
\ AVR pins:
\ data must have an external pullup resistor!
\ default state for data is "highZ", i.e. "pin_input low"
\ to write a "1" (high) do nothing, the pullup will create high.
\ to write a "0" (low) switch to output. Since level is low already
\   this will force the line low. Then switch back to input to release
\   the line
\
\ 
\ needs bitnames.frt: pin_highZ
\ 
\ needs:
\     PORTx n portpin: sht_clk
\     PORTx n portpin: sht_dat
\
\ words:
\     sht.io.init ( -- )
\     sht.reset ( -- )
\     sht.get.T ( -- T*100[C] ok | err )
\     sht.get.H ( -- H*10[%] ok  | err )

hex
03 constant cmd_read_T \ command byte
05 constant cmd_read_H \ command byte
1e constant cmd_reset  \ command byte

: sht.io.init ( -- )
  sht_clk pin_output
  sht_clk high
  \ default state for sht_dat is "highZ" == pin_input low
  sht_dat pin_highZ
;

: sht.tick   noop ;
: sht.2tick  sht.tick sht.tick ;

: sht.clk0   sht_clk low ;
: sht.clk1   sht_clk high ;
: sht.dat0   sht_dat pin_output ; \ force pin low
: sht.dat1   sht_dat pin_input ;  \ release pin

\ write one bit
: bit>sht ( 0|1 -- )
  0= if sht.dat0 then
  sht.tick  sht.clk1 sht.2tick sht.clk0 sht.tick
  sht.dat1 \ always release dat! may cause glitches ...
;
\ write 1 Byte, (8 Bit) "most significant bit" first
: byte>sht ( x -- )
  \ ms-bit first
  0 7 do
    dup i rshift 1 and
    bit>sht
  -1 +loop
  drop
;

\ read one bit, assume pin is highZ
: bit<sht ( -- 0|1 )
  sht.tick  sht.clk1
  sht_dat pin_high? if 1 else 0 then
  sht.2tick sht.clk0 sht.tick
;
\ read one byte from sensor
: byte<sht ( -- x )
  0 \ empty byte
  8 0 do
    1 lshift
    bit<sht
    or \ add bit to byte
  loop
;

\ read ack
: ack<sht ( -- f )
  bit<sht
  invert 1 and \ ack is low, nack is high
;
\ send ack (low!) / nack (high)
: ack>sht   0 bit>sht ;
: nack>sht  1 bit>sht ;

\ send transmission start sequence
: start>sht
  sht.clk1 sht.tick
  sht_dat pin_output \ force data down
  sht.clk0 sht.2tick
  sht.clk1 sht.tick
  sht_dat pin_input  \ release data
  sht.clk0 sht.2tick
  \ clock is low during transmission, not high.
;

: cmd>sht ( x -- ack )
  start>sht byte>sht ack<sht
;
: sht.reset ( -- )
  cmd_reset cmd>sht drop
  11 0 do 1ms loop \ wait min. 11 ms after reset!
;
\ wait for conversion to complete
: sht.wait ( -- )
  begin 1ms sht_dat pin_low? until
;

\ one complete sequence to read
\ temperature or humidity
: sht.get ( cmd_read_X -- X.high X.low X.crc8 ok | err )
  cmd>sht                 ( -- n|ack )
  1 = if \ ack received
    sht.wait
    byte<sht ack>sht      ( -- X.high )
    byte<sht ack>sht      ( -- X.high X.low )
    byte<sht nack>sht     ( -- X.high X.low X.crc8 )
    0                     ( -- X.high X.low X.crc8 0=ok )
  else
    -1                    ( -- !0=err )
  then
;    

decimal
\ see section 1.1.2 of datasheet
\ Traw = Thi<<8 + Tlo
\ T [C] = d1 + d2*Traw
\ 14 bit @ 5V: d1=-40 d2=0.01
\ T = -40 + 0.01*Traw
\ T*100 = -4000 + 1*Traw
\ T*100 = Traw - 4000
: sht.decode.T ( T.hi T.lo -- T*100 [C] )
  swap 8 lshift +
  4000 -
;

\ see section 1.1.1 of datasheet
\ Hraw = Hhi<<8 + Hlo
\ H_25 [%] = c1 + c2*Hraw + c3*Hraw^2
\ 12bit:        c1=-4         c2=0.0405  c3=-2.8e-6
\ scaled*10^7:     -40000000     405000     -28
\ H_25*10 [%] = ((405000-28*x)*x-40000000)/1000000
: sht.H.raw>lin ( H_raw -- H_lin*10[%] )
  dup >r
  s>d 28 1 m*/              \ 28*x
  4050 s>d 100 1 m*/        \ 405000
  2swap dnegate d+          \ y=405000-28*x
  r> 1 m*/                  \ (y)*x
  4000 s>d 10000 1 m*/      \ 40000000
  dnegate d+                \ (y)*x-4e7
  1 1000 m*/
  1 1000 m*/                \ rH lin @ 25 deg C
  drop \ d>s
;

: sht.decode.H ( H.hi H.lo -- H*10 [%] )
  swap 8 lshift +           \ x = H_raw
  sht.H.raw>lin
;

: sht.get.T ( -- T*100[C] ok | err )
  cmd_read_T sht.get 0= if
    drop \ crc8
    sht.decode.T
    0  ( ok )
  else
    -1 ( error )
  then
;

: sht.get.H ( -- H*10[%] ok | err )
  cmd_read_H sht.get 0= if
    drop \ crc8
    sht.decode.H
    0  ( ok )
  else
    -1 ( error )
  then
;

: sht.decode.Hcorr ( T*100[C] H.hi H.lo -- RH_true*10[%] )
  swap 8 lshift +               \ T*100 H_raw
  dup >r                        \ T*100 H_raw           r: H_raw
  s>d 8 1 m*/                   \ T*100 d(1000+8*H_raw) r: H_raw
  rot                           \ d(1000+8*H_raw) T*100 r: H_raw
  10 / 250 -                    \ d(1000+8*H_raw) (T*10-250) r: H_raw
  1000 m*/
  1 100 m*/                     \ (((xT/10-250)*(1000+8*x))/100000)
  r> sht.H.raw>lin s>d d+       \ (((xT/10-250)*(1000+8*x))/100000)+xH
  drop \ d>s
;

: sht.get.Hcorr ( -- H*10[%] 0=ok | err )
  cmd_read_T sht.get 0= if      \ T.hi T.lo Tcrc
    drop \ crc8                 \ T.hi T.lo
    sht.decode.T                \ T*100
    cmd_read_H sht.get 0= if    \ T*100 H.hi H.lo Hcrc
      drop \ crc8               \ T*100 H.hi H.lo
      sht.decode.Hcorr          \ H(T)*10[%]
      0  ( ok )                 \ H(T)*10[%] ok
    else
      drop \ T*100
      -1
    then
  else
    -1 ( error )
  then
;
