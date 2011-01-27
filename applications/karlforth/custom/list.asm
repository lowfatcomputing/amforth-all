
;
;  list    ( blk -- )      list selected screen
;

VE_LIST:
    .dw $ff04
    .db "list"
    .dw VE_HEAD
    .set VE_HEAD = VE_LIST
XT_LIST:
    .dw DO_COLON
PFA_LIST:
	.dw	XT_DUP						; ( blk blk )
	.dw XT_CR
	.dw XT_SLITERAL
	.dw 18
	.db "Listing of screen "
	.dw XT_ITYPE
	.dw XT_DOT

	.dw XT_DUP						; ( blk blk )
	.dw XT_SCR
	.dw XT_STORE					; ( blk )

	.dw XT_BLOCK					; reads requested block ( blkbuffer )
	.dw XT_DROP						; ( )

	.dw XT_DOLITERAL
	.dw 16
	.dw XT_ZERO
    .dw XT_DOQDO					;   do
    .dw PFA_LIST2
PFA_LIST1:
	.dw XT_CR
	.dw XT_I
	.dw XT_ZERO
	.dw XT_L_SHARP
	.dw XT_DOLITERAL
	.dw ':'
	.dw XT_HOLD
	.dw XT_SHARP
	.dw XT_SHARP
	.dw XT_SHARP_G
	.dw XT_TYPE
	.dw XT_SPACE

	.dw XT_BLKBUFFER				; ( blkbuffer )
	.dw XT_I
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_STAR						; ( blkbuffer lineaddr )
	.dw XT_PLUS						; ( buffaddr )
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_TYPE
	.dw XT_DOLITERAL
	.dw '|'
	.dw XT_EMIT
	.dw XT_DOLOOP
	.dw PFA_LIST1
PFA_LIST2:
	.dw XT_CR
	.dw XT_EXIT




; : list      ( blk -- )                  \ list selected screen
;   dup  cr  ." Listing of screen "  .
;   dup  scr  !
;   blkbuffer  swap  read-blk
;   16  0
;   do
;     cr  i  0  <# [char] : hold # # #>  type  space
; 	  blkbuffer  i  64  *  +
; 	  64  type
; 	  [char] |  emit
;   loop
;   cr
; ;

