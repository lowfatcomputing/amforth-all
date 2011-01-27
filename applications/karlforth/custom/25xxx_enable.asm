

VE_25XXX_ENABLE:
    .dw $ff0c
    .db "25xxx_enable"
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_ENABLE
XT_25XXX_ENABLE:
    .dw DO_COLON
PFA_25XXX_ENABLE:
    .dw XT_25XXX_CS_A_MASK
	.dw XT_INVERT
	.dw XT_25XXX_CS_A_PORT
	.dw XT_CFETCH
	.dw XT_AND
	.dw XT_25XXX_CS_A_PORT
	.dw XT_CSTORE
	.dw XT_EXIT




; : 25xxx_enable    ( -- )         \ pull serial EEPROM chip-select line low
;   25XXX_CS_A_MASK  invert
;   25XXX_CS_A_PORT  c@
;   and
;   25XXX_CS_A_PORT  c!
; ;


