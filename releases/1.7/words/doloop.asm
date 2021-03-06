; ( -- )
; R( limit counter  -- (limit counter+1'|)
; runtime of loop
;VE_DOLOOP:
;    .db 6, "(loop)", 0
;    .dw VE_HEAD
;    .set VE_HEAD = VE_DOLOOP
XT_DOLOOP:
    .dw PFA_DOLOOP
PFA_DOLOOP:
    pop zh
    pop zl
    adiw zl,1
    pop temp1
    pop temp0
    cp zl, temp0
    cpc zh, temp1
    brge PFA_DOLOOP1 ; exit loop
    ; next iteration
    push temp0
    push temp1
    push zl
    push zh
    rjmp PFA_DOBRANCH ; read next cell from dictionary and jump to its destination
PFA_DOLOOP1:
    adiw xl,1
    rjmp DO_NEXT
