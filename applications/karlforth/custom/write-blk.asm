
;
;  write-blk    ( bufferaddr  blk -- )
;
;  Write the screen of data (1024 bytes) at bufferaddr into the block
;  blk of the mass-storage device.
;

VE_WRITE_BLK:
    .dw $ff09
    .db "write-blk", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_WRITE_BLK
XT_WRITE_BLK:
    .dw DO_COLON
PFA_WRITE_BLK:
	.dw XT_DOLITERAL
	.dw 1024					; number of bytes per screen
	.dw XT_SWAP
	.dw XT_BLK2SEEADDR			; ( bufferaddr  1024  seeaddrl  seeaddrh )
	.dw XT_25XXX_CSTORE_BLK
	.dw XT_EXIT


