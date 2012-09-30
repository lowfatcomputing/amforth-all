\ 2009-12-23  EW  ewlib/1wire.fs
\ 2011-10-31  EW  i@ -> @i, amforth 4.6

\ dallas ds2482 i2c--1wire controller   www.maxim-ic.com
\ there are max.2 of these controllers on one bus ($30, $32),
\ $32 constant a_1w

\ status register:7..0: DIR TSB SBR RST  LL SD PPD 1WB
1   constant 1w.sr.1WB
$f0 constant 1w.cmd.dreset
$b4 constant 1w.cmd.owreset
$a5 constant 1w.cmd.wb       \ cmd write one byte
$96 constant 1w.cmd.rb       \ cmd read one byte
$e1 constant 1w.cmd.srp      \ cmd set read pointer

$33 constant 1w.cmd.readrom  \ cmd read rom
$cc constant 1w.cmd.skiprom  \ cmd skip rom (no address needed)
$55 constant 1w.cmd.matchrom \ cmd match rom, address will follow

$44 constant 1w.cmd.startconversion
$be constant 1w.cmd.readdata

\ i2c device reset
: 1w.dreset ( -- )  1w.cmd.dreset 1 a_1w >i2c ;
\ : 1w.wait   ( -- )  begin 1 a_1w <i2c  1w.sr.1WB and 0= until ;
\ diese Version tut zwar vielleicht, bei 1w.read,write ist aber Essig,
\ weil da ungewollte stop-Bedingungen gesetzt werden.
\ Da muß man einen level weiter runter, twi.* statt >i2c
\ Und es erklärt auch, WARUM das byte nach der Schleife nochmal
\ gelesen werden soll (Zeichnung in der Doku)
: (1w.wait)
  twi.start
  a_1w 1+ twi.tx                      \ send addr | W
  begin
        pause 
        twi.rx 1w.sr.1WB and 0= until \ read status until 1WB==0
  twi.rxn  drop                       \ read again, send NACK
;
\ fixme: Schleife zählen für den Notausstieg
: 1w.wait ( -- )  (1w.wait)  twi.stop ;

: 1w.reset ( -- )
  twi.start a_1w twi.tx
  1w.cmd.owreset twi.tx
  1w.wait
;

: 1w.write ( x -- )
  twi.start a_1w twi.tx
  1w.cmd.wb twi.tx
  ( x ) twi.tx
  1w.wait
;

: 1w.read ( -- x )
  twi.start a_1w    twi.tx 1w.cmd.rb  twi.tx
  (1w.wait) \ no twi.stop here!
  twi.start a_1w    twi.tx 1w.cmd.srp twi.tx $e1 twi.tx
  twi.start a_1w 1+ twi.tx twi.rxn
  twi.stop
;

: >1w ( xN .. x1 N -- )  0 ?do 1w.write loop ;
: <1w ( N -- x1 .. xN )  0 ?do 1w.read  loop ;

\ --- read, print SerialNumber -------------------------------
: 1w.read_SN ( -- x1=fam.code .. x8=crc )
  1w.reset
  1w.cmd.readrom 1 >1w
  8 <1w
;
: 1w.SNr ( x1=fam.code .. x8=crc -- )
  hex
  7 pick 2 u0.r $2e emit
  1 6 do i pick 2 u0.r -1 +loop  $2e emit
  2 u0.r 
  7 0 do drop loop
; 
: 1w.SN ( x8=crc .. x1=fam.code -- )
  hex
  2 u0.r $2e emit
  6 0 do 2 u0.r loop $2e emit
  2 u0.r
;

\ ------------------------------------------------------------
\ store a 8 Byte 1wire address in 4 flash cells
: 1w.addr:
  create ( C: fam.c ... crc -- )
  $4 0 do
    $8 lshift +  ,
  loop
does>  ( R: -- crc ... fam.c )
  \ cannot >r because loop uses return stack :-(
  $4 0 do
    dup        			\ -- addr addr
    i  	 			\ -- addr addr idx
    +          			\ -- addr addr[i]
    @i                          \ -- addr packed_value
    dup $8 rshift swap $ff and  \ -- addr v1 v2
    rot                         \ -- v1 v2 addr
  loop
  drop
;
  

\ fin

