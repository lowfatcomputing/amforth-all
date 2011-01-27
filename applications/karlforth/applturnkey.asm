; ( -- ) System
; R( -- )
; application specific turnkey action
VE_APPLTURNKEY:
    .dw $ff0b
    .db "applturnkey",0
    .dw VE_HEAD
    .set VE_HEAD = VE_APPLTURNKEY
XT_APPLTURNKEY:
    .dw DO_COLON
PFA_APPLTURNKEY:
    .dw XT_INITUSER
    .dw XT_USART
    .dw XT_INTON

	.dw XT_SPI_INIT				; added to set up the SPI on power-up
	.dw XT_25XXX_INIT			; added to set up the serial EEPROM on power-up

    .dw XT_CR
    .dw XT_CR
    .dw XT_VER
    .dw XT_CR
    .dw XT_SLITERAL
    .dw 22
    .db "Karl's amForth system "
    .dw XT_ITYPE

    .dw XT_EXIT

