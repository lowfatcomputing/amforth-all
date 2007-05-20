\ Fuer volle Terminal Eigenschaften auf dem TV.
\ Pseudografik subsystem
\
\ aufloesung horiz/vert doppelte zeichenzahl
\ also 2xXSize/2xYSize
\
\ aus minimal.asm:
\ tv_vram,tv_vramend,tv_xsize,tv_ysize

decimal

variable tv_gcurx      ( pos des grafikcursors )
variable tv_gcury

variable tv_lastx      ( letzte pos. des gr.curs. )
variable tv_lasty

variable tv_gmode  ( 1=set / 2=unset / 3=invert )

0 tv_gcurx !
0 tv_gcury !

0 tv_lastx !
0 tv_lasty !

1 tv_gmode !


\ ooooooooooooooooooooooooooooooooo


\ prÃ¦ft ob koordin. innerhalb screen
: tv_gwithin  ( x y  -- x y t|f )
    over over
    dup -1 > swap   tv_ysize 2* <   and  \ y-koordin
    swap
    dup -1 > swap   tv_xsize 2* <   and  \ x-koordin
    and
;

\ Berechnet Position aus Zeichen-Koordinaten
: tv_pos  ( x y -- a )
    tv_xsize * + tv_vram +
;

\ kopiert aktuelle koordin. -> letzte koordin.
: tv_cur>last
    tv_gcurx @ tv_glastx !
    tv_gcury @ tv_glasty !
;

\ modus setzen/lÃschen/invertieren
: tv_gset 1 tv_gmode ! ;
: tv_gclr 2 tv_gmode ! ;
: tv_ginv 3 tv_gmode ! ;

\ logische verkn. wie in gmode
decimal
: tv_calcchar ( c_alt c_neu -- c_verkn )
    tv_gmode @
    case
      1 of  or      endof
      2 of  not and endof
      3 of  xor     endof
      drop
    endcase
    15 and
;

\ setzt punkt an Pos x y
: tv_gxy      ( x y --  )
  over over   ( x y  x y )
  1 and swap  ( x y  yand1 x )
  1 and 1+    ( x y  yand1 xand1+1 )
  swap        ( x y  xand1+1 yand1 )
  if 2* 2* then
  >r  ( x y // R: zeichenindex )
  2/ swap 2/ swap  ( xdiv2 ydiv2 / R: zeichenindex )
  tv_pos dup       ( adr adr )
  c@               ( adr zeich )
  r> tv_calcchar   ( adr calczeich )
  swap
  c!
;

\ ooooooooooooooooooooooooooooooooo

\ setzt cursor absolut auf x y
: tv_gabs  ( x y --  )
    tv_cur>last
    tv_gcury !
    tv_gcurx !
;

\ bewegt cursor relativ deltax deltay
: tv_grel  ( deltax deltay --  )
    tv_cur>last
    tv_gcury +!
    tv_gcurx +!
;

\ ooooooooooooooooooooooooooooooooo


\ zeichnet punkt an cur 
: tv_dot  (  --  )
    tv_gcurx @ tv_gcurY @ 
    tv_gxy
;

\ zieht linie von last zu cur 
: tv_lin  (  --  )

;

\ rechteck aus last und cur
: tv_box  (  --  )

;

\ zechnet kreis um last mit radius lastx-curx
: tv_cir  (  --  )

;





