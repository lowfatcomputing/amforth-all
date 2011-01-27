; \
; \  save_eeprom copies all of amforth's EEPROM data to serial EEPROM.
; \  The format for the data written matches the format expected by
; \  recovery firmware in my bootloader area:
; \
; \  Byte 0:         0x5a if image in serial EEPROM is valid
; \  Byte 1:         MSB of number of bytes in EEPROM image
; \  Byte 2:         LSB of number of bytes in EEPROM image
; \  Bytes 3 -> n:   copy of amforth's EEPROM image, from 0 to edp
; \
; \  Note that save_eeprom does NOT write the 0x5a valid flag to addr
; \  0 in serial EEPROM!  That final validity step must be performed
; \  by a higher-level word.
; \
;


VE_SAVE_EEPROM:
    .dw $ff0b
    .db "save_eeprom", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_SAVE_EEPROM
XT_SAVE_EEPROM:
    .dw DO_COLON
PFA_SAVE_EEPROM:
	.dw XT_SLITERAL
	.dw 15
	.db "Saving EEPROM (", 0
	.dw XT_ITYPE
	.dw XT_EDP
	.dw XT_DOT
	.dw XT_SLITERAL
	.dw 10
	.db "bytes)... "
	.dw XT_ITYPE
	.dw XT_EDP
	.dw XT_DOLITERAL
	.dw 2
	.dw XT_ZERO					; always use 24-bit address
	.dw XT_25XXX_STORE

	.dw XT_EDP
	.dw XT_ZERO					; ( bytes-in-flash  0 -- )
	.dw XT_DOQDO
	.dw PFA_SAVE_EEPROM_2
PFA_SAVE_EEPROM_1:
	.dw XT_I
	.dw XT_EFETCH
	.dw XT_I
	.dw XT_DOLITERAL
	.dw 4
	.dw XT_PLUS
	.dw XT_ZERO					; always use 24-bit address
	.dw XT_25XXX_CSTORE

	.dw XT_DOLOOP
	.dw PFA_SAVE_EEPROM_1
PFA_SAVE_EEPROM_2:
	.dw XT_SLITERAL
	.dw 6
	.db "done.", 0
	.dw XT_ITYPE
	.dw XT_CR
	.dw XT_EXIT



; : save_eeprom    ( -- )       \ copy all of amforth's EEPROM data to serial EEPROM
;   ." Saving EEPROM ("
;   edp  .  ." bytes)... "
;   edp  2  25xxx_!             \ write EEPROM byte count (16 bits) at addr 2
;  
;   edp  0					    \ for all bytes in amforth's EE area...
;   do
;     i  e@  					\ read the word in EEPROM
;     i  4  +					\ calc addr in serial EEPROM for this byte
; 	25xxx_c!                    \ write LSB to serial EEPROM
;   loop
;   ." done."  cr
; ;

