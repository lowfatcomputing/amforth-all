; ( addr --  -- [ addr 0 ] | [ xt [-1|1]] )
VE_FIND:
    .db $04, "find", 0
    .dw VE_LATEST
    .set VE_LATEST = VE_FIND
XT_FIND:
    .dw DO_COLON
PFA_FIND:
    .dw XT_DUP
    .dw XT_TO_R
    .dw XT_DP
    .dw XT_EFETCH
PFA_FIND1:
    ; ( addr )
    .dw XT_DUP
    .dw XT_DOLITERAL
    .dw 0
    .dw XT_NOTEQUAL
    .dw XT_DOCONDBRANCH
    .dw PFA_FIND2
    .dw XT_ICOMPARE
    ; (addr-ram addr-flash -- addr-flash' 0|1
    .dw XT_GREATERZERO
    .dw XT_DOCONDBRANCH
    .dw PFA_FIND3
    ; we found the word
    .dw XT_R_FROM
    .dw XT_DROP
    .dw XT_1PLUS ; make XT
    .dw XT_DOLITERAL
    .dw 1
    .dw XT_EXIT

PFA_FIND3:
    .dw XT_R_FROM
    .dw XT_DUP
    .dw XT_TO_R
    .dw XT_SWAP
    .dw XT_IFETCH
    .dw XT_DOBRANCH
    .dw PFA_FIND1

PFA_FIND2:
    .dw XT_DROP
    .dw XT_DROP
    .dw XT_R_FROM
    .dw XT_DOLITERAL
    .dw 0
    .dw XT_EXIT

; private headerless routine
; compares counted string in RAM with counted string in flash
; 
XT_ICOMPARE:
    .dw DO_COLON
PFA_ICOMPARE:
    ; ( addr-ram addr-flash -- 0|1
    ; save ram address
    .dw XT_DOLITERAL
    .dw 0
    .dw XT_TO_R
    .dw XT_DUP
    .dw XT_IFETCH
    .dw XT_DOLITERAL
    .dw $001f
    .dw XT_AND
    .dw XT_2SLASH
    .dw XT_1PLUS
    .dw XT_TO_R
    
PFA_ICOMPARE1:
    .dw XT_OVER
    .dw XT_OVER
    .dw XT_IFETCH
    .dw XT_SWAP
    .dw XT_FETCH
    .dw XT_EQUAL
    .dw XT_DOCONDBRANCH
    .dw PFA_ICOMPARE3
    ; increment pointers, 1 CELL for FLASH, 2 bytes for RAM
    .dw XT_1PLUS
    .dw XT_SWAP
    .dw XT_1PLUS
    .dw XT_1PLUS
    .dw XT_SWAP
    ; decrement cell counter, leave loop for zero
    .dw XT_R_FROM
    .dw XT_1MINUS
    .dw XT_DUP
    .dw XT_TO_R
    .dw XT_EQUALZERO
    .dw XT_DOCONDBRANCH
    .dw PFA_ICOMPARE2
    ; we found matching strings
    .dw XT_R_FROM
    .dw XT_R_FROM
    .dw XT_DROP
    .dw XT_DOLITERAL
    .dw 1
    .dw XT_TO_R
    .dw XT_TO_R
    .dw XT_DOBRANCH
    .dw PFA_ICOMPARE3
PFA_ICOMPARE2:
    .dw XT_DOBRANCH
    .dw PFA_ICOMPARE1

PFA_ICOMPARE3:
    .dw XT_SWAP
    .dw XT_DROP
    .dw XT_R_FROM
    .dw XT_PLUS
    .dw XT_R_FROM
    .dw XT_EXIT
