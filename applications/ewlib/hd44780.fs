\ 2008-02-03 EW   hd44780.fs
\ stolen from amforth/appl/eval-pollin/hd44780.frt
\ 

\ needs bitnames.frt
\ needs ans.frt (ms)
\ needs atmega32.fs (sfr und pin names)

hex

: hd44780-pulse-en
    hd44780-en high
    hd44780-pulse-delay 0 ?do 1ms loop
    hd44780-en low
    hd44780-pulse-delay 0 ?do 1ms loop
;

: hd44780-data-mode
    hd44780-rs high
;

: hd44780-command-mode
    hd44780-rs low
;

: hd44780-read-mode
    0 hd44780-data 1- c! \ input
    hd44780-rw high
;

: hd44780-write-mode
    ff hd44780-data 1- c! \ output
    hd44780-rw low
;

: hd44780-read-data ( -- c )
	hd44780-read-mode
	hd44780-pulse-en
	hd44780-short-delay 0 ?do 1ms loop
	hd44780-data 1- 1- c@ 
;

: hd44780-wait
    hd44780-read-mode
    hd44780-rw high
    hd44780-rs low
    hd44780-pulse-en
    begin
        hd44780-data 1- 1- c@
	80 and
    until
;

: hd44780-command ( n -- )
    hd44780-wait
    hd44780-write-mode
    hd44780-command-mode
    hd44780-data c!
    hd44780-pulse-en
;

: hd44780-emit ( c -- )
    hd44780-write-mode
    hd44780-data-mode
    hd44780-data c!
    hd44780-pulse-en
;

: hd44780-io
  $ff  hd44780-data 1-   c! \ port output
  hd44780-rw pin_output
  hd44780-en pin_output
  hd44780-rs pin_output
;

: hd44780-page
  01 hd44780-command ( clear hd44780 )
  03 hd44780-command ( cursor home )
;

