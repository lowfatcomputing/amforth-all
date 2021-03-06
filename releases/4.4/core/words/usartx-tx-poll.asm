; (c -- )
; MCU
; wait for the terminal becomes ready and put 1 character to it
VE_TX:
    .dw $ff02
    .db "tx"
    .dw VE_HEAD
    .set VE_HEAD = VE_TX
XT_TX:
    .dw DO_COLON
PFA_TX:
  ; wait for data ready
  .dw XT_TXQ
  .dw XT_DOCONDBRANCH
  .dw PFA_TX
  ; send to usart
  .dw XT_DOLITERAL
  .dw TERM_USART+USART_DATA_offset
  .dw XT_CSTORE
  .dw XT_EXIT

; ( -- f)
; MCU
; check if a character can be send
VE_TXQ:
    .dw $ff03
    .db "tx?",0
    .dw VE_HEAD
    .set VE_HEAD = VE_TXQ
XT_TXQ:
    .dw DO_COLON
PFA_TXQ:
  .dw XT_PAUSE
  .dw XT_DOLITERAL
  .dw TERM_USART+USART_STATUS_offset
  .dw XT_CFETCH
; #define USART_IsTXDataRegisterEmpty(_usart) (((_usart)->STATUS & USART_DREIF_bm) != 0)
  .dw XT_DOLITERAL
  .dw USART_DREIF_bm
  .dw XT_AND
  .dw XT_NOTEQUALZERO
  .dw XT_EXIT

; ( -- )
; MCU
; initialize usart
;VE_USART_INIT_TX:
;  .dw $ff06
;  .db "+usart"
;  .dw VE_HEAD
;  .set VE_HEAD = VE_USART_INIT_TX
XT_USART_INIT_TX:
  .dw PFA_USART_INIT_TX
PFA_USART_INIT_TX:          ; ( -- )
  jmp_ DO_NEXT
