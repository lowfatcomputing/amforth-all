; ( n1 n2 -- n2 n1) Stack
; R( -- )
; stack manipulation
VE_SWAP:
    .dw $ff04
    .db "swap"
    .dw VE_HEAD
    .set VE_HEAD = VE_SWAP
XT_SWAP:
    .dw PFA_SWAP
PFA_SWAP:
    movw temp0, tosl
    loadtos
    st -Y, temp1
    st -Y, temp0
    rjmp DO_NEXT
