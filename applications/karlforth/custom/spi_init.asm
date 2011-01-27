VE_SPI_INIT:
	.dw 	$ff08
	.db 	"spi_init"
	.dw 	VE_HEAD
	.set	VE_HEAD=VE_SPI_INIT
XT_SPI_INIT:
    .dw		DO_COLON
PFA_SPI_INIT:
	.dw		XT_DOLITERAL
	.dw		((1<<MSTR)|(1<<SPE))		; SPE, MSTR, f/4
	.dw		XT_SPCR
	.dw		XT_CSTORE

	.dw		XT_DOLITERAL
	.dw		(1<<SPI2X)			; double SPI clock speed (now f/2)
	.dw		XT_SPSR
	.dw		XT_CSTORE

	.dw		XT_DDRSPI			; changes based on MCU
	.dw		XT_CFETCH
	.dw		XT_DOLITERAL
	.dw		((1<<MOSI)|(1<<SCK))	; make MOSI and SCK outputs
	.dw		XT_OR
	.dw		XT_DDRSPI			; changes based on MCU
	.dw		XT_CSTORE
	.dw		XT_EXIT



;  hex
;
; : spi_init    ( -- )            \ initialize SPI with general settings
;   40                            \ SPE
;   10  or                        \ MSTR
;    2  or                        \ f/64
;   SPCR  c!
;   DDRSPI  c@                    \ get current DDR for SPI
;   1  5  lshift                  \ SCK is an output
;   1  3  lshift  or              \ MOSI is an output
;   or                            \ add masks to set output bits
;   DDRSPI  c!
; ;  
