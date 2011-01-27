
;
;  wipe-scr    ( blk -- )      fill selected block with spaces
;

VE_WIPE_SCR:
    .dw $ff08
    .db "wipe-scr"
    .dw VE_HEAD
    .set VE_HEAD = VE_WIPE_SCR
XT_WIPE_SCR:
    .dw DO_COLON
PFA_WIPE_SCR:
	.dw XT_SLITERAL
	.dw 14
	.db "Wiping screen "
	.dw XT_ITYPE
	.dw XT_DUP
	.dw XT_DOT
	.dw XT_SLITERAL
	.dw 3
	.db "...", 0
	.dw XT_ITYPE
	.dw XT_BLKBUFFER
	.dw XT_DOLITERAL
	.dw 1024						; number of bytes in a screen
	.dw XT_BL
	.dw XT_FILL
	.dw XT_BLKBUFFER				; ( blk  blkbuffer )
	.dw XT_SWAP
	.dw XT_WRITE_BLK
	.dw XT_SLITERAL
	.dw 5
	.db "done.", 0
	.dw	XT_EXIT



; : wipe-scr      ( blk -- )              \ fill screen with spaces
;   ." Wiping screen "  dup  .  ." ..."
;   blkbuffer  editscreensize  $20  fill
;   blkbuffer  swap  write-blk
;   ." done."
; ;

