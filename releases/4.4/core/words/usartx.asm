;;; usart driver

; ( -- v) 
; System Value
; returns usart baudrate
VE_BAUD:
  .dw $ff04
  .db "baud"
  .dw VE_HEAD
  .set VE_HEAD = VE_BAUD
XT_BAUD:
  .dw PFA_DOVALUE
PFA_BAUD:          ; ( -- )
  .dw EE_UBRRVAL

; ( -- )
; MCU
; initialize the atxmega usart
VE_USART:
  .dw $ff06
  .db "+usart"
  .dw VE_HEAD
  .set VE_HEAD = VE_USART
XT_USART:
  .dw DO_COLON
PFA_USART:          ; ( -- )

  .dw XT_DOLITERAL
  .dw $88
  .dw XT_DOLITERAL
  .dw TERM_USART_PORT + PORT_DIRSET_offset
  .dw XT_CSTORE

  .dw XT_DOLITERAL
  .dw $44
  .dw XT_DOLITERAL
  .dw TERM_USART_PORT + PORT_DIRCLR_offset
  .dw XT_CSTORE

  .dw XT_DOLITERAL
  .dw USART_A_VALUE
  .dw XT_DOLITERAL
  .dw TERM_USART + USART_CTRLA_offset
  .dw XT_CSTORE

  .dw XT_DOLITERAL
  .dw USART_B_VALUE
  .dw XT_DOLITERAL
  .dw TERM_USART + USART_CTRLB_offset
  .dw XT_CSTORE

  .dw XT_DOLITERAL
  .dw USART_C_VALUE
  .dw XT_DOLITERAL
  .dw TERM_USART + USART_CTRLC_offset
  .dw XT_CSTORE

  .dw XT_BAUD
  .dw XT_DUP
  .dw XT_BYTESWAP
  .dw XT_DOLITERAL
  .dw TERM_USART + USART_BAUDCTRLB_offset
  .dw XT_CSTORE
  .dw XT_DOLITERAL
  .dw TERM_USART + USART_BAUDCTRLA_offset
  .dw XT_CSTORE

  .dw XT_USART_INIT_RX
  .dw XT_USART_INIT_TX
  .dw XT_EXIT
