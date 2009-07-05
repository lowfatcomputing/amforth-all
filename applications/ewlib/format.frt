\ 2008-10-21 EW   format.fs

\ library=ewlib::format

\ module=sign!
\ _always_ display sign '+' or '-'
: sign! 0 < if [ char - ] literal else [ char + ] literal then hold ;
\ endmodule

\ .i, d.i
\   integer display, no leading/trailing spaces/zeros
\   only negative sign
\ module=d.i
\ from ewlib::format require sign!
: d.i   ( d -- )  dup >r dabs <# #s r> sign #> type ;
\ endmodule
\ module=.i
\ from ewlib::format require d.i
: .i    ( x -- )  s>d d.i ;
\ endmodule

\ +.f, d+.f
\   always display sign [+-], scaled to n digits after '.'
\   no leading/trailing zeros/spaces
\ module=d+.f
\ from ewlib::format require sign!
: d+.f  ( d n -- )
  over >r  >r  dabs
  <#  r> 0 ?do # loop  [ char . ] literal hold  #s  r> sign!  #>
  type
;
\ endmodule
\ module=+.f
\ from ewlib::format require d+.f
: +.f  ( x n -- )
  swap s>d rot  d+.f
;
\ endmodule

\ module=du0.r
\
: du0.r ( d n -- )
  <# 1- 0 ?do # loop #s #> type
;