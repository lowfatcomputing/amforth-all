
;
;  block    ( n -- addr )
;
;  Loads the requested block from non-volatile memory and returns the
;  address of the buffer holding the block.
;
VE_BLOCK:
    .dw $ff05
    .db "block", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_BLOCK
XT_BLOCK:
    .dw DO_COLON
PFA_BLOCK:
	.dw XT_BLKBUFFER				; ( blk blkbuffer )
	.dw XT_SWAP						; ( blkbuffer blk )
	.dw XT_READ_BLK					; ( )
	.dw XT_BLKBUFFER				; ( blkbuffer )
	.dw XT_EXIT

; : block           ( n -- addr )         \ translate screen N into addr of first char in screen
;   editscreensize  *                     \ calc addr of first char in screen
;   editbuffer0  +                        \ offset into buffer area
; ;

