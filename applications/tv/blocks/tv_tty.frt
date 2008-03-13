\ Fuer volle Terminal Eigenschaften auf dem TV.
\
\ tv_emit kann als Vektor fær emit
\ benutzt werden:
\ als Ersatz fuer emit gedacht:
\ ' tv_emit is emit 

\ oooooooooooooooooooooooooooooooooooooooo

\ Konstanten aus minimal.asm:
\ tv_vram,tv_vramend (Zeiger auf erstes und letztes zeichen im vram)
\ tv_xsize,tv_ysize  (anz. spalten/zeilen im vram)

\ oooooooooooooooooooooooooooooooooooooooo

\ position von Cursor max:tv_vramend min:tv_vram
variable tv_curpos

\ zeichen unter cursor wenn cursor sichtbar
variable tv_curbak 

decimal 177 constant tv_curshape

\ oooooooooooooooooooooooooooooooooooooooo

\ setzt Cursorpos
: tv_curpos!  ( x y --  )
    tv_xsize * + tv_vram +      \ adr. berechnen
    tv_vram max tv_vramend min  \ innerhalb vram ?
    tv_curpos !                 \ speichern
;

\ liest Cursorpos
: tv_curpos@  (  -- x y )
    tv_curpos @ tv_vram -
    tv_xsize /mod
;

\ oooooooooooooooooooooooooooooooooooooooo

\ liest Zeichen an Cursor Pos
: tv_cur@ (  -- c )
    tv_curpos @ c@
;

\ schreibt Zeichen an Cursor Pos
: tv_cur! ( c --  )
    tv_curpos @ c!
;

\ oooooooooooooooooooooooooooooooooooooooo

\ Macht Backup von Zeichen an curpos und druckt cursor
: tv_curon (  --  )
    tv_cur@ tv_curbak ! tv_curshape tv_cur!
;

\ druckt Backup-Zeichen an curpos
: tv_curoff (  --  )
    tv_curbak @ tv_cur! 
;

\ oooooooooooooooooooooooooooooooooooooooo

: tv_movechar ( a --  )
    dup c@ swap tv_xsize - c!
;

\ loescht zeile n ( von 0 bis ysize-1 )
: tv_delline ( n --  )
    1 + tv_xsize * tv_vram +
    dup tv_xsize -
    do bl i c! loop
;

\ scrollt bild um 1 zeile nach oben 
: tv_uscroll  (  --  )
    tv_vramend 1 +       \ ende (bei do..loop wird ende nicht err.)
    tv_vram tv_xsize +   \ index (anfang)
    do i tv_movechar loop
    tv_ysize 1 - tv_delline
;
\ !!! evtl mit cmove> machen !!!

\ oooooooooooooooooooooooooooooooooooooooo

\ bewegt Cursor um eine stelle up/down/left/right (  --  )
: tv_curright
    tv_curoff 
    tv_curpos @ 1 +
    tv_vramend
    min
    tv_curpos !
    tv_curon
;

: tv_curdown
    tv_curoff 
    tv_curpos @ tv_xsize +
    tv_vramend
    min
    tv_curpos !
    tv_curon
;

: tv_curleft
    tv_curoff 
    tv_curpos @ 1 -
    tv_vram
    max
    tv_curpos !
    tv_curon
;

: tv_curup
    tv_curoff 
    tv_curpos @ tv_xsize -
    tv_vram
    max
    tv_curpos !
    tv_curon
;

\ oooooooooooooooooooooooooooooooooooooooo

\ loescht den bildschirm und setzt den cursor auf links oben.
: tv_cls  (  --  )
    tv_vramend 1+
    tv_vram
    do
        bl i c!
    loop
    tv_vram
    tv_curpos !
;

\ fuehrt carrige return aus
: tv_plotcr
    tv_curoff
    tv_curpos@ 
    swap drop 0 swap
    tv_curpos!
    tv_curon
;

\ fuehrt linefeed return aus
: tv_plotlf
    tv_curoff
    tv_curpos @ 
    tv_xsize + 
    dup tv_vramend > if
      tv_uscroll
      tv_xsize -
    then
    tv_curpos !
    tv_curon
;

\ druckt Zeichen an curpos und bewegt cursor (evtl. mit scrollup)
: tv_plotchar ( c --  )
    tv_curbak c! tv_curoff 
    tv_curpos @ 1 +
    dup tv_vramend > if 
        tv_xsize - tv_uscroll 
    then
    tv_curpos ! tv_curon
;

\ druckt zeichen (incl. steuercodes lf,ff,cr, etc)
decimal
: tv_emit ( c --  )
    case
      12 of drop tv_cls tv_curon endof              \ formfeed
      10 of drop tv_plotlf endof                    \ linefeed
      13 of drop tv_plotcr endof                    \ carrige_ret
       8 of drop tv_curleft bl tv_curbak c! endof   \ backspace
      tv_plotchar                                   \ alles andere
    endcase
;

\ zeigt speichernutzung an
decimal
: mem
    ." Flash...:" unused 1024 - 2 * . cr
    ." E2prom..:" 1024 edp e@ - . cr
    ." Ram.....:" sp@ heap e@ - . cr
;


\ schaltet um auf TV-ausgabe
: tv_switch
    tv_cls tv_curon
    ['] tv_emit  is emit 
    ver cr 
    ." --------------- " cr
    decimal mem cr cr 
;

\ ende

