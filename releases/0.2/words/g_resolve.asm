; ( limit counter -- )
; R: ( -- -- limit counter ) == loop-sys
VE_GRESOLVE:
    .db 8, ">resolve",0
    .dw VE_HEAD
    .set VE_HEAD = VE_GRESOLVE
XT_GRESOLVE:
    .dw DO_COLON
PFA_GRESOLVE:
    .dw XT_HERE
    .dw XT_SWAP
    .dw XT_ISTORE
    .dw XT_EXIT
