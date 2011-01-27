


VE_25XXX_INIT:
    .dw $ff0a
    .db "25xxx_init"
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_INIT
XT_25XXX_INIT:
    .dw DO_COLON
PFA_25XXX_INIT:
    .dw XT_SPI_INIT
	.dw XT_25XXX_CS_A_DDR
	.dw XT_CFETCH
	.dw XT_25XXX_CS_A_MASK
	.dw XT_OR
	.dw XT_25XXX_CS_A_DDR
	.dw XT_CSTORE
	.dw XT_25XXX_ENABLE

	.dw XT_25XXX_RDID
	.dw XT_SPI_XCHG
	.dw XT_DROP

	.dw XT_ZERO
	.dw XT_SPI_XCHG
	.dw XT_DROP

	.dw XT_ZERO
	.dw XT_SPI_XCHG
	.dw XT_DROP

	.dw XT_ZERO
	.dw XT_SPI_XCHG
	.dw XT_DROP

	.dw XT_25XXX_DISABLE
	.dw XT_EXIT


; \
; \  You must invoke 25XXX_init before using any of the serial EEPROM
; \  access words.
; \
;
; : 25xxx_init    ( -- )          \ initialize SPI and I/O ports for accessing serial EEPROM
;   spi_init
;   25XXX_CS_A_DDR  c@
;   25XXX_CS_A_MASK  or           \ need to make CS an output
;   25XXX_CS_A_DDR  c!
;   25xxx_enable
;   25XXX_RDID  spi_xchg  drop    \ Microchip 25LCxxx only; take chip out of deep power-down
;   0  spi_xchg  drop             \ need to send dummy 16-bit addr, ignore response
;   0  spi_xchg  drop
;   0  spi_xchg  drop             \ one last null byte, Microchip devices will send ID, ignore it
;   25xxx_disable
; ;

