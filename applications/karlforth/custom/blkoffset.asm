; ( -- offset ) File I/O
; R( -- )
; Offset (in bytes) from the start of blkbuffer for the next
; character to process in ACCEPT_BUFFER.


VE_BLKOFFSET:
    .dw $ff09
    .db "blkoffset", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_BLKOFFSET
XT_BLKOFFSET:
    .dw PFA_DOUSER
PFA_BLKOFFSET:
    .dw USER_BLKOFFSET
