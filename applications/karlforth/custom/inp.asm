
;
;  inp   ( line# -- )      input a line of text, write to current screen as line line#
;
;  Example:  3 inp : foo 1 . ;
;  adds the line ": foo 1 . ;" to the current screen as line 3.
;
;  This definition requires the word text.asm, which is derived from source in
;  Leo Brodie's book, "Starting Forth."
;

VE_INP:
    .dw $ff03
    .db "inp", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_INP
XT_INP:
    .dw DO_COLON
PFA_INP:
	.dw XT_DOLITERAL
	.dw 1
	.dw XT_TEXT
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_STAR
	.dw XT_BLKBUFFER
	.dw XT_PLUS
	.dw XT_PAD
	.dw XT_SWAP
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_CMOVE
	.dw XT_BLKBUFFER
	.dw XT_SCR
	.dw XT_FETCH
	.dw XT_WRITE_BLK
	.dw XT_EXIT



; : _inp
;   1  text
;   64  *  blkbuffer  +
;   pad  swap  64  cmove
;   blkbuffer  scr  @  write-blk
; ;

