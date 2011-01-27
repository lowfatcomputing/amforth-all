

;
;  25xxx_c!blk      ( addr  n  seeaddrl  seeaddrh -- )
;
;  This word copies a block of N bytes from RAM at address addr to
;  serial EEPROM, starting at the 32-bit address in TOS/NOS.
;
;  This routine automatically handles page-bounaries for those
;  devices that require such; the size of a page must be defined
;  by the assembler equate SEEP_PAGE_BYTES.
;

VE_25XXX_CSTORE_BLK:
    .dw $ff0b
    .db "25xxx_c!blk", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_CSTORE_BLK
XT_25XXX_CSTORE_BLK:
    .dw DO_COLON
PFA_25XXX_CSTORE_BLK:
	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_WREN
	.dw XT_SPI_SEND
	.dw XT_25XXX_DISABLE

	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_WRITE
	.dw XT_SPI_SEND
	.dw XT_OVER
	.dw XT_OVER
	.dw XT_25XXX_SENDADDR			; send addr to serial EEPROM  ( -- addr n seeaddrl seeaddrh )

	.dw XT_ROT						; ( --  addr  seeaddrl  seeaddrh  n )
	.dw XT_ZERO

    .dw XT_DOQDO					; ( -- addr  seeaddrl  seeaddrh )
    .dw PFA_25XXX_CSTORE_BLK2
PFA_25XXX_CSTORE_BLK1:
	.dw XT_ROT
	.dw XT_DUP
	.dw XT_I
	.dw XT_PLUS						; ( -- seeaddrl  seeaddrh  addr  addr+i )

	.dw XT_CFETCH
	.dw XT_SPI_SEND					; ( -- seeaddrl  seeaddrh  addr )

	.dw XT_ROT
	.dw XT_DUP
	.dw XT_I
	.dw XT_PLUS						; ( -- seeaddrh  addr  seeaddrl  seeaddrl+i )

	.dw XT_DOLITERAL
	.dw SEE_PAGE_BYTES-1
	.dw XT_AND
	.dw XT_DOLITERAL
	.dw SEE_PAGE_BYTES-1
	.dw XT_EQUAL
	.dw XT_DOCONDBRANCH
	.dw PFA_25XXX_CSTORE_BLK3
	.dw XT_25XXX_DISABLE			; IF this addr is start of new page, need to release serial EEPROM
	.dw XT_25XXX_WAIT_RDY
	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_WREN
	.dw XT_SPI_SEND
	.dw XT_25XXX_DISABLE
	.dw XT_25XXX_ENABLE
	.dw XT_25XXX_WRITE
	.dw XT_SPI_SEND

	.dw XT_ROT						; ( -- addr  seeaddrl seeaddrh )
	.dw XT_OVER
	.dw XT_OVER						; ( -- addr seeaddrl seeaddrh seeaddrl seeaddrh )

	.dw XT_I
	.dw XT_1PLUS
	.dw XT_ZERO						; ( -- addr seeaddrl seeaddrh seeaddrl seeaddrh i 0 )
	.dw XT_DPLUS					; ( -- addr seeaddrl seeaddrh seeaddrl+i+1 seeaddrh )

	.dw XT_25XXX_SENDADDR			; send new addr to serial EEPROM  ( -- addr  seeaddrl  seeaddrh )
	.dw XT_DOBRANCH
	.dw PFA_25XXX_CSTORE_BLK4
PFA_25XXX_CSTORE_BLK3:				; ELSE  (not at end of a page yet) ( -- seeaddrh addr seeaddrl )
	.dw XT_ROT						; ( -- addr seeaddrh seeaddrl )

PFA_25XXX_CSTORE_BLK4:				; THEN
    .dw XT_DOLOOP
    .dw PFA_25XXX_CSTORE_BLK1
PFA_25XXX_CSTORE_BLK2:
	.dw	XT_DROP
	.dw XT_DROP
	.dw XT_DROP
	.dw XT_25XXX_DISABLE
	.dw XT_25XXX_WAIT_RDY
	.dw XT_EXIT



; : 25xxx_c!blk    ( addr  n  seeaddrl  seeaddrh  -- )  \ copies N bytes from addr to EEPROM address in TOS/NOS
;   25xxx_enable
;   25XXX_WREN  spisend           \ need to enable serial EEPROM for writing
;   25xxx_disable
;
;   25xxx_enable
;   25XXX_WRITE  spi_send         \ send WRITE command, ignore response
;   over  over					  \ copy of 32-bit serial EEPROM addr
;   25xxx_sendaddr				  \ send addr to serial EEPROM  ( -- addr n seeaddrl seeaddrh )
;   rot                           \ ( -- addr seeaddrl seeaddrh n )
;   0                             \ ( -- addr seeaddrl seeaddrh n  0 )
;   do							  \ for all requested bytes  ( -- addr  seeaddrl  seeaddrh )
;     rot dup  i  +               \ addr of byte to fetch  ( -- seeaddrl seeaddrh addr  addr+i )
;     c@  spi_send                \ write to serial EEPROM  ( -- seeaddrl seeaddrh addr )
;     rot dup  i  +               \ calc addr within serial EEPROM ( -- seeaddrh addr seeaddrl seeaddrl+i )
;     7f  and  7f  =              \ last addr in page?; use 7f for 25LC256/512, 3f for AT25128/256
;     if
;       25xxx_disable             \ done with this page
;       25xxx_wait_rdy
;       25xxx_enable
;       25XXX_WREN  spi_send      \ need to enable serial EEPROM for writing
;       25xxx_disable
;       25xxx_enable
;       25XXX_WRITE  spi_send     \ send WRITE command  ( -- seeaddrh addr seeaddrl )
;       rot                       \ set up EEPROM addr ( -- addr  seeaddrl  seeaddrh )
;       over  over                \ get a copy
;       i  1+  0  d+              \ calc addr of next page  ( -- addr  seeaddrl  seeaddrh seeaddrl  seeaddrh )
;       25xxx_sendaddr            \ send addr to serial EEPROM ( -- addr  seeaddrl  seeaddrh)
;     else                        \ not start of new page  ( -- seeaddrh addr seeaddrl )
;       rot                       \ rearrange  ( -- addr  seeaddrl  seeaddrh )
;     then
;   loop
;   drop
;   drop  drop
;   25xxx_disable
;   25xxx_wait_rdy
; ;




