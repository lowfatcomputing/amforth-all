;
;  -->    ( -- ) 
;
;  This word loads the block following the current block (in
;  CURRBLK).  It is used as the final word in a screen to cause
;  the next screen to load automatically.
;
;  Upon exit, CURRBLK will have been updated with the new
;  current block number.
;
;  WARNING!  There is no end-of-block-device check!  If you
;  stick a load-arrow in the last screen on your block device,
;  the kernel will try and load off the end of the device!
;

VE_LOADARROW:
    .dw $ff03
    .db "-->", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_LOADARROW
XT_LOADARROW:
    .dw DO_COLON
PFA_LOADARROW:
	.dw	XT_SCR
	.dw XT_FETCH
	.dw XT_1PLUS
	.dw XT_DUP
	.dw XT_SCR
	.dw XT_STORE
	.dw XT_LOAD
	.dw XT_EXIT
