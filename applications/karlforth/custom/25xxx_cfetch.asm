
;
;  25xxx_c@      ( addrl addrh -- c)
;
;  This word enables the serial EEPROM, sends the address in TOS/NOS,
;  fetches the byte at that address, disables the EEPROM, and returns
;  the byte in TOS.
;

VE_25XXX_CFETCH:
    .dw $ff08
    .db "25xxx_c@"
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_CFETCH
XT_25XXX_CFETCH:
    .dw DO_COLON
PFA_25XXX_CFETCH:
	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_READ
	.dw XT_SPI_SEND				; ( addrl addrh )
	.dw XT_25XXX_SENDADDR
	.dw XT_ZERO
	.dw XT_SPI_XCHG
	.dw XT_25XXX_DISABLE
	.dw XT_EXIT



; : see_c@      ( addrl addrh -- c )    \ returns byte at 32-bit address in TOS
;   25xxx_enable
;   25XXX_READ  spi_send          \ send READ command, ignore response
;   25xxx_sendaddr				  \ send address (16 or 24 bits)
;   0  spi_xchg                   \ send null byte, response is in TOS
;   25xxx_disable
; ;

