\ 2010-05-28  EW  ewlib/mpx41xx.fs
\
\ words to convert raw adc values to physical units
\ Freescale MPX-4100 absolute pressure sensor
\ Freescale MPX-4115


decimal

10000 value AltScale \ exp(h/8005)*1.0e4
\ set this scale factor after loading this file, e.g.
\ &10063 to AltScale            \    50m
\ &10125 to AltScale            \   100m
\ &11331 to AltScale            \  1000m


\ MPX 4110 A
\ Vout = VS (P x 0.01059 - 0.1518) [kPa?] (see datasheet)
\ Vout/VS =  P x 0.01059 - 0.1518
\ Vout/VS + 0.1518 = P x 0.01059
\ (Vout/VS + 0.1518)/0.01059 = P [kPa]

\ P[kPa]    =  (raw/4096        + 0.1518) * exp(h/8005)/0.01059
\ | kPa -> 1000Pa, frac{a}{b} -> frac{1.0e5 a}{1.0e5 b}
\ P[Pa]   = (raw*1000/4096 + 151.8 ) * exp(h/8005)*10000*10/1059
\ | ( ) -> 100*()/100, exp(h/8005)*10000 -> AltScale
\           =  (raw*100000/4096 + 15180 )/100 * AltScale*10/1059
\           =  (raw*100000/4096 + 15180 )/10  * AltScale/1059
\ | 1 Pa -> 1/100 (hPa) -> 1/10 (hPa/10)
\ P[hPa/10] =  (raw*100000/4096  +15180 )/100 * AltScale/1059



: mpx4100.decode12 ( raw[0..4095] -- p[hPa/10] )
  s>d
  1000 1 m*/
  100 4096 m*/
  15180  m+
  AltScale 1059 m*/
  1 100 m*/
  d>s
;

\ MPX 4115 A
\ Vout = VS x (0.009 x P - 0.095)
\ Vout/VS = 0.009 x P - 0.095
\ Vout/VS + 0.095 = 0.009 x P
\ (Vout/Vs + 0.095)/0.009 = P [kPa]
: mpx4115.decode12 ( raw[0..4095] -- p[hPa/10] )
  \ P[kPa]   = (raw/4096      + 0.095) * exp(h/8005)/0.0090
  \ | kPA = 1000Pa, frac{1.0e4 a}{1.0e4 b}
  \ P[Pa]    = (raw*1000/4096 + 95)    * exp(h/8005)*10000/90
  \ | exp(h/8005)*10000 -> AltScale
  \ P[Pa]    = (raw*1000/4096 + 95)    * AltScale/90
  \ | 1 Pa -> 1/100 (hPa) -> 1/10 (hPa/10)
  \ P[hPa/10] = (raw*1000/4096 + 95)    * AltScale/900
  
  s>d
  1000 4096 m*/
  95 m+
  AltScale 900 m*/
  d>s
;
