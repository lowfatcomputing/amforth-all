; ( -- addr ) Control Structure
; R( -- )
; start do .. [+]loop
VE_QDO:
    .dw $0003
    .db "?do",0
    .dw VE_HEAD
    .set VE_HEAD = VE_QDO
XT_QDO:
    .dw DO_COLON
PFA_QDO:
    .dw XT_COMPILE
    .dw XT_DOQDO
    .dw XT_GMARK
    .dw XT_LMARK
    .dw XT_EXIT
