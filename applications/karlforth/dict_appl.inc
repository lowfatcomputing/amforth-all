; this dictionary contains optional words
; they may be moved to the core dictionary if needed

.include "dict_minimum.inc"				; <-- required!
.include "words/fill.asm"
.include "words/d-2star.asm"
.include "words/d-plus.asm"
.include "words/d-minus.asm"
.include "words/d-invert.asm"
.include "words/udot.asm"
.include "words/udotr.asm"
.include "words/dot-s.asm"

.include "words/dotstring.asm"
.include "words/squote.asm"

.include "words/words.asm"

.include "words/set-current.asm"		; needed by marker.frt or marker.asm
.include "words/set-order.asm"			; needed by marker.frt or marker.asm

.include "words/edefer.asm"
.include "words/rdefer.asm"
.include "words/is.asm"

.include "applturnkey.asm"
.include "words/int-store.asm"
.include "words/1ms.asm"
.include "words/ms.asm"

.include "dict_compiler.inc"
.include "words/show-wordlist.asm"
.include "device.inc"
.include "dict_usart.inc"

;
;  Additional words (outside the standard amforth release)
;

;.include "custom/board_328p_25LC512.asm"	; include board port definitions
.include "custom/board_644p_fm25h20.asm"	; include board port definitions

.include "custom/spi_init.asm"			; SPI support
.include "custom/spi_xchg.asm"			; SPI support
.include "custom/spi_send.asm"			; SPI support
.include "custom/marker.asm"			; provided by Al Williams, amforth dev list

.include "custom/25xxx.asm"				; constants for 25xxx serial EEPROM support
.include "custom/25xxx_sendaddr.asm"	; 25xxx support
.include "custom/25xxx_enable.asm"		; 25xxx support
.include "custom/25xxx_disable.asm"		; 25xxx support
.include "custom/25xxx_init.asm"		; 25xxx support
.include "custom/25xxx_wait_rdy.asm"	; 25xxx support
.include "custom/25xxx_cstore.asm"		; 25xxx support
.include "custom/25xxx_store.asm"		; 25xxx support
.include "custom/25xxx_cfetch.asm"		; 25xxx support
.include "custom/25xxx_cfetchblk.asm"	; 25xxx support
.include "custom/25xxx_cstoreblk.asm"	; 25xxx support
.include "custom/25xxx_prot.asm"		; 25xxx support
.include "custom/save_eeprom.asm"		; system save
.include "custom/save_flash.asm"		; system save
.include "custom/save_system.asm"		; system save
.include "custom/at_xy.asm"				; ANSI support
.include "custom/erasedata.asm"			; ANSI support
.include "custom/cls.asm"				; ANSI support
.include "custom/sleep.asm"				; power-save support
.include "custom/block.asm"				; editor
.include "custom/blk.asm"				; editor
.include "custom/scr.asm"				; editor
.include "custom/blkbuffer.asm"			; editor
.include "custom/blkoffset.asm"			; editor
.include "custom/blk2seeaddr.asm"		; editor
.include "custom/write-blk.asm"			; editor
.include "custom/read-blk.asm"			; editor
.include "custom/dir.asm"				; editor
.include "custom/wipe-scr.asm"			; editor
.include "custom/list.asm"				; editor
.include "custom/copy.asm"				; editor
.include "custom/inp.asm"				; editor
.include "custom/text.asm"				; editor
.include "custom/open.asm"				; editor
.include "custom/load.asm"				; editor
.include "custom/loadarrow.asm"			; editor

