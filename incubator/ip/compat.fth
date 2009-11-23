( c6.compat.fth - compatibility suite fth102 -> 4p -> f83 )

: \ 13 word ; immediate

-1 constant true
0 constant false

: blank ( a # -- ) blanks ;
: code create smudge ;
: create <builds does> ;
: exit r> drop ;
: negate 0 swap - ;
: not 0= ; ( not really successful )
: recurse latest pfa cfa , ; immediate
: sign 0< if 45 hold then ;
\ leave misbehaves
: word word here ;
: ' [compile] ' cfa ;

\ ' is strange... it has compilation semantics that include literal anyway,
\ and literal has null interpretation action!
: ['] ' ( [compile] literal ) ; immediate
: ['] [compile] [ ' [compile] ] [compile] literal ; immediate

: ?dup dup dup 0= if drop then ;
: 1- 1 - ;
: 2drop drop drop ;

\ : 2swap rot >r rot r> ;

hex
code 2swap
  D1 c, \ pop	de		; de = d	( a b c )
  E1 c, \ pop	hl		; hl = c	( a b )
  F1 c, \ pop	af		; af = b	( a )
  E3 c, \ ex	(sp),hl		; hl = a	( c )
  D5 c, \ push	de		;		( c d )
  E5 c, \ push	hl		;		( c d a )
  F5 c, \ push	af		;		( c d a b )
  C3 c, (next) ,

code 2*
  E1 c, \ pop	hl
  29 c, \ add	hl,hl
  C3 c, (next) 1- ,

decimal

( non f83 )
: ascii bl word 1+ c@ [compile] literal ; immediate
: key? ( -- # ) -86 c@ ;

2 constant cell
: cells 2* ;
: cell+ 2+ ;

: >mark here 0 , ;
: <mark here ;
: >resolve here swap ! ;
: <resolve , ;

: (") ( -- address length ) r@ count dup 1+ r> + >r ;
: " compile (") 34 word c@ 1+ allot ; immediate

decimal
keep

\ end of c6.compat.fth
