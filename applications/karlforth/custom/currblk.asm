; ( -- blk# ) File I/O
; R( -- )
; number of current file block to edit.  Do not confuse this
; with BLK, which contains the file block (screen) for use by
; REFILL as an input character stream.
;

VE_CURRBLK:
    .dw $ff07
    .db "currblk", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_CURRBLK
XT_CURRBLK:
    .dw PFA_DOUSER
PFA_CURRBLK:
    .dw USER_CURRBLK
