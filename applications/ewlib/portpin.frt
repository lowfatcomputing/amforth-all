\ 2009-01-01   EW   ewlib/portpin.fs
\ pin>channel
\     convert bitmask of portpin: back to value (bitposition)

: pin>channel ( pinmask portaddr -- channel )
  drop          ( -- pinmask )
  8 0 do
    dup 1 and   ( -- pinmask pinmask&1 )
    1 = if      ( -- pinmask )
      drop i    ( -- i )
      leave     ( -- channel )
    else
      1 rshift  ( -- pinmask>>1 )
    then
  loop
;
