\ 2008-10-18 EW
\ 2010-01-23 EW  change for sensor2 layout
\ 2011-01-15 EW  change for amforth 4.2 (heap -> here)
\ 
\ needs ans94/2x.frt
\ 
\ --------------------------------------------------
\ accumulate values, publish min|mean|max, reset
\ for every value to be collected, needs
\   1 double word to sum up \Sum(x)
\   1 word to count entries N
\   1 word for min
\   1 word for max
\ publish (eval)
\   minX, maxX, SumX/nX
\ reset
\   SumX=0, nX=0
\ addup
\   if nX == 0 { minX=x; maxX=x; }
\   SumX += x;
\   nX++;
\   minX = min ( minX, x );
\   maxX = max ( maxX, x );

\ RAM layout (cells)
\   0  mean_sum
\   2  mean_N
\   3  mean_min
\   4  mean_max

\ named filter
\ : filter_mean:
\   create ( id -- )
\     ,      \ store id in dictionary entry
\     here , \ store next RAM addr
\     5 cells allot \ create RAM space
\   does>  ( -- id ram_addr )
\     dup i@
\     swap 1+ i@
\ ;
: filter_mean,
    here , \ store next RAM addr
    5 cells allot \ create RAM space
;
  
\ offsets into ram_addr
0 constant mean_sum     : mean_sum+ ( mean_sum cells + ) noop ;
2 constant mean_N       : mean_N+     mean_N   cells + ;
3 constant mean_min     : mean_min+   mean_min cells + ;
4 constant mean_max     : mean_max+   mean_max cells + ;

\ reset filter
: mean_reset ( ram_addr -- )
  5 cells erase
;

: mean_eval ( ram_addr -- max d.sum min N>0 | 0 )
  >r
  r@ mean_N+ @  0=  if
    0 \ N=0, no data
  else
    r@ mean_max+  @ \ mean_max
    r@           2@ \ mean_sum
    1
    r@ mean_N+    @ \ mean_N
    m*/                   \ mean_sum*1/mean_N
    r@ mean_min+  @ \ mean_min
    r@ mean_N+    @ \ mean_N
  then
  r> drop \ ram_addr
;

: mean_addup ( x ram_addr -- )
  >r
  r@ mean_N+ @  0=  if
    dup  r@ mean_min+  !
    dup  r@ mean_max+  !
  else
    dup  r@ mean_min+ @  <  if dup  r@ mean_min+  !  then
    dup  r@ mean_max+ @  >  if dup  r@ mean_max+  !  then
  then
  s>d  r@ mean_sum+ 2@  d+  r@ mean_sum+ 2! \ consume x
  1  r@ mean_N+  +!
  r> drop \ ram_addr
;

\ --- show collected values --------------------------------
\ .F0  no comma and trailing decimals
\ .F1  one decimal
\ .F2  two decimals

: .F0 ( id max mean min N>0 | id 0 -- )
  dup if
    5 pick .id            \ id:
    1    .r [char] , emit \ N,
    1    .r [char] , emit \ min,
    1 du0.r [char] , emit \ d.mean,
    1    .r               \ max
    drop \ id
  else
    drop \ N
    .id ." *,*,*,*"
  then
;
: .F1 ( id max mean min N>0 | id 0 -- )
  dup if
    5 pick .id            \ id:
\   1 .r    [char] , emit \ N,
s>d 1 du0.r [char] , emit \ N,
    1 +.f   [char] , emit \ min,
    1 d+.f  [char] , emit \ d.mean,
    1 +.f                 \ max
    drop \ id
  else
    drop \ N
    .id ." *,*,*,*"
  then
;
: .F2 ( id max mean min N>0 | id 0 -- )
  dup if
    5 pick .id            \ id:
\   1 .r    [char] , emit \ N,
s>d 1 du0.r [char] , emit \ N,
    2 +.f   [char] , emit \ min,
    2 d+.f  [char] , emit \ d.mean,
    2 +.f                 \ max
    drop \ id
  else
    drop \ N
    .id ." *,*,*,*"
  then
;
