
\ #include twi.frt

\ _twieeprom_

marker _twieeprom_

hex

A0 value i2cee-addr    \ twi address of the eeprom
40 value i2cee-b/blk   \ bytes per block
 
: set-rw
    1 or
;

\ directly address a single byte
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

\ work on a page. a page is the operational unit
\ the eeprom works with internally. It's size is
\ defined with i2cee-b/blk. The pages are numbered
\ from 0 upward. page 1 has the starting address 
\ i2cee-b/blk.

: block2addr ( pagenumber -- pageaddress )
    i2cee-b/blk log2 lshift ;
;

: twi-saveblock ( ramaddr pagenumber -- )
    i2cee-addr
    twistart    
    twitx 18 twistatus?
    block2addr
    i2cee-b/blk 1- invert and \ mask the lower bits
    dup ><
    twitx 28 twistatus?
    twitx 28 twistatus?
    i2cee-b/blk 0 ?do
	dup 
	c@ twitx 28 twistatus?
	1+
    loop
    drop
    twistop
;

: twi-loadblock ( addr pagenumber -- )
    i2cee-addr
    twistart    
    twitx 18 twistatus?
    block2addr
    i2cee-b/blk 1- invert and \ mask the lower bits
    dup ><
    twitx 28 twistatus?
    twitx 28 twistatus?
    \ repeated start to receive the data bytes
    twistart 10 twistatus?
    i2cee-addr set-rw twitx 40 twistatus?
    i2cee-b/blk 1- 0 ?do
	twirx 50 twistatus?
	over c! 1+
    loop
    twirxn 58 twistatus? swap c!
    twistop
;

\ twidefault

\ up@ 0 twi-saveblock
\ pad 0 twi-loadblock 
\ pad i2cee-b/blk dump
