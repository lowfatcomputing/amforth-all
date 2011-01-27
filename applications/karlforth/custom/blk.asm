; ( -- blk# ) File I/O
; R( -- )
; number of current file block to compile/interpret.  A value of 0
; implies compile/interpret from the console input stream (KEY).

VE_BLK:
    .dw $ff03
    .db "blk", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_BLK
XT_BLK:
    .dw PFA_DOUSER
PFA_BLK:
    .dw USER_BLK
