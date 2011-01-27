


VE_25XXX_CSTORE:
    .dw $ff08
    .db "25xxx_c!"
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_CSTORE
XT_25XXX_CSTORE:
    .dw DO_COLON
PFA_25XXX_CSTORE:
	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_WREN
	.dw XT_SPI_SEND
	.dw XT_25XXX_DISABLE

	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_WRITE
	.dw XT_SPI_SEND				; ( -- c addrl addrh )
	.dw XT_25XXX_SENDADDR		; ( -- c )
	.dw XT_SPI_SEND				; ( -- )
	.dw XT_25XXX_DISABLE
	.dw XT_25XXX_WAIT_RDY
	.dw XT_EXIT





; : 25xxx_c!    ( c  addr  -- )   \ writes char in NOS to serial EEPROM, address in TOS
;   25xxx_enable
;   25XXX_WREN  spi_send          \ send enable-write command, ignore response
;   25xxx_disable
;   
;   25xxx_enable
;   25XXX_WRITE  spi_send         \ send write command, ignore response
;   25xxx_sendaddr				  \ send addr (16 or 24 bits)
;   spi_send			          \ write byte
;   25xxx_disable
;   25xxx_wait_rdy
; ;


