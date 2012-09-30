\ shamelessly stolen from gforth


0 constant case ( compilation  -- case-sys ; run-time  -- )
    immediate

: of ( compilation  -- of-sys ; run-time x1 x2 -- |x1 )
    \ !! the implementation does not match the stack effect
    1+ >r
    postpone over postpone = postpone if postpone drop
    r> ; immediate

: endof ( compilation case-sys1 of-sys -- case-sys2 ; run-time  -- )
    >r postpone else r> ; immediate

: default: postpone drop ; immediate
: endcase ( compilation case-sys -- ; run-time x -- )
    \ postpone drop
    0 ?do postpone then loop ; immediate

\ : endcase ( compilation case-sys -- ; run-time x -- )
\   postpone drop
\   0 ?do postpone then loop ; immediate
