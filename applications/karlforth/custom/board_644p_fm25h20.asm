;
;  board_644p_fm25h20.asm
;
;  This file defines the port and bit assignments for I/O attached
;  to the ATmega644P with Ramtron FM25H20 for mass storage.
;

;
;  Each port definition should be the assembler equivalent of:
;
;  PORTx  constant  MyPort
;
;  where PORTx can be any of the I/O ports on your target MCU and
;  MyPort is the name you want to give that port.  Names for the
;  ports (PORTx) are predefined; refer to the device.inc file in
;  the appropriate folder in the \devices folder.  For example,
;  if the chip-select for a DS1337 RTC is bit 4 on port B, you might
;  define the associated ports for that device as:
;
;  PORTB  constant  DS1337_CS_PORT
;  DDRB   constant  DS1337_CS_DDR
;  PINB   constant  DS1337_CS_PIN
;
;  In order to build the above definitions into an amforth kernel,
;  these definitions must be coded in the assembly language format
;  used by native amforth words.  For example, here is how the DDR
;  port above would be coded:
;
; VE_DS1337_CS_DDR:
; 	.dw		$ff0d					; <-- LSB must be length of name that follows
; 	.db		"DS1337_CS_DDR", 0		; <-- name; add ", 0" only if name is odd length
; 	.dw		VE_HEAD
; 	.set	VE_HEAD=VE_DS1337_CS_DDR
; XT_DS1337_CS_DDR:
;	.dw		PFA_DOVARIABLE
; PFA_DS1337_CS_DDR:
; 	.dw		(DDRB+$20)
;


;
;  Define equates for the hardware-specific elements of the design.
;
	.equ PIN_BOOTSEL = PINB				; port for reading the boot selector line
	.equ BIT_BOOTSEL = 3				; bit on the boot selector port for selection


	.equ DDR_SPI = DDRB					; DDR that controls the SPI interface lines
	.equ PORT_SPI = PORTB				; port that contains the SPI interface lines
	.equ SCK = 7						; port B bit for SCK ('644P)
	.equ MOSI = 5						; port B bit for MOSI ('644P)

;
;  Define the chip-select line used for the first 25xxx serial
;  EEPROM.
;
	.set  SEE_CS_A_BIT = 4
	.set  SEE_CS_A_PORT = PORTB
	.set  SEE_CS_A_DDR = DDRB



;
;  The following words define the I/O port (such as PORTB) holding
;  the SPI-specific I/O lines (such as MOSI and SCK).  These port
;  locations vary, based on the target chip.
;
;  The port addresses must be defined for use with c@.  This normally
;  means you must use the base address of the port + $20.
;
;  (I believe these words should be part of the device.inc for each chip.)
;
VE_PORTSPI:
	.dw 	$ff07
	.db 	"PORTSPI",0
	.dw 	VE_HEAD
	.set	VE_HEAD=VE_PORTSPI
XT_PORTSPI:
	.dw		PFA_DOVARIABLE
PFA_PORTSPI:
	.dw		(PORT_SPI+$20)			; <-- have to add $20 because of how c@ is implemented


VE_DDRSPI:
	.dw 	$ff06
	.db 	"DDRSPI"
	.dw 	VE_HEAD
	.set	VE_HEAD=VE_DDRSPI
XT_DDRSPI:
	.dw		PFA_DOVARIABLE
PFA_DDRSPI:
	.dw		(DDR_SPI+$20)			; <-- have to add $20 because of how c@ is implemented




;
;  Define words that describe how the first 25xxx serial EEPROM
;  is wired in the target.  For each such chip, you must define
;  four words; these words define the I/O port, DDR, bit, and an
;  or-mask for setting that bit.
;
;  The chip-select line for the first 25xxx serial EEPROM is
;  designated in these source files as 25XXX_CS_A.  If you need
;  to add more serial EEPROMs, increment the trailing 'A' for
;  each device (25XXX_CS_B, etc.).
;

VE_25XXX_CS_A_PORT:
	.dw 	$ff0f
	.db 	"25XXX_CS_A_PORT", 0
	.dw 	VE_HEAD
	.set	VE_HEAD=VE_25XXX_CS_A_PORT
XT_25XXX_CS_A_PORT:
	.dw		PFA_DOVARIABLE
PFA_25XXX_CS_A_PORT:
	.dw		(SEE_CS_A_PORT+$20)		; <-- have to add $20 because of how c@ is implemented


VE_25XXX_CS_A_DDR:
	.dw 	$ff0e
	.db 	"25XXX_CS_A_DDR"
	.dw 	VE_HEAD
	.set	VE_HEAD=VE_25XXX_CS_A_DDR
XT_25XXX_CS_A_DDR:
	.dw		PFA_DOVARIABLE
PFA_25XXX_CS_A_DDR:
	.dw		(SEE_CS_A_DDR+$20)		; <-- have to add $20 because of how c@ is implemented


VE_25XXX_CS_A_BIT:
	.dw 	$ff0e
	.db 	"25XXX_CS_A_BIT"
	.dw 	VE_HEAD
	.set	VE_HEAD=VE_25XXX_CS_A_BIT
XT_25XXX_CS_A_BIT:
	.dw		PFA_DOVARIABLE
PFA_25XXX_CS_A_BIT:
	.dw		SEE_CS_A_BIT			; must match mask declaration below


VE_25XXX_CS_A_MASK:
	.dw 	$ff0f
	.db 	"25XXX_CS_A_MASK", 0
	.dw 	VE_HEAD
	.set	VE_HEAD=VE_25XXX_CS_A_MASK
XT_25XXX_CS_A_MASK:
	.dw		PFA_DOVARIABLE
PFA_25XXX_CS_A_MASK:
	.dw		(1<<SEE_CS_A_BIT)		; must match bit declaration above


;
;  Define the number of bytes used by the serial EEPROM device for an
;  address.  Those devices with 16-bit addresses, such as the 25LC512,
;  use two address bytes.  Larger devices, such as the FM25H20 FRAM, use
;  three address bytes.  Check the chip's technical reference for the
;  number of address bytes to use for commands such as READ or WRITE.
;
	.set SEE_ADDR_BYTES = 3

;
;  Define the number of bytes in the serial EEPROM page.
;  For AT25128 and AT25256, this is $40.
;  For 25LC256 and 25LC512, this is $80.
;  For Ramtron FM25H20, this value is meaningless and can be set to some large
;  value, such as $4000.
;
	.set SEE_PAGE_BYTES = $4000

;
;  Define the number of bytes in the serial EEPROM.
;
	.set SEE_SIZE_BYTES = 262144

;
;  Define the starting address in serial EEPROM for the
;  editor screens.
;
	.set SEE_EDITOR_START_ADDR = $8000

;
;  Define the number of 1024-byte blocks to use for editor
;  screens.  Block 0 will start at address SEE_EDITOR_START_ADDR.
;
	.set SEE_EDITOR_NUM_OF_BLOCKS = ((SEE_SIZE_BYTES-SEE_EDITOR_START_ADDR)/1024)
