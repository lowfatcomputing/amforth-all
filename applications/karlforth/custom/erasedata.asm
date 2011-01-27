

;
;  (cls)   ( n -- )    erase data on ANSI screen
;
;  If n = 0, erase from curser to end of line.
;  If n = 1, erase from cursor to BEGINNING of screen.
;  If n = 2, erase entire screen.
;

VE_P_CLS_P:
    .dw $ff05
    .db "(cls)", 0
    .dw VE_HEAD
    .set VE_HEAD = VE_P_CLS_P
XT_P_CLS_P:
    .dw DO_COLON
PFA_P_CLS_P:
	.dw XT_DOLITERAL
	.dw 27						; ESC
	.dw XT_EMIT
	.dw XT_DOLITERAL
	.dw 91						; [
	.dw XT_EMIT
	.dw XT_EMIT
	.dw XT_DOLITERAL
	.dw 74						; J
	.dw XT_EMIT
	.dw XT_EXIT




;
; : (cls)      ( n -- )    erase data on ANSI screen
;   27  emit
;   [char] [  emit
;   emit
;   [char] J  emit
; ;
;

	
