;
;  spi_xchg.asm
;
; ( c1 -- c2 )  custom
; R( -- )
;

VE_SPI_XCHG:
    .dw $ff08
    .db "spi_xchg"
    .dw VE_HEAD
    .set VE_HEAD = VE_SPI_XCHG
XT_SPI_XCHG:
    .dw DO_COLON
PFA_SPI_XCHG:
    .dw XT_SPDR
	.dw XT_CSTORE
PFA_SPI_XCHG_1:
	.dw XT_SPSR
	.dw XT_CFETCH
	.dw XT_DOLITERAL
	.dw $80
	.dw XT_AND
	.dw XT_DOCONDBRANCH
	.dw PFA_SPI_XCHG_1
	.dw XT_SPDR
	.dw XT_CFETCH
    .dw XT_EXIT

;
;: spi_xchg    ( c1 -- c2 )      \ send TOS to SPI, return response in TOS
;  SPDR  c!                      \ send byte to device
;  begin
;    SPSR  c@                    \ get status reg
;	 80  and                     \ isolate SPIF bit
;  until                         \ loop until SPIF is set
;  SPDR  c@                      \ get data returned by slave
;;
