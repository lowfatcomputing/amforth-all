\ 2008-02-14 EW   ewlib/lcd_4x20.fs

\ require lib/bitnames
include ewlib/hd44780.fs

hex
\ init io pins, init display
: lcd.init
  hd44780-io
\  34 hd44780-command \ 8 bit datenlänge, RE=1
\  09 hd44780-command \ 4 Zeilen Modus
\  30 hd44780-command \ 8 bit datenlänge, RE=0
\  01 hd44780-command \ Display löschen, Cursor home
\  09 hd44780-command \ Cursor auto-increment
\  0e hd44780-command \ Display ein, Cursor ein

\ 2010-06-01, after reading datasheet again
  $38 hd44780-command  \ function set: 2 lines,
  1ms 1ms 1ms 1ms 1ms  \ wait to settle
  $0e hd44780-command  \ display on, cursor on no-blink
  $06 hd44780-command  \ autoincrement cursor
  $80 hd44780-command  \ cursor home
;

\ clear display, cursor home
: lcd.page
  hd44780-page
;

\ position cursor
\ : lcd.pos ( row col -- )
\   \ swap 40 * + 80 + \ display mit 2 Zeilen
\   swap 20 * + 80 +      \ display mit 4 Zeilen
\   hd44780-command
\ ;


\ display: logical 2x40: pysical 4x20
\ 0 col -> $00 col +       $80 or   \
\ 1 col -> $c0 col +       $80 or   \ odd
\ 2 col -> $00 col + &20 + $80 or   \      >1
\ 3 col -> $c0 col + &20 + $80 or   \ odd  >1

: lcd.pos ( row[0..3] col[0..19] -- )
                 \ row col

  over $01 and if \ odd
    $c0 +         \ -- row addr[0]+col
  then
  swap 1 swap < if  \ row[23]   \ fixme: '>' is broken
    &20 +         \ -- addr[0]+col (+20)
  then

  $80 or         \ cmd | addr
  hd44780-command
;

\ redirection
: to.lcd
  ['] hd44780-emit is emit
;

: lcd.cursor.off
  $0c hd44780-command ( display on, cursor off )
;
