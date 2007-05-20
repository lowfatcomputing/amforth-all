
; ***************************************************************************
; MINIMALE FORTH BEFEHLE FÜR ZUGRIFF AUF VIDEO-RAM MITTELS c@ UND c!
; ***************************************************************************
;
; Bsp: Schreibe Leerzeichen an pos 10 in zeile 7 ( von Null an gezählt) :
;
; decimal 32   tv_vram 10 + tv_xsize 7 * +  c!		; poke (tv_ram + (40*7) + 10),32
; 


; ( -- w ) 
; R( --)
; put address of the beginning of the Videoram on stack
; first char first line
VE_TV_VRAM:
    .db $07, "tv_vram"
    .dw VE_HEAD
    .set VE_HEAD = VE_TV_VRAM
XT_TV_VRAM:
    .dw DO_COLON
PFA_TV_VRAM:
  .dw XT_DOLITERAL
  .dw TV_DDRAM  
  .dw XT_EXIT

; -------------------------------------------------------------

; ( -- w ) 
; R( --)
; put address of the end of the Videoram on stack
; last char in last line.
VE_TV_VRAMEND:
    .db $0a, "tv_vramend",0
    .dw VE_HEAD
    .set VE_HEAD = VE_TV_VRAMEND
XT_TV_VRAMEND:
    .dw DO_COLON
PFA_TV_VRAMEND:
  .dw XT_DOLITERAL
  .dw TV_DDRAM+(TV_XSize*TV_YSize)-1  
  .dw XT_EXIT

; -------------------------------------------------------------

; ( -- w ) 
; R( --)
; put number of columns of the Videoram on stack (default:40)
VE_TV_XSIZE:
    .db $08, "tv_xsize",0
    .dw VE_HEAD
    .set VE_HEAD = VE_TV_XSIZE
XT_TV_XSIZE:
    .dw DO_COLON
PFA_TV_XSIZE:
  .dw XT_DOLITERAL
  .dw TV_XSize  
  .dw XT_EXIT

; -------------------------------------------------------------

; ( -- w ) 
; R( --)
; put number of rows of the Videoram on stack (default:25)
VE_TV_YSIZE:
    .db $08, "tv_ysize",0
    .dw VE_HEAD
    .set VE_HEAD = VE_TV_YSIZE
XT_TV_YSIZE:
    .dw DO_COLON
PFA_TV_YSIZE:
  .dw XT_DOLITERAL
  .dw TV_YSize  
  .dw XT_EXIT

; -------------------------------------------------------------

