\ 2009-01-01   EW   ewlib/portpin.fs
\ pin>channel
\     convert bitmask of portpin:
\     back to value (bitposition)

: pin>channel ( mask addr -- channel )
  drop          ( -- mask )
  8 0 do
    dup 1 and   ( -- mask mask&1 )
    1 = if      ( -- mask )
      drop i    ( -- i )
      leave     ( -- channel )
    else
      1 rshift  ( -- mask>>1 )
    then
  loop
;
