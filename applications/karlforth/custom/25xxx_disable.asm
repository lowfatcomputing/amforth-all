

VE_25XXX_DISABLE:
    .dw $ff0d
    .db "25xxx_disable", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_DISABLE
XT_25XXX_DISABLE:
    .dw DO_COLON
PFA_25XXX_DISABLE:
    .dw XT_25XXX_CS_A_MASK
	.dw XT_25XXX_CS_A_PORT
	.dw XT_CFETCH
	.dw XT_OR
	.dw XT_25XXX_CS_A_PORT
	.dw XT_CSTORE
	.dw XT_EXIT



; : 25xxx_disable                  \ raise serial EEPROM chip-select line high
;   25XXX_CS_A_MASK
;   25XXX_CS_A_PORT  c@
;   or
;   25XXX_CS_A_PORT  c!
; ;




