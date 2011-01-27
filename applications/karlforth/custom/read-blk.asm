
;
;  read-blk    ( bufferaddr  blk -- )
;
;  Read the screen of data (1024 bytes) at block blk of the mass-storage
;  device into the buffer at bufferaddr.
;

VE_READ_BLK:
    .dw $ff08
    .db "read-blk"
    .dw VE_HEAD
    .set VE_HEAD = VE_READ_BLK
XT_READ_BLK:
    .dw DO_COLON
PFA_READ_BLK:
	.dw XT_DOLITERAL
	.dw 1024					; number of bytes per screen
	.dw XT_SWAP					; ( bufferaddr  1024  blk )
	.dw XT_BLK2SEEADDR			; ( bufferaddr  1024  seeaddrl  seeaddrh )
	.dw XT_25XXX_CFETCH_BLK
	.dw XT_EXIT


