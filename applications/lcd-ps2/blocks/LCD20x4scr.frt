\ LCD 20x4 chars - Lubos Pekny, www.forth.cz
\ Library for amforth 2.7

\ V.1.3, 01.07.2008, fixed cursor bug
\ V.1.2, 19.05.2008, tested on atmega32, amforth 2.7,
\ - LCD terminal screen, add videoram 80 B, copy vram to LCD

\ V.1.1, 21.01.2008, tested on atmega168, amforth 2.6

\ Choose port, PortC I/O pins needs jtag disabled.
\ Emit to LCD is slow, send commands slow also or
\ length(commands)<length(RX buffer).

#include bitnames.frt  \ V 1.2 15.06.2007, M.Trute, M.Kalus

hex

: true -1 ;
: false 0 ;

  \ Delay in ms
: ms ( x -- )
    0 do 1ms loop ;

\ 2B constant PORTD  \ Atmega168, port D, bits 2,3,4-7 
35 constant PORTC  \ Atmega32, port C, bits 2,3,4-7 

PORTC 02 portpin: LCD_RS \ ( -- mask port )
PORTC 03 portpin: LCD_E
: LCD_PORT F0 PORTC ;

  \ Store c to the portpins only
: portpin! ( c pinmask portadr -- )
    dup c@ rot dup >r invert and rot r> and or swap c! ;

  \ Swap bits 0-3 and 4-7
: swap4 ( c -- c )
    dup FF and 4 rshift swap 4 lshift or FF and ;

  \ Write clock E pin
: lcd_clk ( -- )
    LCD_E high LCD_E low ;

  \ Write command to LCD, Hi 4b, Lo 4b
: lcd_cmd ( c -- )
    LCD_RS low
    dup LCD_PORT portpin! lcd_clk
    4 lshift LCD_PORT portpin! lcd_clk ;
  
  \ Write data to LCD, Hi 4b, Lo 4b
: lcd_data ( c -- )
    LCD_RS high
    dup LCD_PORT portpin! lcd_clk
    4 lshift LCD_PORT portpin! lcd_clk ;

  \ Write word to LCD, Lo byte, Hi byte
: lcd_word ( x -- )
    dup lcd_data 8 rshift lcd_data ;

  \ Clear display
: lcd_clear ( -- )
    1 lcd_cmd 2 ms ;

  \ Reset cursor position
: lcd_home ( -- )
    2 lcd_cmd 2 ms ;

  \ Cursor left
: lcd_cleft ( -- )
    10 lcd_cmd ;

  \ Cursor right
: lcd_cright ( -- )
    14 lcd_cmd ;

  \ Shift display left
: lcd_sleft ( -- )
    18 lcd_cmd ;

  \ Shift display right
: lcd_sright ( -- )
    1c lcd_cmd ;

  \ Cursor position x,y [0..19,0..3]
: lcd_xy ( x y -- ) \ x+[00,40,14,54]+80
    3 and 
    dup 1 and if 40 or then
    dup 2 and if 14 or then
    FC and +
    80 + lcd_cmd ;

  \ Cursor on/off
: lcd_cursor ( flag -- )
    if 0F lcd_cmd else 0C lcd_cmd then ;

  \ Init display
: lcd_init ( -- )
    LCD_E    pin_output
    LCD_RS   pin_output
    LCD_PORT pin_output
    LCD_RS low
    LCD_E low
    30 ms 30 LCD_PORT portpin! lcd_clk \ 48ms
    5  ms 30 LCD_PORT portpin! lcd_clk \ 5ms
    2  ms 30 LCD_PORT portpin! lcd_clk \ 2ms
    2  ms 20 LCD_PORT portpin! lcd_clk \ 2ms, wide 4b
    2  ms 28 lcd_cmd
    2  ms  8 lcd_cmd
    2  ms  6 lcd_cmd
    2  ms lcd_clear 
    false lcd_cursor ;

  \ Define new chars 00..07, line7 is down, line0 is top of char
: lcd_newchar ( line7:6 line5:4 line3:2 line1:0 ascii -- )
    3 lshift 40 + lcd_cmd
    lcd_word lcd_word lcd_word lcd_word ;

  \ Put char into display
: lcd_emit ( c -- )
    lcd_data ;

  \ Switch emit to LCD
: emit->lcd ( -- )
    ['] lcd_data ['] emit defer! ;

  \ Switch emit to serial
: emit->tx0 ( -- )
    ['] tx0 ['] emit defer! ;

  \ Number to LCD
: lcd_. ( n -- )
    emit->lcd . emit->tx0 ;

  \ String in RAM to LCD
: lcd_type ( adr u -- )
    emit->lcd type emit->tx0 ;


variable VRAM 50 allot  \ 2+80 bytes video RAM

  \ Clear screen
: scr_clear ( -- )
    lcd_clear                     \ clear display
    0 VRAM !                      \ reset pos (position in VRAM)  
    52 2 do 20 VRAM i + c! loop ; \ 80x spaces

  \ Reset cursor position
: scr_home ( -- )
    lcd_home       \ cursor home
    0 VRAM ! ;     \ reset pos

  \ Convert pos=0..79 to x=0..19, y=0..3
: scr_pos2xy ( pos -- x y )
    0 swap           \ -- 0 pos
    begin
      dup            \ -- 0 pos pos
    13 > while
      14 -           \ -- 0 pos-20
      swap 1+ swap   \ -- 1 pos-20
    repeat           \ -- y x
    swap ;           \ -- x y

  \ Convert x,y to pos
: scr_xy2pos ( x y -- pos )
    14 um* drop + ;

  \ Cursor position x,y [0..19,0..3], xy->pos
: scr_xy ( x y -- )
    over over   \ -- x y x y
    lcd_xy      \ -- x y
    scr_xy2pos  \ -- pos
    VRAM c! ;

  \ Copy 80B from VRAM to lcd (at cursor position)
: scr_refresh ( -- )
    16 02 do VRAM i + c@ lcd_data loop
    3E 2A do VRAM i + c@ lcd_data loop
    2A 16 do VRAM i + c@ lcd_data loop
    52 3E do VRAM i + c@ lcd_data loop ;

  \ Screen roll up, last line is cleared
: scr_rollup ( -- )
    3E 02 do VRAM 14 i + + c@ VRAM i + c! loop
    52 3E do 20 VRAM i + c! loop ;

  \ Ascii>1F, view on LCD, c->pos, inc(pos), if pos>79 then roll
\ : scr_char ( c -- )
\    lcd_home
\    VRAM dup c@         \ c addr pos
\    dup >r + 2 + c!     \ c->addr+2+pos
\    r> 1+ dup VRAM c!   \ -- pos+1, inc(pos)
\    dup 4F >            \ pos>79
\    if
\      scr_rollup        \ roll screen, clear 4.line
\      drop 3C           \ 4.line, pos=60
\      dup VRAM c!       \ update pos
\    then  
\    scr_refresh         \ view on lcd
\    scr_pos2xy          \ pos+1 -- x y
\    lcd_xy ;            \ update cursor position

  \ Quick version, view char on LCD
: scr_char ( c -- )
    dup
    lcd_home
    VRAM dup c@         \ c addr pos
    dup >r + 2 + c!     \ c->addr+2+pos
    r> dup 1+ VRAM c!   \ -- pos, inc(pos)
    dup 4E >            \ pos>78
    if
      scr_rollup        \ roll screen, clear 4.line
      drop 3C           \ 4.line, pos=60
      dup VRAM c!       \ update pos
      scr_refresh       \ view on lcd
      scr_pos2xy        \ pos -- x y
      lcd_xy            \ update cursor position      
      drop
      a0 ms             \ delay for view line
    else
      dup scr_pos2xy    \ pos -- pos x y
      lcd_xy            \ update cursor position
      swap lcd_data     \ view char
      1+ scr_pos2xy     \ cursor on new position
      lcd_xy
    then ;

  \ Backspace pressed, if pos<>0 then dec(pos), ' '->pos
: scr_bspc ( -- )
    VRAM c@             \ pos<>0
    if
      lcd_home
      VRAM dup c@ 1-    \ -- addr pos-1
      over over swap c! \ -- addr pos-1, dec(pos)
      swap over + 20    \ -- pos-1 addr+pos-1 20
      swap 2 + c!       \ -- pos-1, ' '->pos
      dup
      scr_pos2xy        \ pos-1 -- x y
      lcd_xy            \ update cursor position  
      20 lcd_data       \ view space
      scr_pos2xy        \ -- x y
      lcd_xy
    then ;

  \ CR pressed, if y<3 then y+1 else roll
: scr_cr ( -- )
    lcd_home
    VRAM c@ scr_pos2xy  \ -- x y
    dup 3 <             \ y<3
    if 1+ else          \ -- x y+1
       scr_rollup
       scr_refresh then \ -- x y, roll screen
    swap drop 0 swap    \ -- 0 y
    scr_xy ;            \ update cursor position and pos

  \ Put char to LCD terminal screen, CR, backspace
: scr_terminal ( c -- )
    false lcd_cursor
    dup 1F > if dup scr_char then \ ascii>0x1F
    dup 08 = if scr_bspc then     \ backspace
    dup 0D = if scr_cr   then     \ cr, new line
    drop
    true lcd_cursor ;

  \ Switch emit to LCD terminal screen
: emit->scr ( -- )
    ['] scr_terminal ['] emit defer! ;

: scr_init ( c -- )
   -jtag
   lcd_init
   scr_clear
   true lcd_cursor ;

\ ----- Test LCD -----
-jtag     \ disable JTAG, atmega32
lcd_init
true lcd_cursor
101D 1311 1111 0000 0 lcd_newchar  \ define 'mi' for micro

1 0 lcd_xy  \ 0. line A
41 lcd_data \ char to LCD

1 1 lcd_xy  \ 1. line 40uH
3034 lcd_word 0 lcd_data 48 lcd_emit

0 2 lcd_xy  \ 2. line 341
41 300 + lcd_. \ number to LCD

0 3 lcd_xy  \ 3. line Hello world
   parse Hello world
lcd_type

400 ms
scr_init
41 scr_char
42 scr_terminal
43 scr_char
44 scr_char
200 ms
scr_bspc
200 ms
scr_bspc
scr_cr
emit->scr
ver
100 ms
emit->tx0

\ end of file