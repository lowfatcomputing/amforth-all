; ( --  )
VE_LBRACKET:
    .db $81, "["
    .dw VE_HEAD
    .set VE_HEAD = VE_LBRACKET
XT_LBRACKET:
    .dw DO_COLON
PFA_LBRACKET:
    .dw XT_DOLITERAL
    .dw 0
    .dw XT_STATE
    .dw XT_STORE
    .dw XT_EXIT
