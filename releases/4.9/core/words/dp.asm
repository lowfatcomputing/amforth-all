; ( -- f-addr ) 
; System Value
; address of the next free dictionary cell
VE_DP:
    .dw $ff02
    .db "dp"
    .dw VE_HEAD
    .set VE_HEAD = VE_DP
XT_DP:
    .dw PFA_DOVALUE
PFA_DP:
    .dw EE_DP
    .dw XT_FETCHE
    .dw XT_STOREE
