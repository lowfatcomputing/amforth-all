

;
;  load    ( blknum -- )
;
;  This word assigns the value blknum to variable BLK.  This
;  in turn forces REFILL to pull subsequent characters from
;  the selected block (or screen), rather than the console.
;
;  Upon exit, this routine will have written the contents of
;  the selected block into variable BLKBUFFER and written
;  the value blknum into variable BLK.
;

VE_LOAD:
    .dw $ff04
    .db "load"
    .dw VE_HEAD
    .set VE_HEAD = VE_LOAD
XT_LOAD:
    .dw DO_COLON
PFA_LOAD:
;	.dw XT_BLK
;	.dw XT_FETCH
;	.dw XT_TO_R
;	.dw XT_G_IN
;	.dw XT_TO_R
	.dw XT_DUP				; ( blknum blknum )
	.dw XT_BLOCK			; read requested block ( blknum buffaddr )
	.dw XT_DROP				; ( blknum )

	.dw XT_DUP
	.dw XT_BLK
	.dw XT_STORE

	.dw XT_ZERO				; ( blknum 0 )
	.dw XT_BLKOFFSET
	.dw XT_STORE

	.dw XT_SCR				; ( blknum currblk )
	.dw XT_STORE
;	.dw XT_INTERPRET
;	.dw XT_R_FROM
;	.dw XT_G_IN
;	.dw XT_STORE
;	.dw XT_R_FROM
;	.dw XT_BLK
;	.dw XT_STORE
	.dw XT_EXIT





;	.dw XT_DUP					; ( blknum  blknum )
;	.dw XT_DOLITERAL
;	.dw 1024					; ( blknum  blknum  1024 )
;	.dw XT_STAR
;	.dw XT_DOLITERAL
;	.dw $8000
;	.dw XT_PLUS					; ( blknum  eeaddr )
;;	.dw XT_DUP					; ( blknum  eeaddr  eeaddr )
;	.dw XT_DOLITERAL
;	.dw 1024
;	.dw XT_BLKBUFFER			; ( blknum  eeaddr  1024  blkbuffer )
;	.dw XT_SWAP					; ( blknum  eeaddr  blkbuffer  1024 )
;	.dw XT_ROT					; ( blknum  blkbuffer  1024  eeaddr )
;	.dw XT_25XXX_CFETCH_BLK		; ( blknum )  blkbuffer now holds desired block of data
;	.dw XT_BLKBUFFER
;	.dw XT_STORE				; ( blknum )
;	.dw XT_BLK
;	.dw XT_STORE
;	.dw XT_ZERO
;	.dw XT_BLKOFFSET
;	.dw XT_STORE
;	.dw XT_EXIT

	

