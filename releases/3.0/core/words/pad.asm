; ( -- addr ) System Value
; R( -- )
; Address of the temporary scratch buffer. 
VE_PAD:
    .db $03, "pad"
    .dw VE_HEAD
    .set VE_HEAD = VE_PAD
XT_PAD:
    .dw DO_COLON
PFA_PAD:
    .dw XT_HEAP
    .dw XT_EXIT
