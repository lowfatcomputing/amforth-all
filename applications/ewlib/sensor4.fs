\ 2010-01-24  EW  ewlib/sensor2.fs
\ 2011-01-15  EW  ewlib/sensor4.fs (amforth 4.2)
\ 2011-05-29      i@,i! -> @i,!i
\
\ next generation of sensor object
\ this version is created to be referenced via a list only,
\ no named objects any more.

\ words:
\   sensor4: ( )
\   s3.show ( addr -- )
\   s3.collect ( addr -- )
\   s3.reset ( addr -- )
\   s3.eval ( addr -- )
\   s3.eval+reset ( addr -- )
decimal
: sensor4: ( 's_descr 's_unit 'f_show 'f_eval 'f_addup )
\            'f_reset 'filter_X, 'f_decode 'f_get busaddr id -- addr )
  dp >r
  ,            \  0: id  ->
  ,            \  1: bus-addr ->
  ,            \  2: 'f_get ->
  ,            \  3: 'f_decode ->
  execute      \  4: 'filter_X, -> allot RAM
  ,            \  5: 'filter_reset
  ,            \  6: 'filter_addup
  ,            \  7: 'filter_eval
  ,            \  8: '.F1, '.F2 ... ( show values )
  ,            \  9: ' s" Größe/Einheit"  ( T[C] rF[%] p[hPa] )
  ,            \ 10: ' s" Beschreibung"   ( z.B. "innen", "solar vorlauf" ...)
  r>       \ addr
;
\ index into structure, only to make this code look cleaner
: s4>id          @i ;
: s4>addr     1+ @i ;
: s4>'get    2 + @i ;
: s4>'decode 3 + @i ;

: s4>'filter 4 + @i ;
: s4>'f_reset 5 + @i ;
: s4>'f_add  6 + @i ;
: s4>'f_eval 7 + @i ;

: s4>'show   8 + @i ;
: s4>"unit   9 + @i ;
: s4>"label 10 + @i ;

\ methods on items pointed to via the list
\ must not produce any entries on the stack!!!
\ otherwise list.walk will not know it's pointers any more.
: s4.show ( addr -- )
  >r
  r@ s4>id   decimal 4 u0.r colon
  r@ s4>addr hex     4 u0.r colon
  r@ s4>"unit        icount itype colon
  r@ s4>"label       icount itype colon
  r> drop                   cr
;


: s4.collect ( addr -- )
  >r
  r@ s4>addr                  \ -- bus-addr
  r@ s4>'get execute          \ -- xN..x1 0 | not 0
  0= if
    r@ s4>'decode  execute    \ -- X
    r@ s4>'filter
    r@ s4>'f_add   execute    \ --
  then
  r> drop
;

: s4.reset ( addr -- )
  >r
  r@ s4>'filter
  r@ s4>'f_reset execute
  r> drop
;
: s4.eval ( addr -- )
  cr dot
  >r
  r@ s4>id                ( -- id )
  r@ s4>'filter
  r@ s4>'f_eval execute   ( -- id max d.sum min N>0 | 0 )
  r@ s4>'show   execute
  r> drop
;
: s4.eval+reset ( addr -- )
  >r
  r@ s4>id                ( -- id )
  r@ s4>'filter
  r@ s4>'f_eval  execute  ( -- id max d.sum min N>0 | 0 )
  r@ s4>'show    execute
  r@ s4>'filter
  r@ s4>'f_reset execute
  r> drop
;

