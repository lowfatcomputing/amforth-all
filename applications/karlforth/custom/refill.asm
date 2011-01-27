; ( -- f ) IO
; R( -- )
; refills the input buffer
VE_REFILL:
    .dw $ff06
    .db "refill"
    .dw VE_HEAD
    .set VE_HEAD = VE_REFILL
XT_REFILL:
    .dw DO_COLON
PFA_REFILL:
	.dw XT_BLK
	.dw XT_FETCH
	.dw XT_ZERO						; blk = 0 means use console input, else use NV storage
	.dw XT_EQUAL
	.dw XT_DOCONDBRANCH				; branch if need to load from blkbuffer
	.dw PFA_REFILL1
    .dw XT_TIB
    .dw XT_DOLITERAL
    .dw TIBSIZE
    .dw XT_ACCEPT
	.dw XT_DOBRANCH
	.dw PFA_REFILL2
PFA_REFILL1:
	.dw XT_BLKBUFFER				; use current block buffer as input buffer
	.dw XT_BLKOFFSET				; next char in buffer is at blkoffset
	.dw XT_FETCH
	.dw XT_PLUS						; ( addr )

	.dw XT_TIB						; ( addr tib )
	.dw XT_DOLITERAL
	.dw 64							; ( addr tib 64 )
	.dw XT_CMOVE					; ( )

	.dw XT_TIB
	.dw XT_DOLITERAL
	.dw 64
	.dw XT_TYPE
	.dw XT_CR

	.dw XT_DOLITERAL				; each line in editor buffer is 64 chars
	.dw 64							; ( 64 )
	.dw XT_BLKOFFSET
	.dw XT_FETCH					; ( 64 offset )
	.dw XT_PLUS						; ( new_offset )
	.dw XT_DOLITERAL				; if new offset = 1024, done with block
	.dw 1024
	.dw XT_MOD						; ( new_offset%1024 )
	.dw XT_DUP
	.dw XT_BLKOFFSET
	.dw XT_STORE					; ( new_offset%1024 )

	.dw XT_ZERO
	.dw XT_EQUAL					; ( f )
	.dw XT_DOCONDBRANCH				; branch if new offset is not 0
	.dw PFA_REFILL3
	.dw XT_ZERO						; done with block, revert to console input
	.dw XT_BLK
	.dw XT_STORE
PFA_REFILL3:
	.dw XT_DOLITERAL
	.dw 64							; number of chars in TIB


;
;  Clean up.  TOS holds the number of chars in TIB, regardless of where they
;  came from.
;
PFA_REFILL2:
    .dw XT_NUMBERTIB
    .dw XT_STORE
    .dw XT_ZERO
    .dw XT_G_IN
    .dw XT_STORE
    .dw XT_DOLITERAL
    .dw -1
    .dw XT_EXIT
