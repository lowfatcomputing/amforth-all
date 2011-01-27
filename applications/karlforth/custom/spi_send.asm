;
;  spi_send.asm    send byte in TOS to SPI, read but discard SPI response
;
; ( c1 -- )  custom
; R( -- )
;

VE_SPI_SEND:
    .dw $ff08
    .db "spi_send"
    .dw VE_HEAD
    .set VE_HEAD = VE_SPI_SEND
XT_SPI_SEND:
    .dw DO_COLON
PFA_SPI_SEND:
	.dw XT_SPI_XCHG
	.dw XT_DROP
	.dw XT_EXIT


