; (n1 n2 n3 -- n4) Arithmetics
; R( -- )
; signed multiply and division with double precision intermediate
VE_STARSLASH:
    .db $02, "*/",0
    .dw VE_HEAD
    .set VE_HEAD = VE_STARSLASH
XT_STARSLASH:
    .dw DO_COLON
PFA_STARSLASH:
    .dw XT_STARSLASHMOD
    .dw XT_SWAP
    .dw XT_DROP
    .dw XT_EXIT
    