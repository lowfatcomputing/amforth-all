\ test routines for the atmel evaluation
\ boards from www.pollin.de
\ needs the device register definitions loaded

decimal

\ wait some milliseconds
: blinkdelay 250 0 do 1ms loop ;

PORTD 1 5 lshift portpin led1
PORTD 1 6 lshift portpin led2

PORTD 1 2 lshift portpin key1
PORTD 1 3 lshift portpin key2
PORTD 1 4 lshift portpin key3

: portinit
    led1 mode_output
    led2 mode_output
    key1 mode_input
    key2 mode_input
    key3 mode_input

    05 MCUCR c! \ int0/1
    C0 GICR  c! \ enable int0/1
;

\ test runs until a terminal-key is pressed

\ as long as a key on the board is pressed the
\ corresponding led/buzzer is turned on
: keys
    begin
        PIND c@
	fc and
	3 lshift
	PORTD c!
    key? until
    key drop \ we do not want to keep this key stroke
;


: blink ( -- )
  led1 on blinkdelay
  led2 on blinkdelay
  led2 off blinkdelay
  led1 off blinkdelay
;

: led1blink
  led1 on
  blinkdelay
  led1 off
;

\ simple lights on/off
: led
    begin
	blink
	key?
    until
    key drop \ we do not want to keep this key stroke
;

\ interrupt processing takes a long time, do not
\ press the key while it runs...
' led1blink 1 int!
' noop 2 int!

\ autoconfig the i/o ports
\ ' portinit 'turnkey e!
