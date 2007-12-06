;****************************************************************************************
;*											*
;*		40 x 25 TV Terminal	/ TV Controller					*
;*											*
;*		Version 4.2								*
;*											*
;*		by Benedikt and A.Hauck	(modifikation f√¶r amforth)			*
;*											*
;*		siehe auch Datei: info.asm						*
;*											*
;*		Lizenz: GPL siehe Datei License.txt					*
;*											*
;****************************************************************************************

.equ dict_appl=1

; cpu clock in hertz
.equ cpu_frequency = 8000000
; baud rate of terminal
.equ baud_rate = 9600
; size of return stack in bytes
.equ rstacksize = 80

  .equ HLDSIZE  = $10 ; 16 bit cellsize with binary representation
  .equ TIBSIZE  = $64 ; 80 characters is one line...
  .equ CELLSIZE = 2   ;
  .equ USERSIZE = 24  ; size of user area


.include "macros.asm"
.include "devices/atmega16.asm"

  .set heap = ramstart
  .set VE_HEAD = $0000

.equ mega16 = 1

.set pc_ = pc		;sichere ProgramCounter

;**********************************************************************************
; Charakter ROM einbinden vor Anfang des NRWW Bereiches 
; (unmittelbar vor den Bootsektor)
;
; Die Startadresse muss als lowbyte 0 haben, da dort s√Òter der Zeichencode steht.
;
; Ein Zeichen besteht aus 8x8 Pixel = 64 Pixel = 8 Byte
; Es sind 256 Zeichen * 8 Byte = 2048 Byte = 2048 / 2 = 1024 Worte

.set pc_ = pc
.equ TV_CharRom = high( amforth_interpreter - 1024 ) * 256		;Char Rom Adresse
.org TV_CharRom						;genau unter NRWW-
.include "CharRom.asm"				;Sektion mit lowbyte=0
.org pc_

; F√¶r Pseudo-Graphic-Zeichen:
; (√¶berschreibt die ersten 32 Zeichen aus CharRom.asm )
.include "CharRom_Graphics.asm"


; *********************************************************************************
; Setzt die Einsprungadresse des Zeilen-Interrupts.
; dieser wird f√¶r jede Rasterzeile (alle 64us) aufgerufen.

.org OC1Aaddr						;Set Interrupt
  rjmp TV_OC1A_isr					;Vector

; *********************************************************************************

.org pc_		;zur√¶cksichern ProgramCounter


; *********************************************************************************
; Registerdefinitionen
; *********************************************************************************

; Kompatibilit√Òt mit Mega16/32
;.set WGM10 = PWM10
;.set WGM11 = PWM11
;.set WGM12 = CTC10

;Im Interrupt genutzte und ge√Ònderte Register:

.def TV_XL_Bak		=r8			;Speicher f√¶r X-Reg nach RTI (darf im Hauptprg. nicht ge√Òndert werden !!!!! )
.def TV_XH_Bak		=r9			;wie oben f√¶r HI-Byte
.def TV_ZH_Bak		=r10			;Speicher f√¶r ZH-Reg nach RTI (darf im Hauptprg. nicht ge√Òndert werden !!!! )

.def TV_Y_Cnt		=r11			;Speicher f√¶r Zeilenz√Òhler (in Pixeln nicht Zeichen) / Darf im HP nicht ge√Òndert werden.!!!!!

.def TV_temp0           =r16
.def TV_temp1           =r17

.if mega16 == 1
; ##### MEGA 16 oder MEGA 32 #####

;PortB
.equ	SS		=4			;NC
.equ 	MOSI		=5			;Pixeldaten
.equ 	MISO		=6			;NC
.equ 	SCK		=7			;NC
;PortD
.equ 	Sync		=4			;Sync Ausgang (OCR1B)

; #################################
.else
; ############# MEGA 8 ############

;PortB
.equ	SS		=2			;NC
.equ 	MOSI		=3			;Pixeldaten
.equ 	MISO		=4			;NC
.equ 	SCK		=5			;NC
.equ 	Sync		=2			;Sync Ausgang (OCR1B)

; #################################
.endif


;Bildgr√√üe
.equ TV_XSize		=40		;Bildgr√√üe in X Richtung in Nibbles
.equ TV_YSize		=25		;Bildgr√√üe in Y Richtung pro Halbbild

;Horizontal
.equ TV_XStart		=190		;Anzahl an CPU Takten zwischen Beginn HSync und TV_Bildbeginn (mindestens 30, und mindestens HSyncbreite)
					;Erh√hung um 16 schiebt Bild um ca. ein Zeichen nach rechts. Erniedrigung schiebt nach links. 
.equ TV_SyncWidth	=75		;Anzahl an CPU Takten f√¶r HSync

;Vertikal
.equ TV_Height		=8		;Zeichenh√he
.equ TV_BPSize		=50		;VSync Back Porch in Zeilen (Y Verschiebung)
.equ TV_VSize		=4		;VSync Impuls in Zeilen

;Interne Konstanten
.equ TV_BildSize	=TV_YSize*TV_Height				;Bildh√he in Zeilen
.equ TV_BildStart	=313-TV_BildSize+TV_YSize			;Bildh√he in SyncZeilen+Zeichen (interner Z√Òhler)
.equ TV_FPSize		=(313-TV_YSize*TV_Height)-TV_VSize-TV_BPSize 	;Frontporchbreite in Zeilen
.equ TV_FPStart		=TV_YSize					;Frontporch Start in internen Z√Òhlerzeilen
.equ TV_VSStart		=TV_FPStart+TV_FPSize				;Vsyncstart in internen Z√Òhlerzeilen
.equ TV_BPStart		=TV_VSStart+TV_VSize				;Backporchstart in internen Z√Òhlerzeilen 


;Genutzter RAM und Belegung:
.set TV_DDRAM = heap			;Belege 40x25 = 1000 Bytes Ram f√¶r
.set heap = heap + TV_XSize*TV_YSize	;den Videospeicher mit Startadr: TV_DDRAM

; Erm√glicht Zugriff auf Videoram
.include "minimal.asm"

; ***************************************************************************
; INTERRUPT ROUTINE
; ***************************************************************************

TV_OC1A_isr:							;Beginn IRQ alle 64us


	push TV_temp0
	in TV_temp0, sreg
	push TV_temp0						;TV_temp0+SREG aus Hauptprg. sichern

	ldi TV_temp0, TV_YSize
	cp TV_Y_Cnt, TV_temp0					;Bildbereich oder schon VSync + Zubeh√r ?

;	brsh TV_handle_VSync					; ---> ***** V S Y N C *****

brlo TV_GoLine
rjmp TV_handle_VSync
TV_GoLine:


	push ZL							;Z-Reg aus Hauptprg. sichern
	push ZH

;###############
;rjmp TV_comp_down

; ------------- Zur korrektur, falls IRQ f√¶r kurze Zeit blockiert war.----------
	in ZL, TCNT1L						;Timerwert lesen;
	in ZH, TCNT1H
;	subi ZL, low(TV_XStart-10-TV_comp)			;und Korrekturwert berechnen
;	sbci ZH, high(TV_XStart-10-TV_comp)
	subi ZL, low(TV_XStart+5-TV_comp_down)			;und Korrekturwert berechnen
	sbci ZH, high(TV_XStart+5-TV_comp_down)

ldi TV_temp0,high(TV_comp_down)
cpi ZL,low(TV_comp_down)
cpc ZH,TV_temp0
brsh TV_comp_down
nop
	ijmp 							;Wartezeit korrigieren

TV_comp_up:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	nop ; 15xnop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
TV_comp_down:

; ------------------------------------------------------------------------------



	push TV_temp1						;TV_temp1 aus Hauptprg. sichern

	push XL							;X-Reg aus HP sichern.
	push XH

	movw XL,TV_XL_Bak; = mov XL,TV_XL_Bak & mov XH,TV_XH_Bak		;X-Reg aus Backup wiederherstellen.
	mov ZH,TV_ZH_Bak						;ZH-Reg aus Backup wiederherst.

	ldi TV_temp1, TV_XSize					; Zeichen pro Zeile laden


TV_hloop:								;Loop f√¶r 1 Zeile
	ld ZL, X+						;ASCII aus RAM lesen		2
	lpm TV_temp0, Z						;Byte aus CGROM lesen		3
	out SPDR, TV_temp0					;Byte ausgeben			1
	sbi DDRB,MOSI						;SPI an, Port aus		2

	nop							;				1
	nop							;				1
	nop							;				1
	nop							;				1
	nop							;				1
	nop							;				1
	nop							;				1


	dec TV_temp1						;				1
	brne TV_hloop						;				2
								; 				=18
								;	, also 16 (f√¶r 1 Byte) + Pause dazwischen
	nop
	nop
	nop
	nop
	nop
	nop
	cbi DDRB,MOSI						;SPI abschalten

	cpi ZH,high(TV_CharRom*2)+TV_Height-1			;Schon bei Scanzeile 8 angekommen?
	breq TV_skipcloop						;dann ist eine Textzeile fertig


	inc ZH							;Nein -> Bilddatenadresse f√¶r n√Òchste Pixelzeile laden und
	subi XL, low(TV_XSize)					;Textadresse wieder an Anfang der Textzeile setzen
	sbci XH, high(TV_XSize)	;
	rjmp TV_exit_linedraw

TV_skipcloop:							;Alles f√¶r neue Textzeile einrichten
	ldi ZH, high(TV_CharRom*2)				;CGROM Offset ( mal 2, da jetzt in Byte)
	inc TV_Y_Cnt						;Zeilencounter erh√hen
	rjmp TV_exit_linedraw



TV_handle_VSync:					; ***** V S Y N C *****
	inc TV_Y_Cnt					;Zeilenz√Òhler erh√hen

	ldi TV_temp0, TV_VSStart			;Beginn VSync ?
	cp TV_Y_Cnt, TV_temp0				;
	breq TV_VSync_start				; @@@1@@@

	ldi TV_temp0, TV_BPStart			;Ende VSync ?
	cp TV_Y_Cnt, TV_temp0				;
	breq TV_VSync_ende				; @@@2@@@

	ldi TV_temp0, TV_BildStart			;Bildende ?
	cp TV_Y_Cnt, TV_temp0				;
	brsh TV_Bildbeginn				; @@@3@@@

	pop TV_temp0
	out sreg, TV_temp0				;SREG zur√¶cksichern
	pop TV_temp0					;TV_temp0 zur√¶cksichern
reti	; INTERRUPT ENDE

TV_VSync_start:	; @@@1@@@
	ldi TV_temp0, (1<<COM1B1)|(0<<COM1B0)|(1<<WGM11)|(1<<WGM10)
	out TCCR1A, TV_temp0				;VSync Start: Sync Impulse High aktiv

	pop TV_temp0
	out sreg, TV_temp0				;SREG zur√¶cksichern
	pop TV_temp0					;TV_temp0 zur√¶cksichern
reti	; INTERRUPT ENDE

TV_VSync_ende:	; @@@2@@@
	ldi TV_temp0, (1<<COM1B1)|(1<<COM1B0)|(1<<WGM11)|(1<<WGM10)
	out TCCR1A, TV_temp0				;VSync Ende: Sync Impulse Low aktiv

	pop TV_temp0
	out sreg, TV_temp0				;SREG zur√¶cksichern
	pop TV_temp0					;TV_temp0 zur√¶cksichern
reti	; INTERRUPT ENDE

TV_Bildbeginn:	; @@@3@@@
	clr TV_Y_Cnt					;Zeilenz√Òhler auf Anfang
	ldi TV_temp0, low(TV_DDRAM)			;Zeichenindex (X-Reg) auf 
	mov TV_XL_Bak,TV_temp0				;Anfang Video-Ram
	ldi TV_temp0, high(TV_DDRAM)
	mov TV_XH_Bak,TV_temp0

	pop TV_temp0
	out sreg, TV_temp0				;SREG zur√¶cksichern
	pop TV_temp0					;TV_temp0 zur√¶cksichern
reti	; INTERRUPT ENDE

TV_exit_linedraw:
	movw TV_XL_Bak,XL; = mov TV_XL_Bak,XL & mov TV_XH_Bak,XH	;X-Reg in Backup sichern.
	mov TV_ZH_Bak,ZH						;ZH-Reg in Backup sichern	

	pop XH						;X-Reg und
	pop XL

	pop TV_temp1					;zur√¶cks.

	pop ZH						;Y-Reg zur√¶cks.
	pop ZL

	pop TV_temp0
	out sreg, TV_temp0				;SREG zur√¶cksichern
	pop TV_temp0					;TV_temp0 zur√¶cksichern
reti	; INTERRUPT ENDE
	
; ***************************************************************************
; INTERRUPT ENDE
; ***************************************************************************




;****************************************************************************
;	Initialisierung von Speicher und PWM/OCA1 etc.
;****************************************************************************

device_init:					;setup Ram+Register f√¶r TV_Out

push XH
push XL
push TV_temp0
push TV_temp1


;ser TV_temp0
;out portd, TV_temp0

;clr TV_temp0
;out portb, TV_temp0


.if mega16 == 1 
; ##### MEGA 16 oder MEGA 32 #####

sbi DDRB, SS
sbi DDRB, MOSI
sbi DDRD, Sync

; ################################
.else 
; ############# MEGA 8 ###########

sbi DDRB, SS
sbi DDRB, MOSI
sbi DDRB, Sync

; ################################
.endif 


; ##### SPI Initialisierung ######
ldi TV_temp0, (1<<SPE)|(1<<MSTR)|(1<<CPHA)		;fclk/2 Schiebetakt
out SPCR, TV_temp0					;Enable SPI Slave, Interrupt
sbi SPSR, SPI2X

; ##### Timer & PWM Initialisierung #####
ldi TV_temp0, high(1024)				;Timer Reloadwert
out ICR1H, TV_temp0

ldi TV_temp0, low(1024)					;Timer Reloadwert
out ICR1L, TV_temp0

ldi TV_temp0, high(TV_SyncWidth)			;HSync Breite in CPU Takten
out OCR1BH, TV_temp0

ldi TV_temp0, low(TV_SyncWidth)				;HSync Breite in CPU Takten
out OCR1BL, TV_temp0

ldi TV_temp0, high(TV_XStart-30)			;H Shift
out OCR1AH, TV_temp0

ldi TV_temp0, low(TV_XStart-30)				;H Shift
out OCR1AL, TV_temp0

ldi TV_temp0, (1<<COM1B1)|(1<<COM1B0)|(1<<WGM11)|(1<<WGM10)
out TCCR1A, TV_temp0

ldi TV_temp0, (1<<WGM12)|1				;10bit PWM bei 16MHz: 15,625kHz
out TCCR1B, TV_temp0

ldi TV_temp0, (1<<OCIE1A)				;TV_compareA Interrupt: Beginn der Datenausgabe
out timsk, TV_temp0


; ********* RAM init ****************

; TESTBILD LADEN
ldi XL, low(TV_DDRAM)					;Ziel
ldi XH, high(TV_DDRAM)
clr TV_temp0
TV_clrloop:						;L√schen
	st X+, TV_temp0
	inc TV_temp0
	ldi TV_temp1, high(TV_XSize*TV_YSize+TV_DDRAM)
	cpi XL, low(TV_XSize*TV_YSize+TV_DDRAM)
	cpc XH, TV_temp1
	brne TV_clrloop
; TESTBILD ENDE

; Zeichenindex im IRQ initialisieren
ldi TV_temp0,low(TV_DDRAM)
mov TV_XL_Bak,TV_temp0
ldi TV_temp0,high(TV_DDRAM)
mov TV_XH_Bak,TV_temp0


ldi TV_temp0, (1<<OCF1A)				;Interrupt Flag l√schen
out TIFR, TV_temp0

;damit auch wirklich ein Bild kommt ist noch der sei-Befehl n√tig!!!
;sei

pop TV_temp1
pop TV_temp0
pop XL
pop XH

ret	;ende init

;****************************************************************************
;	Initialisierung Ende
;****************************************************************************

;****************************************************************************
;****************************************************************************
;****************************************************************************
;****************************************************************************
;****************************************************************************
;****************************************************************************

.include "amforth.asm"
