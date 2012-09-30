\ 2008-10-21 EW   format.fs

\ _always_ display sign '+' or '-'
: sign!
  0 < if
    [ char - ] literal
  else
    [ char + ] literal
  then
  hold
;

\ .i, d.i
\   integer display
\   no leading/trailing spaces/zeros
\   only negative sign
: d.i   ( d -- )
  dup >r dabs <# #s r> sign #> type ;
: du.i  ( d -- )
                      <# #s #> type ;
: .i    ( x -- )  s>d d.i ;
: u.i   ( x -- )  s>d du.i ;

\ +.f, d+.f
\   always display sign [+-]
\   scaled to n digits after '.'
\   no leading/trailing zeros/spaces
: d+.f  ( d n -- )
  over >r  >r  dabs
  <#  r> 0 ?do # loop
  [ char . ] literal hold
  #s  r> sign!  #>
  type
;
: +.f  ( x n -- )
  swap s>d rot  d+.f
;

\ .f, d.f
\   if negative display sign [+-],
\   scaled to n digits after '.'
\   no leading/trailing zeros/spaces
: d.f  ( d n -- )
  over >r  >r  dabs
  <#  r> 0 ?do # loop
  [ char . ] literal hold
  #s  r> sign  #>
  type
;
: .f  ( x n -- )
  swap s>d rot  d.f
;


: du0.r ( d n -- )
  <# 1- 0 ?do # loop #s #> type
;
