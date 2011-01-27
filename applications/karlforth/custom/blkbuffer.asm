; ( -- addr ) File I/O
; R( -- )
; Always returns the address of a dedicated user buffer for holding
; an editor screen.
;

VE_BLKBUFFER:
    .dw $ff09
    .db "blkbuffer", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_BLKBUFFER
XT_BLKBUFFER:
    .dw PFA_DOUSER
PFA_BLKBUFFER:
    .dw USER_BLKBUFFER
