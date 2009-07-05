\ 2007-12-26 EW   timeup.fs
\ words:

decimal
1   constant cycles/tick
128 constant ticks/sec

variable tuFlags    0 tuFlags !
variable newtimer
variable lastsec

\ create   Counts     8 cells allot
variable Counts     7 cells allot
\ Counts 8 clear

\ create   Limits     8 allot
variable Limits     6 allot

\ length of months, months: 0..11
\ allot: always in RAM
\ create MaxDay 12 allot
\ variable MaxDay 10 allot
create MaxDay 31 , 28 , 31 , 30 , 31 , 30 ,
              31 , 31 , 30 , 31 , 30 , 31 ,

: tick  ( -- addr ) Counts ;
: sec   ( -- addr ) Counts 1 cells + ;
: min   ( -- addr ) Counts 2 cells + ;
: hour  ( -- addr ) Counts 3 cells + ;
: day   ( -- addr ) Counts 4 cells + ;
: month ( -- addr ) Counts 5 cells + ;
: year  ( -- addr ) Counts 6 cells + ;

decimal
: leap_year? ( yyyy -- t/f )
  dup    4 mod 0=
  over 100 mod 0<> and
  swap 400 mod 0=  or
;
: length_of_month ( year month -- maxday )
  dup 1-                \ array starts at 0
\  MaxDay + c@
  MaxDay + i@
  swap 2 = if           \ if month == 2
    swap leap_year? if  \   if leap_year
      1+                \     month += 1
    then
  else                  \ else
    swap drop           \   remove year
  then
;

: tickover? ( -- f )
  newtimer @ timer2 @ - 0< ;

: init-timeup
  0 tuFlags !
  Counts 7 cells  0 fill
\ limits
  ticks/sec Limits c!
  60    Limits 1 + c!
  60    Limits 2 + c!
  24    Limits 3 + c!
  31    Limits 4 + c!
  12    Limits 5 + c!
;

: timeup ( -- )
  cycles/tick newtimer +!
  0 bv tuFlags fset             \ tickflag++
  1 Counts +!                   \ tick++

  6 0 do
    i cells Counts + @   1+     \ Counts[i]+1
    i       Limits + c@         \ Limits[i]
    > if                        \ if C[i]+1 > L[i]
      0  i cells Counts +  !    \ . C[i]=0
      i 1+ bv tuFlags fset      \ . F[i+1]++
      1 i 1+ cells Counts + +!  \ . C[i+1]++
    then                        \ fi
  loop
;

: DT.set ( Y m d H M S -- )
  sec ! min ! hour !
  1- day ! 1- month ! year !
;
: DT.get ( -- S M H d m Y )
  sec @ min @ hour @
  day @ 1+ month @ 1+ year @
;
: DT.show ( S M H d m Y -- )
  ( cr )
  4 u0.r  2 u0.r  2 u0.r  45 emit ( "-" )
  2 u0.r  2 u0.r  2 u0.r  ( 58 emit  ":" )
;
