


VE_SAVE_SYSTEM:
    .dw $ff0b
    .db "save_system", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_SAVE_SYSTEM
XT_SAVE_SYSTEM:
    .dw DO_COLON
PFA_SAVE_SYSTEM:
	.dw XT_25XXX_INIT
	.dw XT_SAVE_EEPROM
	.dw XT_SAVE_FLASH
	.dw XT_DOLITERAL
	.dw SEE_VALID_FLAG				; valid flag, must match expected value in bootloader code!
	.dw XT_ZERO
	.dw XT_ZERO						; always use 24-bit addressing
	.dw XT_25XXX_CSTORE
	.dw XT_EXIT


; : save_system
;   25xxx_init
;   save_eeprom
;   save_flash
;   [ hex ] 5a  0  25xxx_c!                 \ mark serial EEPROM as valid
; ;
  
