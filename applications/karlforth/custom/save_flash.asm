; \
; \  save_flash copies all of amforth's low-flash image to serial EEPROM.
; \  The format of the data written matches the format expected by
; \  recovery firmware in my bootloader area:
; \
; \  Byte n+1:        MSB of number of bytes in low-flash image
; \  Byte n+2:        LSB of number of bytes in low-flash image
; \  Bytes n+3 -> k:  copy of amforth's low-flash image, from 0 to dp
; \
; \  Note that save_flash assumes you have already written the EEPROM
; \  image, using save_eeprom above!  If you have not done so and invoke
; \  save_flash, you will almost certainly screw up your serial EEPROM
; \  images!
; \
; 


VE_SAVE_FLASH:
    .dw $ff0a
    .db "save_flash"
    .dw VE_HEAD
    .set VE_HEAD = VE_SAVE_FLASH
XT_SAVE_FLASH:
    .dw DO_COLON
PFA_SAVE_FLASH:
	.dw XT_SLITERAL				;   ." Saving low flash ("
	.dw 18
	.db "Saving low flash ("
	.dw XT_ITYPE

	.dw XT_DP					;   dp  2*  .  ." bytes)... "
	.dw XT_2STAR
	.dw XT_DOT
	.dw XT_SLITERAL
	.dw 10
	.db "bytes)... "
	.dw XT_ITYPE				; ( )

	.dw XT_DOLITERAL			;   2  25xxx_c@           \ get MSB of EEPROM image extent
	.dw 2
	.dw XT_ZERO					; always use 24-bit address
	.dw XT_25XXX_CFETCH			; ( addrmsb )

	.dw XT_BYTESWAP				;   ><                    \ adjust
	.dw XT_DOLITERAL				;   3  25xxx_c@           \ get LSB of EEPROM image extent
	.dw 3
	.dw XT_ZERO					; always use 24-bit address
	.dw XT_25XXX_CFETCH			; ( addrmsb addrlsb )

	.dw XT_PLUS					;   +  4  +               \ calc first byte in flash image area
	.dw XT_DOLITERAL
	.dw 4
	.dw XT_PLUS					; ( eeaddr )

	.dw XT_DP					;   dp  2*  over  25xxx_!  \ save flash image length (in bytes) to serial EEPROM
	.dw XT_2STAR
	.dw XT_OVER
	.dw XT_ZERO					; always use 24-bit address
	.dw XT_25XXX_STORE			; ( eeaddr )

	.dw XT_DOLITERAL				;   2  +                   \ point to start of image in serial EEPROM
	.dw 2
	.dw XT_PLUS						; ( -- start-addr )

	.dw XT_25XXX_ENABLE				;   25xxx_enable

	.dw XT_25XXX_WREN				;   25XXX_WREN  spi_send   \ always send write-enable
	.dw XT_SPI_SEND

	.dw XT_25XXX_DISABLE			;   25xxx_disable

	.dw XT_25XXX_ENABLE				;   25xxx_enable

	.dw XT_25XXX_WRITE				;   25XXX_WRITE  spi_send   \ now send the write command
	.dw XT_SPI_SEND					; ( start-addr )

	.if SEE_ADDR_BYTES == 3			; if we need to use 24-bit addressing...
	.dw XT_ZERO						; the high byte will always be 0
	.dw XT_SPI_SEND
	.endif

	.dw XT_DUP						;   dup  ><  spi_send       \ send addr MSB
	.dw XT_BYTESWAP
	.dw XT_SPI_SEND

	.dw XT_DUP						;   dup  spi_send           \ send addr LSB
	.dw XT_SPI_SEND					; ( start-addr )

	.dw XT_DP						;   dp  0                   \ for all words in low-flash image...
	.dw XT_ZERO

    .dw XT_DOQDO					;   do
    .dw PFA_SAVE_FLASH2
PFA_SAVE_FLASH1:

	.dw XT_I						; 	  i  i@                 \ data to write
	.dw XT_IFETCH

	.dw XT_DUP						;     dup  ><
	.dw XT_BYTESWAP

	.dw XT_SPI_SEND					;     spi_send  spi_send    \ send data MSB, then data LSB
	.dw XT_SPI_SEND

	.dw XT_I						;     i  2*  over  +  1+    \ addr of last byte we just wrote
	.dw XT_2STAR
	.dw XT_OVER
	.dw XT_PLUS
	.dw XT_1PLUS					; ( start-addr start-addr+2*i+1 )

	.dw XT_DOLITERAL				;     7f  and  7f  =        \ 7f = end of page for 25LC256/512; use 3f for 25128/256
	.dw (SEE_PAGE_BYTES-1)
	.dw XT_AND
	.dw XT_DOLITERAL
	.dw (SEE_PAGE_BYTES-1)			; use 7F for 26LC256/512, use 3F for 25128/256
	.dw XT_EQUAL					; ( start-addr f )

	.dw XT_DOCONDBRANCH				;     if not at page boundary...
	.dw PFA_SAVE_FLASH3

	.dw XT_25XXX_DISABLE			;       25xxx_disable       \ done with this page

	.dw XT_25XXX_WAIT_RDY			;       25xxx_wait_rdy      \ let the write complete

	.dw XT_25XXX_ENABLE				;       25xxx_enable

	.dw XT_25XXX_WREN				;       25XXX_WREN  spi_send   \ always send write-enable
	.dw XT_SPI_SEND

	.dw XT_25XXX_DISABLE			;       25xxx_disable

	.dw XT_25XXX_ENABLE				;       25xxx_enable

	.dw XT_25XXX_WRITE				;       25XXX_WRITE  spi_send   \ now send the write command
	.dw XT_SPI_SEND

	.dw XT_I                        ;       i  1+  2*  over  +   \ calc addr of next byte to write
	.dw XT_1PLUS
	.dw XT_2STAR
	.dw XT_OVER
	.dw XT_PLUS

	.dw XT_DUP						;       dup  ><             \ get addr MSB, then addr LSB
	.dw XT_BYTESWAP

	.if SEE_ADDR_BYTES == 3			; if we need to use 24-bit addressing...
	.dw XT_ZERO						; the high byte will always be 0
	.dw XT_SPI_SEND
	.endif

	.dw XT_SPI_SEND					;       spi_send  spi_send    \ send to serial EEPROM
	.dw XT_SPI_SEND

PFA_SAVE_FLASH3:					;     then

    .dw XT_DOLOOP					;   loop
    .dw PFA_SAVE_FLASH1
PFA_SAVE_FLASH2:

	.dw XT_SLITERAL					;   ." done."  cr
	.dw 5
	.db "done.", 0
	.dw XT_ITYPE
	.dw XT_CR

	.dw XT_25XXX_DISABLE			;   25xxx_disable

	.dw XT_25XXX_WAIT_RDY			;   25xxx_wait_rdy

	.dw XT_DROP						;   drop

	.dw XT_EXIT



; : save_flash    ( -- )          \ copy all of amforth's low-flash image to serial EEPROM
;   ." Saving low flash ("
;   dp  2*  .  ." bytes)... "
;   2  25xxx_c@                   \ get MSB of EEPROM image extent
;   ><                            \ adjust
;   3  25xxx_c@                   \ get LSB of EEPROM image extent
;   +  4  +                       \ calc first byte in flash image area
;   dp  2*  over  25xxx_!         \ save flash image length (in bytes) to serial EEPROM
;   2  +                          \ point to start of image in serial EEPROM
;
;   25xxx_enable
;   25XXX_WREN  spi_send          \ always send write-enable
;   25xxx_disable
;   25xxx_enable
;   25XXX_WRITE  spi_send         \ now send the write command
;   dup  ><  spi_send             \ send addr MSB
;   dup  spi_send                 \ send addr LSB
;   dp  0                         \ for all words in low-flash image...
;   do
; 	  i  i@                       \ data to write
;     dup  ><
;     spi_send  spi_send          \ send MSB, then LSB
;     i  2*  over  +  1+          \ addr of last byte we just wrote
;     7f  and  7f  =              \ 7f = end of page for 25LC256/512; use 3f for 25128/256
;     if
;       25xxx_disable             \ done with this page
;       25xxx_wait_rdy            \ let the write complete
;       25xxx_enable
;       25XXX_WREN  spi_send      \ always send write-enable
;       25xxx_disable
;       25xxx_enable 
;       25XXX_WRITE  spi_send     \ now send the write command
;       i  1+  2*  over  +        \ calc addr of next byte to write
;       dup  ><                   \ send flash addr of next byte
;       spi_send  spi_send        \ MSB, then LSB
;     then
;   loop
;   drop
;   ." done."  cr
;   25xxx_disable
;   25xxx_wait_rdy
; ;




; : save_flash    ( -- )          \ copy all of amforth's low-flash image to serial EEPROM
;   ." Saving low flash ("
;   dp  2*  .  ." bytes)... "
;   1  25xxx_c@                     \ get MSB of EEPROM image extent
;   8  lshift                     \ adjust
;   2  25xxx_c@                     \ get LSB of EEPROM image extent
;   +  3  +                       \ calc first byte in flash image area
;   dp  2*  over  25xxx_!           \ save flash image length (in bytes) to serial EEPROM
;   2  +                          \ point to start of image in serial EEPROM
; 
;   dp  0                         \ for all words in low-flash image...
;   do
;     i  2*  over  +              \ addr of word to write
; 	  i  i@                       \ data to write
; 	  swap  25xxx_!                 \ write the bytes
;   loop                        	\ move to next word
;   drop                          \ done with addr
;   ." done."  cr
; ;

