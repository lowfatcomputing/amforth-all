\ basic twi operations

\ _twi_
marker _twi_

\ twi addresses for the ATmega32
decimal
86 constant TWCR
35 constant TWDR
34 constant TWAR
33 constant TWSR
32 constant TWBR
19 constant TWSIaddr \ Irq. vector address for Two-Wire Interface


hex

\ enable twi
: +twi ( prescaler bitrate  -- )
    TWBR c! 
    03 and TWSR c!
;

\ some random initialization. Works fine with 8 MHz
: twidefault
    7f 3 +twi ;

\ turn off twi
: -twi ( -- )
    0 TWCR c!
;


TWCR 7 portpin: TWINT  \ signal TWI complete
TWCR 6 portpin: TWEA   \ enable ACK 
TWCR 5 portpin: TWSTA  \ send START condition
TWCR 4 portpin: TWISTO \ send STOP condition
TWCR 2 portpin: TWIEN

\ wait for twi finish
: twiwait ( -- )
    begin
        TWINT is_high?
    until
;

\ send start condition
: twistart ( -- )
    [ 1 7 lshift
      1 5 lshift or 
      1 2 lshift or ] literal
    TWCR c!
    twiwait
;

\ send stop condition
: twistop ( -- )
    [ 1 7 lshift
      1 4 lshift or 
      1 2 lshift or ] literal
    TWCR c!
    \ no wait for completion.
;
\ process the data 
: twiaction
    [
	1 7 lshift 
	1 2 lshift or
    ] literal or
    TWCR c!
    twiwait
;

\ send 1 byte via twi
: twitx ( c -- )
    TWDR c!
    0 twiaction
;

\ receive 1 byte, send ACK
: twirx ( -- c )
    1 6 lshift  \ TWEA
    twiaction
    TWDR c@
;

\ receive 1 byte, send NACK
: twirxn ( -- c )
    0 twiaction
    TWDR c@
;

\ \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\ \       switch to hex          \
\ \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

hex

\ get twi status
: twistatus ( -- n )
    TWSR c@
    f8 and
;

\ compare twi status with desired result, throw
\ an exception if not met
: twistatus?
    twistatus over <> 
    if 
	u. -3 throw 
    else
	drop
    then

;

\ detect presence of a device on the bus
: twi-ping?   ( addr -- f )
    1 lshift
    twistart 
    twitx
    twistatus 
    18 =
    twistop 
;

\ detect presence of all possible devices on I2C bus
: twi-scan-bus   ( -- )
    7f 0 do
	i dup          \ Test even addressess: write action only.
        twi-ping? if            \ does device respond?
            2* u. ."   found" cr
	else
	    drop 
        then
    loop 
;
