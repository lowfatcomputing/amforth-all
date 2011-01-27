
;
;  text    ( delimiter -- )
;
;  Scan the input buffer for a string delimited by the char in TOS.
;  Copy the string to PAD.
;
;  (Taken from Leo Brodie's book, Starting Forth)
;

VE_TEXT:
    .dw $ff04
    .db "text"
    .dw VE_HEAD
    .set VE_HEAD = VE_TEXT
XT_TEXT:
    .dw DO_COLON
PFA_TEXT:
	.dw XT_PAD
	.dw XT_DOLITERAL
	.dw 128
	.dw XT_BL
	.dw XT_FILL
	.dw XT_WORD
	.dw XT_COUNT
	.dw XT_PAD
	.dw XT_SWAP
	.dw XT_CMOVE
	.dw XT_EXIT



; : text  pad 128 bl fill  word count pad swap cmove ;
