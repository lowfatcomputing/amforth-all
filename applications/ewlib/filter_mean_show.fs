\ 2011-10-30  ew  ewlib/filter_mean_show.fs

\ .F1  one decimal
\ .F2  two decimals

: .F1 ( id max mean min N>0 | id 0 -- )
  dup if
    5 pick .id            \ id:
    decimal
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
    decimal
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
