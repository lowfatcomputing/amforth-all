\ 2011-06-02  EW
\ print out a datablock starting at addr
\ with prec decimal places.
\ derived from .F1 .F2

: .Dn ( addr prec -- )
  >r
  hex
  dup @ 4 u0.r colon    \ ID_station+sensor
  decimal
  dup 2 + @ s>d 1 du0.r  comma \ N
  dup 4 + @ r@ +.f       comma \ min
  dup 6 + @ r@ +.f       comma \ mean
  dup 8 + @ r> +.f             \ max
  drop
;
  

\ fin