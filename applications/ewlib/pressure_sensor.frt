\ 2008-12-23   EW   pressure_sensor.fs
\ 2009-01-01   EW   changed from i2c/twi slave to local adc

\ needs ewlib/adc.fs

\ words:

\ ( mask addr ) from portpin: "object"
: pr.get ( mask addr -- raw_value )
  pin>channel adc.get10
;
\ : pr.decode ( raw_value[0..1023] -- p*10 [hPa] )
\   \ p [kPa] = (raw/1024 + 0.095)/0.009 * exp(h/8005)
\   \ h = 550; exp(h/8005) = 1.0711
\   \ p [Pa]  = (raw*1000/1024 + 95)/9 * 1071
\   \ p [DPa] = (raw*1000/1024 + 95) * 119 / 10
\   \ raw=795 -> p = 10369 [DPa] = 1036.9 [hPa]
\   s>d 1000 1024 m*/  95 m+
\   119 10 m*/
\   drop \ drop higher byte, single cell result
\   \ fixme: there must be a better way to reduce double to single!
\ ;


  \ h = 50; exp(h/8005)  = 1.0063 \ Berlin
  \ p [Pa]  = (raw*1000/1024 + 95)/9 * 1006
: pr.decode ( raw_value[0..1023] -- p*10 [hPa] )
  s>d 1000 1024 m*/  95 m+
  112 10 m*/
  drop
;

\ words:
\     pr.decode ( u -- u' )
\     pr.get ( addr -- u ok/err )


\ DERZEIT ist das eine Kopie von sl.get, die statt 4 eben 6 Bytes holt
\ und die ersten 4 wegschmeisst.
: pr.twi.get ( addr -- ul uh ok/err )
  dup twi.ping? if
      >r
  0 1 r@ >i2c
    6 r> <i2c
    >r >r drop drop drop drop r> r> \ drop bytes 1..4
    0 \ ok
  else
    drop \ addr
    -1 \ err
  then
;
: pr.twi.decode ( ul uh -- p [10Pa] )
  8 lshift +  \ die zwei Bytes zu einer Zahl zusammenfassen
  \ p [kPa] = (raw/1024 + 0.095)/0.009 * exp(h/8005); scaled:
  \ h = 550; exp(h/8005) = 1.0711
  \ p [Pa]  = (raw*1000/1024 + 95)/9 * 1071
  \ p [DPa] = (raw*1000/1024 + 95) * 119 / 10
  \ raw=795 -> p = 10369 [DPa] = 1036.9 [hPa]
  s>d 1000 1024 m*/  95 m+
  119 10 m*/
  drop \ drop higher byte, single cell result
  \ fixme: there must be a better way to reduce double to single!
;
