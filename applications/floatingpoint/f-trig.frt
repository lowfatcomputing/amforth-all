\ fsin fcos ftan library
\ amforth 4.0
\ Pito 25-9-2010
\ v 3.0.
\ based on 4tH library by J.L. Bezemer
\ and amforth's sinus.frt example
\ needs Leon's flib (and Pito's asm flib v1.1 for speed)
-fsincostan
marker -fsincostan

\ the original JLB (taylor) does not work, a bug?
: >taylor fdup f* fover ;        \ setup for Taylor series
: _taylor fover f* frot fover ;
: +taylor f/ f+ frot frot ;      \ add Taylor iteration
: -taylor f/ f- frot frot ;      \ subtract Taylor iteration

\ put x in RADIANS within 2pi range
: >range                              
$0FDB $4049 fdup f+                  ( x pi2 )
fover fover f/                       ( x pi2 x/pi2 )
ffloor fover f*                      ( x pi2 mod )
frot fswap f-                        ( pi2 mod )
$0FDB $4049 fover                    ( pi2 mod pi mod )
f< if fswap f- else fnip then ;

: _fsin 
fdup >taylor                            ( x x2 x )
_taylor $0000 $40C0 -taylor                 ( x-3 x2 x3 )
_taylor $0000 $42F0 +taylor                 ( x+5 x2 x5 )
_taylor $8000 $459D -taylor                 ( x-7 x2 x7 )
_taylor $3000 $48B1 +taylor                 ( x+9 x2 x9 )
_taylor $4540 $4C18 -taylor                 ( x-11 x2 x11 )
_taylor $9466 $4FB9 +taylor                 ( x+13 x2 x13 )
_taylor $3BBC $5398 -taylor                 ( x-15 x2 x15 )
_taylor $BF77 $57A1 +taylor                 ( x+17 x2 x17 )
_taylor $15CA $5BD8 -taylor                 ( x-19 x2 x19 )
fdrop fdrop ;                                   ( x-19 ) 

\ calculate fsin
: fsin  ( RAD -- sinus )
fdup f0< >r  fabs
>range 
fdup $0FDB $4049 f> if $0FDB $4049 f- 1 >r else 0 >r then 
fdup  $0FDB $3FC9 f> if $0FDB $4049 fswap f- then  
_fsin 
r> if fnegate then 
r> if fnegate then ;

\ calculate fcos        
: fcos   ( RAD -- cosinus )        
$0FDB $3FC9 f+ fsin ;

\ calculate ftan
: ftan ( RAD -- tangens )  
fdup fsin fswap fcos 
fdup f0= if abort else f/  then ;   

