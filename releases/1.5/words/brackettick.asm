; ( -- addr )
; R( -- )
VE_BRACKETTICK:
    .db $83, "[']"
    .dw VE_HEAD
    .set VE_HEAD = VE_BRACKETTICK
XT_BRACKETTICK:
    .dw DO_COLON
PFA_BRACKETTICK:
    .dw XT_DOLITERAL
    .dw XT_DOLITERAL
    .dw XT_COMMA
    .dw XT_TICK
    .dw XT_COMMA
    .dw XT_EXIT
