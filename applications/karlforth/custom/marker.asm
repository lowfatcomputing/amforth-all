VE_MARKER:
	.dw $ff06
	.db "marker"
	.dw VE_HEAD
	.set VE_HEAD = VE_MARKER
XT_MARKER:
	.dw DO_COLON
PFA_MARKER:	
	.dw XT_GET_ORDER
	.dw XT_GET_CURRENT
	.dw XT_DUP
	.dw XT_EFETCH
	.dw XT_DP
	.dw XT_EDP
	.dw XT_HERE
	.dw XT_CREATE
	.dw XT_COMMA
	.dw XT_COMMA
	.dw XT_COMMA
	.dw XT_COMMA
	.dw XT_COMMA
	.dw XT_DUP
	.dw XT_COMMA
	.dw XT_ZERO
	.dw XT_DOQDO
	.dw PFA_MARKER_2
PFA_MARKER_1:	
	.dw XT_DUP
	.dw XT_COMMA
	.dw XT_EFETCH
	.dw XT_COMMA
	.dw XT_DOLOOP
	.dw PFA_MARKER_1
PFA_MARKER_2:
	.dw XT_DODOES
	 call_ DO_DODOES
	 .dw XT_DUP
	 .dw XT_IFETCH
	 .dw XT_DOTO
	 .dw PFA_HERE
	 .dw XT_1PLUS
	 .dw XT_DUP
	 .dw XT_IFETCH
	 .dw XT_DOTO
	 .dw PFA_EDP
	 .dw XT_1PLUS
	 .dw XT_DUP
	 .dw XT_IFETCH
	 .dw XT_DOTO
	 .dw PFA_DP
	 .dw XT_1PLUS
	 .dw XT_DUP
	 .dw XT_IFETCH
	 .dw XT_SWAP
	 .dw XT_1PLUS
	 .dw XT_DUP
	 .dw XT_IFETCH
	 .dw XT_SWAP
	 .dw XT_TO_R
	 .dw XT_SWAP
	 .dw XT_OVER
	 .dw XT_ESTORE
	 .dw XT_SET_CURRENT
	 .dw XT_R_FROM
	 .dw XT_1PLUS
	 .dw XT_DUP
	 .dw XT_IFETCH
	 .dw XT_DUP
	 .dw XT_TO_R
	 .dw XT_ZERO
	 .dw XT_DOQDO
	 .dw PFA_MARKER_4
PFA_MARKER_3:
	 .dw XT_1PLUS
	 .dw XT_DUP
	 .dw XT_IFETCH
	 .dw XT_SWAP
	 .dw XT_1PLUS
	 .dw XT_DUP
	 .dw XT_IFETCH
	 .dw XT_OVER
	 .dw XT_ESTORE
	 .dw XT_DOLOOP
	 .dw PFA_MARKER_3
PFA_MARKER_4:
	 .dw XT_DROP
	 .dw XT_R_FROM
	 .dw XT_SET_ORDER
	 .dw XT_EXIT
	