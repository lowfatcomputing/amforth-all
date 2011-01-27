
;
;  25xxx_!      ( w  seeaddrl  seeaddrh -- )
;
;  This word writes the 16-bit value n to the address in serial
;  EEPROM held in TOS/NOS.
;
;  This routine is safe to use across page boundaries.
;


VE_25XXX_STORE:
    .dw $ff07
    .db "25xxx_!", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_25XXX_STORE
XT_25XXX_STORE:
    .dw DO_COLON
PFA_25XXX_STORE:
	.dw	XT_2TO_R				; ( w )
	.dw XT_DUP					; ( w w )
	.dw XT_BYTESWAP				; ( w wswap )
	.dw XT_2R_FROM				; ( w wswap seeaddrl seeaddrh )

	.dw XT_OVER
	.dw XT_OVER					; ( w wswap seeaddrl seeaddrh seeaddrl seeaddrh )
	.dw XT_DOLITERAL
	.dw 1
	.dw XT_ZERO
	.dw XT_DPLUS				; ( w wswap seeaddrl seeaddrh seeaddrl+1 seeaddrh )

	.dw XT_2TO_R				; ( w wswap seeaddrl seeaddrh )

	.dw XT_25XXX_CSTORE			; ( w )
	.dw XT_2R_FROM				; ( w seeaddrl+1 seeaddrh )
	.dw XT_25XXX_CSTORE			; ( )
	.dw XT_EXIT


; : 25xxx_!    ( w  seeaddrl  seeaddrh -- )       \ write word in NOS to serial EEPROM at addr in TOS
;   2>r  dup  ><  2r>               \ fast way to prep data in stack ( wl  wh  seeaddrl  seeaddrh )
;   over  over  1  0  d+			\ precalc addr of second byte in data
;   2>r                             \ save for later  ( wl  wh  seeaddrl  seeaddrh )
;   25xxx_c!                  		\ write MSB of word  ( wl )
;   2r>                             \ recover addr of next byte  ( wl  seeaddrl+1  seeaddrh )
;   25xxx_c!                    	\ write LSB
; ;

  
