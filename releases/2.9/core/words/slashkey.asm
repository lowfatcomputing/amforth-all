; ( -- ) Character IO
; R( -- )
; fetch /key vector and execute it, should turn off the sender of key events
VE_SLASHKEY:
    .db $04, "/key",0
    .dw VE_HEAD
    .set VE_HEAD = VE_SLASHKEY
XT_SLASHKEY:
    .dw PFA_DODEFER
PFA_SLASHKEY:
    .dw 22
    .dw XT_UDEFERFETCH
    .dw XT_UDEFERSTORE
