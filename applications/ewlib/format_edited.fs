\ 2008-10-21 EW   format.fs

\ _always_ display sign '+' or '-'
: sign! 0 < if
    [ char - ] literal
  else
    [ char + ] literal
  then hold
;

\ +.f, d+.f
\   always display sign [+-],
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

