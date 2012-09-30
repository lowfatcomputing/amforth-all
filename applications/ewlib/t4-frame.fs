\ 2011-08-07  ewlib/t4-frame.fs
\ requires ewlib/format.fs
\ requires ewlib/F>C.fs

\
\ data frame to hold one telegramm (44 bit) of data
\ organized in nibbles (4 bit)
\ stored in 12 Bytes, aligned
\
\ offset
\  0    start (always 0)
\  1    addr.H, 2 nibbles, A0 or AE
\  3    addr.L, 2 nibbles, $fe .. 00/even, + 1 parity bit
\  5    tens with sign
\  6    ones
\  7    tenths
\  8    tens (repeated)
\  9    ones (repeated)
\ 10    crc.L, only lower nibble of sum(0..9)
\ 11 -- not used
\ 12 -- beyond end

\ 11 Byte would be sufficient, the 12th is purely for aestetic
\ reasons.

$0c constant t4.size
: t4.frame:
  variable t4.size allot
;

\ define header offsets
 &1 constant  t4:addr   : t4:addr+  t4:addr + ;
 &5 constant  t4:val    : t4:val+   t4:val  + ;
&10 constant  t4:crc    : t4:crc+   t4:crc  + ;

: t4.erase  ( addr -- )  t4.size erase ;
: t4.dump   ( addr -- )  t4.size 0 do dup i + c@ 2 u0.r space loop drop ;


: t4>addr  ( addr -- t4.sensor.addr )
  t4:addr+
  0
  4 0 do
    4 lshift
    over i + c@ +
  loop
  $fffe and
  swap drop
;
: t4>T?  ( addr -- t/f )
  t4:addr+ 1+ ( constant part.L )
  c@ $0 = \ t/f
;
: t4>H?
  t4:addr+ 1+ ( constant part.L )
  c@ $e = \ t/f
;
\ to transfer negative temperatures, the tens in the data
\ stream are made positive values by adding 5
\ highly unobvious trick
: t4>value ( addr -- T*10 | rF )
  dup t4>T? if
    t4:val+
    dup c@ &5 - \ temperature: data_tens = T_tens + 5
  else
    t4:val+
    dup c@
  then
  3 1 do
    10 *
    over i + c@ +
  loop
  swap drop 
;
: t4>crc.ok? ( addr -- t/f )
  0
  10 0 do
    over i + c@ +
  loop
  $000f and    \ computed crc
  over 10 + c@ \ received crc
  = \ t/f
  swap drop ( addr )
;

: t4.show   ( addr -- )
  dup t4>addr
  hex space 4 u0.r [char] : emit
  
  dup t4>value
  decimal space 1 +.f

  space
  dup t4>T? if
    [char] C emit
  then
  dup t4>H? if
    [char] % emit
  then

  space ." crc."
  dup t4>crc.ok? if ." ok" else ." error" then
  
  drop ( addr )
  cr
;

\ .
