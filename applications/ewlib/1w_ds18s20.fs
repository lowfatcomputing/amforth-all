\ 2009-12-23  EW  ewlib/1w_ds18s20.fs

\ --- Fam.10 DS18S20 thermometer -----------------------------
\ send "start conversion" to all
: 1w.sc.all
  1w.reset
  1w.cmd.startconversion 1w.cmd.skiprom 2 >1w
;
: 1w.sc ( x8=crc .. x1=fam.code -- )
  1w.reset
  ( addr ) 1w.cmd.matchrom &9 >1w
  1w.cmd.startconversion    1 >1w
;

\ conversion + warten ist schon rum!
: 1w.rd.T ( addr[8] -- x1=Tl x2=Th x3 .. x9=crc )
  1w.reset
  \ device addressieren
  1w.cmd.matchrom &9 >1w
  1w.cmd.readdata &1 >1w
  &9 <1w
;

\ convert answer to physical units 1/100 C
: ds18s20.decode ( x1 .. x9=crc -- T*100 ok )
  7 0 do drop loop \ ignore crc
  8 lshift +       \ combine T_h T_l
  &100 &2 */       \ scale
  0                \ ok, because we ignore crc
;

