; Layout of the user area
;

;
;  Modified by Karl Lunt, 21 Oct 2010
;  Now includes the BLK user variable (24)
;  Now includes the CURRBLK user variable (26)
;  Now includes the BLKOFFSET user variable (28)
;  Now includes the BLKBUFFER user variable (30, total of 1024 bytes)
; 

; used by the multitasker
.set USER_STATE    	= 0
.set USER_FOLLOWER 	= 2

; stackpointer, used by mulitasker
.set USER_RP      	= 4
.set USER_SP0     	= 6
.set USER_SP      	= 8

; excpection handling
.set USER_HANDLER 	= 10

; numeric IO
.set USER_BASE  	= 12

; character IO 
.set USER_EMIT  	= 14
.set USER_EMITQ 	= 16
.set USER_KEY   	= 18
.set USER_KEYQ 	 	= 20
.set USER_SKEY  	= 22

.set USER_BLK   	= 24
.set USER_SCR		= 26			; was USER_CURRBLK
.set USER_BLKOFFSET = 28
.set USER_BLKBUFFER	= 30

.set SYSUSERSIZE 	= 1022+32		; allow room for 1024 bytes in BLKBUFFER
; 
