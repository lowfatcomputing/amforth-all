\ 2008-02-02 EW    bcd.fs
\ convert bcd to decimal and vice versa

\ words: bcd>dec ( n.bcd -- n.dec )
\        dec>bcd ( n.dec -- n.bcd )
\ values are truncated!!!

: bcd>dec ( n.bcd -- n.dec )
  255 and
  dup
  4 rshift 10 * \ extract high nibble as 10s
  swap
  15 and       \ extract low  nibble as 1s
  +             \ add
;
: dec>bcd ( n.dec -- n.bcd )
  100 mod      \ 99 is largest for 8 bit bcd
  10 /mod
  4 lshift
  +
  255 and       \ truncate to 8 bit
;
