\ 2009-03-25  EW
\ back from lib/ans94/2x.frt

\ m*/ ( d1 +n1 n2 -- d2 )
\ d2 = (d1*n1)/n2
\ stolen from gforth
: -rot  rot rot ;
: m*/
  >r s>d >r abs -rot s>d r> xor r> swap >r >r
  dabs rot tuck um* 2swap um* swap >r 0 d+ r>
  -rot i um/mod -rot r> um/mod nip
  swap
  r>
  if dnegate then
;
