\ 2008-04-15 EW   sensor.fs

\ words:
\ sensor: Datenobjekt
\       id    id der "sensor:" Datenstruktur in der software
\     addr    Adresse des hw Sensors auf dem Bus
\     'get    Zeiger auf Funktion, die den Sensor ausliest
\             liefert N Bytes und ein ok/err flag zurück
\  'decode    Zeiger auf Funktion, die die Bytes in
\             physikalische Einheiten umrechnet, kennt N,
\             in skalierten Einheiten, z.B. Grad Celsius/100
\      a_0    Nullte Ordnung Korrektur, gleiche Einheit
\ 
\ oder
\ 'correct    Zeiger auf Funktion, die das Ergebnis von
\             'decode korrigiert
\   Ncoeff    Anzahl der Koeffizienten für 'correct
\      x_0    x_correct = a_0 + a_1*(x-x_0) ... a_n*(x-x_0)^n
\ a_0..a_n

: sensor:
  create ( id i2c-addr 'get 'decode a_0 -- )
    \ keep order of arguments in (flash) memory
    >r >r >r >r , r> , r> , r> , r> ,
  does>  ( -- id skalierterWert ok/err )
    >r                  ( -- )
      r@    @i          ( -- id )
    1 r@ +  @i          ( -- id i2c-addr )

    2 r@ +  @i          ( -- id i2c-addr 'get )
    execute             ( -- id xN..x1 0:ok | id -1:error )
    0= if               ( -- id xN..x1 )
      3 r@ +  @i        ( -- id xN..x1 'decode )
      execute           ( -- id T*100 )
      4 r@ +  @i +      ( -- id T*100+a_0 )  
      0                 ( -- id T*100+a_0 ok )
    else                ( -- id )
      -1                ( -- id error )
    then
    r> drop
;
