\ handle serial I2C EEPROM
\ currently only 24c128 is tested, other 2 byte address
\ chips should work as well.

\ #include twi.frt

\ _twieeprom_

marker _twieeprom_

hex

A0 value i2cee-addr    \ twi address of the eeprom
40 value i2cee-b/blk   \ bytes per block
 2 value i2cee-addrlen \ number of bytes for address

\ set the read bit in the address 
: set-rw ( addr -- addr+r )
    1 or
;

\ store a byte at a given location
: twi-c! ( c addr -- )
    \ send device address
    i2cee-addr
    twistart
    twitx 18 twistatus?
    \ send eeprom cell address, high part first
    dup ><
    twitx 28 twistatus?
    twitx 28 twistatus?
    \ send data byte 
    twitx 28 twistatus?
    twistop
;

\ fetch a single byte
: twi-c@ ( addr -- c )
    i2cee-addr
    twistart
    twitx 18 twistatus?
    dup ><
    twitx 28 twistatus?
    twitx 28 twistatus?
    \ repeated start to read the data bye
    twistart 10 twistatus?
    i2cee-addr set-rw twitx 40 twistatus?
    twirxn 58 twistatus?
    twistop
;

\ transfer a whole page (64 bytes) from RAM to the EEPROM address.
\ the lower 6 address bits are cleared
: twi-writepage ( addr page -- )
    i2cee-addr
    twistart    
    twitx 18 twistatus?
    ffc0 and \ mask the lower 6 bits
    dup ><
    twitx 28 twistatus?
    twitx 28 twistatus?
    i2cee-b/blk 0 ?do
	dup c@ dup u.
	i 10 mod 0= if cr i u. then
	twitx 28 twistatus?
	1+
    loop
    drop
    twistop
;

\ read len bytes from the EEPROM and dump them onto
\ screen.
: twi-dump ( addr len -- )
    i2cee-addr
    twistart    
    twitx 18 twistatus?
    swap ( --  len addr )
    dup ><
    twitx 28 twistatus?
    twitx 28 twistatus?
    \ repeated start to receive the data bytes
    twistart 10 twistatus?
    i2cee-addr set-rw twitx 40 twistatus?
    cr 1- 0 ?do
	i 10 mod 0= if cr then
	twirx u. 50 twistatus?
    loop
    twirxn u. 58 twistatus?
    twistop
;

\ some test cases
twidefault

up@ i2cee-b/blk + 0 twi-writepage
  0 i2cee-b/blk     twi-dump
