\ spi routines

marker _spi_

hex

PORTB 0 portpin: SS \ if SPI slave
PORTB 1 portpin: SCK
PORTB 2 portpin: MOSI
PORTB 3 portpin: MISO

\ following is for butterfly dataflash
PORTE 7 portpin: BF_DF_RESET
PORTB 0 portpin: BF_DF_CS

\ enable spi
: spi ( -- )
    BF_DF_RESET is_output
    BF_DF_CS    is_output
    MOSI is_output
    SCK  is_output
    MISO is_input
    SS   is_output \ see appnotes, input could disturb SPI
    
    BF_DF_RESET low
    BF_DF_CS high
    1ms
    BF_DF_CS low
    BF_DF_RESET high

    [
        1 6 lshift    \ SPE
	1 4 lshift or \ MSTR
	1 3 lshift or \ SPOL
	1 2 lshift or \ SPHA
    ] literal SPCR c!   \ master mode 3 
    1 SPSR c! \ double speed mode
    20 0 do 1ms loop \ wait blindly for hardware operations
;

\ turn off spi
: /spi ( - )
    0 SPCR c!
;

\ wait for current spi transaction
: waitspi
    begin
	SPSR c@
 	[ 1 7 lshift ] literal and
    until
;

\ transfer 1 byte via spi
: spirw ( tx -- rx )
    SPDR c! ( -- )
    waitspi
    SPDR c@ ( -- rx )
;

\ send 1 byte byte
: spitx ( tx -- ) 
    spirw drop
;

\ receive byte
: spirx ( -- rx ) 
    0 spirw
;

\ Status register read
: df-status  ( -- n ) 
    [ hex ] 57 spitx spirx 
;

\ wait till df is ready again
: df-wait ( -- )
  begin 
    df-status [ hex ] 80 and 
  until
;

decimal
9 constant BF_DF_PAGEBITS
264 constant BF_DF_PAGESIZE

\ \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

variable df-buffer 264 allot

\ transfer page from eeprom to ram
: df-block1
    BF_DF_CS toggle \ attention please
    [ hex ] 53 ( DF_MAIN_MEM_PAGE_TO_BUF1_XFER ) spitx
    dup 
    [ decimal 16 BF_DF_PAGEBITS - ] 
	literal rshift \ upper part
	spitx 
    [ BF_DF_PAGEBITS 8 - ] 
	literal lshift \ lower part
	spitx
    0 spitx
    BF_DF_CS toggle \ aaand action!
    df-wait
;
: df-block2
    \ now read the page from buffer 1 to ram
    [ hex ] 54 ( DF_BUF1_READ ) spitx
    0 spitx \ don't care
    0 spitx \ address 
    0 spitx \ address
    0 spitx \ don't care
    df-buffer
    BF_DF_PAGESIZE  0 do ( -- )
	spirx ( -- addr n )
	over i + c! 
    loop
    BF_DF_CS toggle \ stop transfer
    drop
;
    
: df-block ( u -- )
    df-block1
    df-block2
;


: df-flush1
    BF_DF_CS toggle \ attention please
    [ hex ] 84 ( DF_BUF1_WRITE ) spitx
    0 spitx \ dont't care
    0 spitx \ address byte
    0 spitx \ address byte
    df-buffer
    BF_DF_PAGESIZE  0 do ( -- u addr )
	dup i + c@  ( -- u addr c )
	spitx       ( -- addr )
    loop
    drop
;

: df-flush2 ( u -- )
    BF_DF_CS toggle \ attention please
    [ hex ] 83 ( DF_BUF1_TO_FLASH_WE ) spitx
    dup 
    [ decimal 16 BF_DF_PAGEBITS - ] 
	literal rshift \ lower part
	spitx 
    [ BF_DF_PAGEBITS 8 - ] 
	literal lshift \ high part
	spitx
    0 spitx \ don't care
    BF_DF_CS toggle \ aaaand action!
    df-wait
;

: df-flush ( u -- )
    df-flush1
    df-flush2
;
