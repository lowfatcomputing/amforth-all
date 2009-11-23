( c6.asm.fth - fth102 assembler )

2 base !

000 constant b     001 constant c     010 constant d
011 constant e     100 constant h     101 constant l
110 constant (hl)  111 constant a

: ldb  ( s d -- ) 1000 * or 01000000 or c, ;
: ldbi ( s d -- ) 1000 *    00000110 or c, c, ;
: orb  ( r -- )   10110000 or c, ;
: cpb  ( r -- )   10111000 or c, ;
: xorb ( r -- )   10101000 or c, ;
: andb ( r -- )   10100000 or c, ;
: sbcb ( r -- )   10011000 or c, ;
: subb ( r -- )   10010000 or c, ;
: incb ( r -- )   1000 *    00000100 or c, ;

00 constant bc  01 constant de  10 constant hl
11 constant af  11 constant sp

: pushw ( r -- ) 10000 * 11000101 or c, ;
: popw  ( r -- ) 10000 * 11000001 or c, ;
: decw  ( r -- ) 10000 * 00001011 or c, ;
: incw  ( r -- ) 10000 * 00000011 or c, ;
: ldw   ( r -- ) 10000 * 00000001 or c, ;

: jp   11000011 c, ;
: jpnz 11000010 c, ;
: jpz  11001010 c, ;
: jpc  11011010 c, ;

hex

: call ( address -- ) CD c, , ;

: next jp (next) , ;
: hpush jp (next) 1- , ;
: a>s 26 c, 00 c, 6F c, E5 c, ;

code time ( a -- )  hl popw  bc pushw  190F call  bc popw  next
code date ( a -- )  hl popw  bc pushw  192F call  bc popw  next

create timbuf 8 allot
: .time timbuf time timbuf 8 type ;
( : .date timbuf date timbuf 8 type ; )

( y x -- )
code plot   hl popw l d ldb hl popw l e ldb bc pushw 744C call bc popw next
code unplot hl popw l d ldb hl popw l e ldb bc pushw 744D call bc popw next

code motoron  bc pushw  14A9 call  bc popw  next
code motoroff bc pushw  14AA call  bc popw  next

( clear screen )
code cls bc pushw 4231 call bc popw next

decimal
: esc 27 emit ;

( position to x y coordinate )
: xy ( column row -- ) esc ascii Y emit 32 + emit 32 + emit ;

( clear to end of line )
: ceol esc ascii K emit ;

( clear to end of screen )
: ceos esc ascii J emit ;

hex

( frequency duration -- )
code music    hl popw de popw bc pushw l b ldb 72C5 call bc popw next

decimal

( get current time HHMM as decimal number )

: now ( -- time )
  63800 c@
  10 * 63799 c@ +
  10 * 63798 c@ +
  10 * 63797 c@ +
;

keep

\ end of c6.asm.fth
