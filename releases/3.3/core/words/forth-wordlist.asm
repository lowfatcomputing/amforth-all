; ( -- wid ) Search Order
; R( -- )
; get the system default word list
VE_FORTH_WORDLIST:
    .dw $ff0e
    .db "forth-wordlist"
    .dw VE_HEAD
    .set VE_HEAD = VE_FORTH_WORDLIST
XT_FORTH_WORDLIST:
    .dw PFA_DOVALUE
PFA_FORTH_WORDLIST:
    .dw 4
