;
;  Support file for Atmel 25256/25512 and Microchip 25LC256/25LC512
;  serial EEPROMs.
;
;  This file also supports the Ramtron FM25H20 FRAM devices.
;
;  This file MUST be included if you also include any additional files
;  of the form 25xxx_nnn.asm.
;

; ( -- wval ) Custom Constant
; R( -- )
;
; 25xxx EEPROM command: 25XXX_WREN  (write-enable)
;
VE_25XXX_WREN:
	.dw $ff0a
	.db "25XXX_WREN"
	.dw VE_HEAD
	.set VE_HEAD=VE_25XXX_WREN
XT_25XXX_WREN:
	.dw PFA_DOVARIABLE
PFA_25XXX_WREN:
	.dw $06


; ( -- wval ) Custom Constant
; R( -- )
;
; 25xxx EEPROM command: 25XXX_WRDI  (write-disable)
;
VE_25XXX_WRDI:
	.dw $ff0a
	.db "25XXX_WRDI"
	.dw VE_HEAD
	.set VE_HEAD=VE_25XXX_WRDI
XT_25XXX_WRDI:
	.dw PFA_DOVARIABLE
PFA_25XXX_WRDI:
	.dw $04



; ( -- wval ) Custom Constant
; R( -- )
;
; 25xxx EEPROM command: 25XXX_RDSR  (read status register)
;
VE_25XXX_RDSR:
	.dw $ff0a
	.db "25XXX_RDSR"
	.dw VE_HEAD
	.set VE_HEAD=VE_25XXX_RDSR
XT_25XXX_RDSR:
	.dw PFA_DOVARIABLE
PFA_25XXX_RDSR:
	.dw $05



; ( -- wval ) Custom Constant
; R( -- )
;
; 25xxx EEPROM command: 25XXX_WRSR  (write status register)
;
VE_25XXX_WRSR:
	.dw $ff0a
	.db "25XXX_WRSR"
	.dw VE_HEAD
	.set VE_HEAD=VE_25XXX_WRSR
XT_25XXX_WRSR:
	.dw PFA_DOVARIABLE
PFA_25XXX_WRSR:
	.dw $01



; ( -- wval ) Custom Constant
; R( -- )
;
; 25xxx EEPROM command: 25XXX_READ  (read)
;
VE_25XXX_READ:
	.dw $ff0a
	.db "25XXX_READ"
	.dw VE_HEAD
	.set VE_HEAD=VE_25XXX_READ
XT_25XXX_READ:
	.dw PFA_DOVARIABLE
PFA_25XXX_READ:
	.dw $03



; ( -- wval ) Custom Constant
; R( -- )
;
; 25xxx EEPROM command: 25XXX_WRITE  (write)
;
VE_25XXX_WRITE:
	.dw $ff0b
	.db "25XXX_WRITE", 0
	.dw VE_HEAD
	.set VE_HEAD=VE_25XXX_WRITE
XT_25XXX_WRITE:
	.dw PFA_DOVARIABLE
PFA_25XXX_WRITE:
	.dw $02



; ( -- wval ) Custom Constant
; R( -- )
;
; 25xxx EEPROM command: 25XXX_RDID  (read ID, exit deep-power down [Microchip devices only])
;
VE_25XXX_RDID:
	.dw $ff0a
	.db "25XXX_RDID"
	.dw VE_HEAD
	.set VE_HEAD=VE_25XXX_RDID
XT_25XXX_RDID:
	.dw PFA_DOVARIABLE
PFA_25XXX_RDID:
	.dw $ab


; hex
;
;  6  constant  SEE_WREN
;  4  constant  SEE_WRDI
;  5  constant  SEE_RDSR
;  1  constant  SEE_WRSR
;  3  constant  SEE_READ
;  2  constant  SEE_WRITE
; AB  constant  SEE_RDID         \ Microchip 25LCxxx only; remove from deep power-down 

