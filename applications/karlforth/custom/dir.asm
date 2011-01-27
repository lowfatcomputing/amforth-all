
;
;  dir    ( to  from -- )      list line 0 of a range of screens
;

VE_DIR:
    .dw $ff03
    .db "dir", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_DIR
XT_DIR:
    .dw DO_COLON
PFA_DIR:
    .dw XT_DOQDO					;   do
    .dw PFA_DIR2
PFA_DIR1:
	.dw XT_CR
	.dw XT_I
	.dw XT_ZERO
	.dw XT_L_SHARP
	.dw XT_DOLITERAL
	.dw ':'
	.dw XT_HOLD
	.dw XT_SHARP_S
	.dw XT_SHARP_G
	.dw XT_TYPE
	.dw XT_SPACE

	.dw XT_I
	.dw XT_BLOCK
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_TYPE
	.dw XT_DOLOOP
	.dw PFA_DIR1
PFA_DIR2:
	.dw XT_CR

	.dw XT_SCR
	.dw XT_FETCH
	.dw XT_BLOCK
	.dw XT_DROP

	.dw XT_EXIT




; : dir     ( to  from -- )              \ list line 0 of a range of screens
;   do
;     cr  i  0  <# [char] : hold  #s #>  type  space
;     blkbuffer  i  read-blk
; 	  blkbuffer  64  type
;   loop
;   cr
; ;
