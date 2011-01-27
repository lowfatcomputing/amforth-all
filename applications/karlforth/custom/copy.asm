
;
;  copy    ( to  from -- )     copy screen FROM to screen TO
;

VE_COPY:
    .dw $ff04
    .db "copy"
    .dw VE_HEAD
    .set VE_HEAD = VE_COPY
XT_COPY:
    .dw DO_COLON
PFA_COPY:
	.dw XT_CR
	.dw XT_SLITERAL
	.dw	15
	.db "Copying screen ", 0
	.dw XT_ITYPE
	.dw XT_DUP
	.dw XT_DOT
	.dw XT_SLITERAL
	.dw 10
	.db "to screen "
	.dw XT_ITYPE
	.dw XT_OVER					; ( to from to )
	.dw XT_DOT					; ( to from )

	.dw XT_BLOCK				; reads "from" block to buffer ( to blkbuffer )
	.dw XT_OVER					; ( to blkbuffer to )
	.dw XT_WRITE_BLK			; ( to )

	.dw XT_SCR
	.dw XT_STORE
	.dw XT_EXIT



; : copy      ( to  from  -- )            \ copy screen FROM to screen TO
;   cr  ." Copying screen "  dup  .
;       ." to screen "  over  .
;   blkbuffer  swap  read-blk
;   dup  blkbuffer  swap  write-blk
;   currblk  !
; ;


