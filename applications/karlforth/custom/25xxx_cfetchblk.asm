
;
;  25xxx_c@blk      ( addr  n  eeaddrl  eeaddrh -- )
;
;  This word copies a block of data from the serial EEPROM, starting at
;  address eeaddrl/eeaddrh, to RAM at address addr.  The block of data
;  is n bytes long.
;  
VE_25XXX_CFETCH_BLK:
    .dw $ff0b
    .db "25xxx_c@blk", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_CFETCH_BLK
XT_25XXX_CFETCH_BLK:
    .dw DO_COLON
PFA_25XXX_CFETCH_BLK:
	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_READ
	.dw XT_SPI_SEND
	.dw XT_25XXX_SENDADDR
	.dw XT_ZERO

    .dw XT_DOQDO
    .dw PFA_25XXX_CFETCH_BLK2
PFA_25XXX_CFETCH_BLK1:
	.dw XT_ZERO
	.dw XT_SPI_XCHG
	.dw XT_OVER
	.dw XT_CSTORE
	.dw XT_1PLUS
    .dw XT_DOLOOP
    .dw PFA_25XXX_CFETCH_BLK1
PFA_25XXX_CFETCH_BLK2:
	.dw XT_25XXX_DISABLE
	.dw XT_DROP
	.dw XT_EXIT



; : 25xxx_c@_blk    ( addr  n  eeaddrl  eeaddrh -- )
;   25xxx_enable
;   25XXX_READ  spi_send          \ send READ command, ignore response
;   25xxx_sendaddr                \ send address (16 or 24 bits)
;   0                             \ ( -- addr  n  0 )
;   do							  \ for all requested bytes...
;     0  spi_xchg                 \ get byte from serial EEPROM
;     over                        \ get addr to use
;     c!                          \ save the byte
;     1+                          \ bump pointer
;   loop
;   drop                          \ done with address
;   25xxx_disable
; ;

