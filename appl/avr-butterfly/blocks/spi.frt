\ spi routines

marker _spi_

hex

PORTB 1 0 lshift portpin SS \ if SPI slave
PORTB 1 1 lshift portpin SCK
PORTB 1 2 lshift portpin MOSI
PORTB 1 3 lshift portpin MISO

\ following is for butterfly dataflash
PORTE 1 7 lshift portpin BF_DF_RESET
PORTB 1 0 lshift portpin BF_DF_CS


\ enable spi
: spi ( -- )
    BF_DF_RESET mode_output
    BF_DF_CS    mode_output
    MOSI mode_output
    SCK  mode_output
    MISO mode_input
    SS mode_output \ see appnotes, input could disturb SPI
    
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
    \ toggle the chip select pin 
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
