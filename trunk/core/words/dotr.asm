; ( n w -- ) Numeric IO
; R( -- )
; single cell numeric output
VE_DOTR:
    .dw $ff02
    .db ".r"
    .dw VE_HEAD
    .set VE_HEAD = VE_DOTR
XT_DOTR:
    .dw DO_COLON
PFA_DOTR:
    .dw XT_TO_R
    .dw XT_S2D
    .dw XT_R_FROM
    .dw XT_DDOTR
    .dw XT_EXIT
; : .r        ( s n -- )  >r s>d r> d.r ;