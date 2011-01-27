;
;  25xxx_prot      ( lvl -- )
;
;  This word sets the protection bits of the 25xxx serial
;  EEPROM, based on the value lvl in TOS.  Legal values are:
;
;  0 = no areas of serial EEPROM are write-protected,
;  1 = top 1/4 of serial EEPROM is write-protected,
;  2 = top 1/2 of serial EEPROM is write-protected,
;  3 = all of serial EEPROM is write-protected.
;


VE_25XXX_PROT:
    .dw $ff0a
    .db "25xxx_prot"
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_PROT
XT_25XXX_PROT:
    .dw DO_COLON
PFA_25XXX_PROT:
	.dw XT_DOLITERAL
	.dw 3
	.dw XT_AND				; keep lvl in legal range (0-3)
	.dw XT_2STAR			; need to move left 2 bit positions
	.dw XT_2STAR			; lvl now = 0000 bb00; WPEN must = 0!

	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_WREN
	.dw XT_SPI_SEND
	.dw XT_25XXX_DISABLE

	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_WRSR
	.dw XT_SPI_SEND			; ( -- lvl )
	.dw XT_SPI_SEND			; ( -- )
	.dw XT_25XXX_DISABLE
	.dw XT_25XXX_WAIT_RDY
	.dw XT_EXIT



