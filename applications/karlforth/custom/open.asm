

;
;  open   ( line# -- )    open a line in current screen at line#
;
;  This word moves all lines from line# to 14 down one line; the current
;  line 15 is lost.
;
;  The value for line# can range from 0 to 14.
;

VE_OPEN:
    .dw $ff04
    .db "open"
    .dw VE_HEAD
    .set VE_HEAD = VE_OPEN
XT_OPEN:
    .dw DO_COLON
PFA_OPEN:
	.dw XT_DOLITERAL
	.dw 16
	.dw XT_MOD
	.dw XT_DUP
	.dw XT_DOLITERAL
	.dw 15
	.dw XT_LESS
	.dw XT_DOCONDBRANCH
	.dw PFA_OPEN1
	.dw XT_DUP
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_STAR
	.dw XT_DOLITERAL
	.dw 1024
	.dw XT_SWAP
	.dw XT_MINUS
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_MINUS
	.dw XT_TO_R
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_STAR
	.dw XT_BLKBUFFER
	.dw XT_PLUS
	.dw XT_DUP
	.dw XT_DUP
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_PLUS
	.dw XT_R_FROM
	.dw XT_CMOVE_G
	.dw XT_DOLITERAL
	.dw 64
	.dw	XT_BL
	.dw XT_FILL
	.dw XT_BLKBUFFER
	.dw XT_SCR
	.dw XT_FETCH
	.dw XT_WRITE_BLK
	.dw XT_DOBRANCH
	.dw PFA_OPEN2
PFA_OPEN1:
	.dw XT_DROP
PFA_OPEN2:
	.dw XT_EXIT




; : open  ( line# -- )
;   16  mod
;   dup  15  <
;   if
;     dup  64  *  1024  swap  -
;     64  -  >r
;     64  *  blkbuffer  +  dup  dup
;     64  +  r>  cmove>
;     64  bl  fill
;     blkbuffer  currblk  @  write-blk
;     0
;   then
;   drop
; ;
