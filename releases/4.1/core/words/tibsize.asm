; ( -- n ) System Value
; R( -- )
; terminal input buffer size
VE_TIBSIZE:
    .dw $ff07
    .db "tibsize",0
    .dw VE_HEAD
    .set VE_HEAD = VE_TIBSIZE
XT_TIBSIZE:
    .dw PFA_DOVALUE
PFA_TIBSIZE:
    .dw EE_TIBSIZE
