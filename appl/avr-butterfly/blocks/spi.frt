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
    
    BF_DF_RESET off
    BF_DF_CS on
    1ms
    BF_DF_CS off
    BF_DF_RESET on

    1 SPSR c! \ double speed mode
    [
        1 6 lshift    \ SPE
	1 4 lshift or \ MSTR
	1 3 lshift or \ SPOL
    ] literal SPCR c!   \ master mode an clk/2 sample on falling edge
    
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
	1 7 lshift and
    until
;

\ transfer 1 byte via spi
: spix ( tx cs -- rx )
    \ toggle the chip select pin, probably counter-productive
    dup on  ( -- tx cs )
    dup off ( -- tx cs )
    swap    ( -- cs tx )
    SPDR c! waitspi
    SPDR c@ ( -- cs rx )
    swap    ( -- rx cs )
    on      ( -- rx)
;

\ send 1 byte byte
: spitx ( tx cs -- ) 
    spix
    drop
;

\ receive byte
: spirx ( cs -- rx ) 
    0 spix
;
