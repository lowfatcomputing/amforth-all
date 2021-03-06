;;;;;;;;;;;;;;;;;;
; ( c -- )
VE_HOLD:
    .db $04, "hold",0
    .dw VE_LATEST
    .set VE_LATEST = VE_HOLD
XT_HOLD:
    .dw DO_COLON
PFA_HOLD:
    ; prepends lower byte (character) from tos to counted string in HLD
    
    ; move characters to the right
    .dw XT_HLD ; from
    .dw XT_1PLUS
    .dw XT_DUP
    .dw XT_1PLUS ; to
    .dw XT_HLD
    .dw XT_CFETCH ; number bytes
    .dw XT_CMOVE_G
    ; increase string length
    .dw XT_HLD
    .dw XT_CFETCH
    .dw XT_1PLUS
    .dw XT_HLD
    .dw XT_CSTORE
    ; store character as the first position
    .dw XT_HLD
    .dw XT_1PLUS
    .dw XT_CSTORE
    .dw XT_EXIT
