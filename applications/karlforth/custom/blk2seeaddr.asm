
;
;  blk>seeaddr      ( blk -- seeaddrl  seeaddrh )
;
;  This word translates a requested block number into a 32-bit
;  serial EEPROM address for use with the 25xxx serial EEPROMs.
;
;  This word assumes that the source blocks begin at offset SEE_EDITOR_START_ADDR
;  in the serial EEPROM.
;

VE_BLK2SEEADDR:
    .dw $ff0b
    .db "blk>seeaddr", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_BLK2SEEADDR
XT_BLK2SEEADDR:
	.dw DO_COLON
PFA_BLK2SEEADDR:
	.dw XT_DUP						; ( blk blk )
	.dw XT_DOLITERAL
	.dw SEE_EDITOR_NUM_OF_BLOCKS	; ( blk blk numblks )
	.dw XT_LESS						; ( blk blk<numblks )
	.dw XT_DOCONDBRANCH
	.dw PFA_BLK2SEEADDR1			; branch if blk is illegal

	.dw XT_DOLITERAL
	.dw 1024						; ( blk 1024 )
	.dw XT_MSTAR					; ( doffset )
	.dw XT_DOLITERAL
	.dw SEE_EDITOR_START_ADDR		; starting addr in serial EEPROM for editor screens
	.dw XT_ZERO						; make it a double ( doffset dstart )
	.dw XT_DPLUS					; ( seeaddrl  seeaddrh )
	.dw XT_DOBRANCH
	.dw PFA_BLK2SEEADDR2
PFA_BLK2SEEADDR1:
	.dw XT_DOLITERAL
	.dw -99							; need to put this in a custom error file!
	.dw XT_THROW
PFA_BLK2SEEADDR2:
	.dw XT_EXIT


