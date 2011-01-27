; ( -- blk# ) File I/O
; R( -- )
; number of current screen (file block) to edit.  Do not confuse this
; with BLK, which determines whether to use a particular file block or
; the console stream for interpreting.
;

VE_SCR:
    .dw $ff03
    .db "scr", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_SCR
XT_SCR:
    .dw PFA_DOUSER
PFA_SCR:
    .dw USER_SCR
