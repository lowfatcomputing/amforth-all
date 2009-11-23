\ Conway's Game of Life, or Occam's Razor Dulled

marker Genesis

\ ANS Forth this life is remains and
1 chars constant /Char
: C+!  ( char c-addr -- )  dup >r  c@ +  r> c! ;

\ the universal pattern
25 constant How-Deep
80 constant How-Wide
How-Wide How-Deep *  1-  \ 1- prevents scrolling on my screen
   constant Homes

\ world wrap
: World
   create  ( -- )  Homes chars allot
    does>  ( u -- c-addr )  swap Homes +  Homes mod  chars + ;

World old
World new

\ biostatistics

\ begin hexadecimal numbering
hex  \ hex xy : x holds life , y holds neighbors count

10 constant Alive  \ 0y = not alive

\ Conway's rules:
\ a life depends on the number of its next-door neighbors

\ it dies if it has fewer than 2 neighbors
: Lonely  ( char -- flag )  12 < ;

\ it dies if it has more than 3 neighbors
: Crowded  ( char -- flag )  13 > ;

: -Sustaining  ( char -- flag )
    dup Lonely  swap Crowded  or ;

\ it is born if it has exactly 3 neighbors
: Quickening  ( char -- flag )
    03 = ;

\ back to decimal
decimal

\ compass points
: N  ( i -- j )  How-Wide - ;
: S  ( i -- j )  How-Wide + ;
: E  ( i -- j )  1+ ;
: W  ( i -- j )  1- ;

\ census
: Home+!  ( -1|1 i -- )  >r  Alive *  r> new C+! ;

: Neighbors+!  ( -1|0|1 i -- )
   2dup N W new C+!  2dup N new C+!  2dup N E new C+!
   2dup   W new C+!  (     i      )  2dup   E new C+!
   2dup S W new C+!  2dup S new C+!       S E new C+! ;

: Bureau-of-Vital-Statistics ( -1|1 i -- )
   2dup Home+!  Neighbors+! ;

\ mortal coils
char ? constant Soul
    bl constant Body

\ at home
: Home  ( char i -- )  How-Wide /mod at-xy  emit ;

\ changes, changes
: Is-Born  ( i -- )
   Soul over Home
   1 swap Bureau-of-Vital-Statistics ;
: Dies  ( i -- )
   Body over Home
   -1 swap Bureau-of-Vital-Statistics ;

\ the one and the many
: One  ( c-addr -- i )
   0 old -  /Char / ;
: Everything  ( -- )
   0 old  Homes
   begin  dup
   while  over c@  dup Alive and
      if   -Sustaining if  over One Dies     then
      else  Quickening if  over One Is-Born  then then
      1 /string
   repeat  2drop
   How-Wide 1- How-Deep 1- at-xy ;

\ in the beginning
: Void  ( -- )  
   0 old  Homes blank ;

\ spirit
: Voice  ( -- c-addr u )
   page
   ." Say: "  0 new  dup Homes accept ;

\ subtlety
: Serpent  ( -- )
   0 2 at-xy  ." Press a key for knowledge."  key drop
   0 2 at-xy  ." Press space to re-start, Esc to escape life." ;

\ the primal state
: Innocence  ( -- )
   Homes 0
   do  i new c@  Alive /  i Neighbors+!  loop ;

\ children become parents
: Passes  ( -- )  0 new  0 old  Homes  cmove ;

\ a garden
: Paradise  ( c-addr u -- )
   >r  How-Deep How-Wide *  How-Deep 2 mod 0=  How-Wide and -
   r@  -  2/  old
   r>  cmove
   0 old  Homes 0
   do  count bl <>
       dup if  Soul I Home then
       Alive and  i new c!
   loop  drop
   Serpent
   Innocence Passes ;

: Creation  ( -- )  Void Voice Paradise ;

\ the human element

1000 value Ideas
: Dreams  ( -- )  Ideas ms ;

1000 constant Images
: Meditation  ( -- )  Images ms ;

\ free will
: Action  ( -- char )
   key? dup 
   if  drop key
       dup bl = if  Creation  then
   then ;

\ environmental dependence
27 constant Escape

\ history
: Goes-On  ( -- )
   begin  Everything Passes
          Dreams Action Meditation
          Escape = until ;

\ a vision
: Life  ( -- )  Creation Goes-On ;

Life

\ 950724 + 970703 +

\ Copyright 1995 Leo Wong
\ hello@albany.net
\ http://www.albany.net/~hello/
