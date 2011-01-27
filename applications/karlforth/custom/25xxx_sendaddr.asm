

;
;  25xxx_sendaddr      ( addrl addrh -- )
;
;  Send address in TOS (2 words) to serial EEPROM.  The EEPROM must
;  already be selected and the necessary command (READ or WRITE) already
;  sent.
;
;  This word uses the value in assembler equate SEEP_ADDR_BYTES to
;  determine how many address bytes to send to the device; possible
;  options are 2 bytes (16-bit EEPROMs) or 3 bytes (24-bit EEPROMs).
;

VE_25XXX_SENDADDR:
    .dw $ff0e
    .db "25xxx_sendaddr"
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_SENDADDR
XT_25XXX_SENDADDR:
    .dw DO_COLON
PFA_25XXX_SENDADDR:

	.if SEE_ADDR_BYTES == 2		; if EEPROM uses 16-bit addressing, drop high word
	.dw XT_DROP
	.endif

	.if SEE_ADDR_BYTES == 3		; if EEPROM uses 24-bit addressing, use low half of high word
	.dw XT_SPI_SEND
	.endif

	.dw XT_DUP
	.dw XT_BYTESWAP
	.dw XT_SPI_SEND
	.dw XT_SPI_SEND
	.dw XT_EXIT
