; ( -- addr ) 
; System Value
; address of the next free data space (RAM) cell
VE_HERE:
    .dw $ff04
    .db "here"
    .dw VE_HEAD
    .set VE_HEAD = VE_HERE
XT_HERE:
    .dw PFA_DOVALUE
PFA_HERE:
    .dw EE_HERE
    .dw XT_FETCHE
    .dw XT_STOREE
