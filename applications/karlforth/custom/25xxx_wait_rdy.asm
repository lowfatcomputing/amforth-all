


VE_25XXX_WAIT_RDY:
    .dw $ff0e
    .db "25xxx_wait_rdy"
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_WAIT_RDY
XT_25XXX_WAIT_RDY:
    .dw DO_COLON
PFA_25XXX_WAIT_RDY:
.if 0 == 1						; this word is a no-op if the 25xxx device is an FRAM
	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_RDSR
	.dw XT_SPI_XCHG
	.dw XT_DROP
	.dw XT_ZERO
	.dw XT_SPI_XCHG
	.dw XT_25XXX_DISABLE
	.dw XT_DOLITERAL
	.dw $0001					; WIP bit is bit 0
	.dw XT_AND					; leave only WIP bit
	.dw XT_DOLITERAL
	.dw $0001					; get WIP bit mask
	.dw	XT_XOR					; reverse state of WIP bit
	.dw XT_DOCONDBRANCH			; loop while WIP bit is set
	.dw PFA_25XXX_WAIT_RDY
.endif
	.dw XT_EXIT



; : 25xxx_wait_rdy    ( -- )       \ busy-wait until serial EEPROM finishes writing
;   begin
;     25xxx_enable
;     25XXX_RDSR  spi_xchg  drop  \ send read-status command, ignore response
;     0  spi_xchg                 \ send null byte, response is on TOS
;     25xxx_disable
;     1  and                      \ isolate the WIP (write-in-progress) bit
;     1  xor                      \ reverse state of WIP bit
;   until                         \ loop until WIP = 0
;

