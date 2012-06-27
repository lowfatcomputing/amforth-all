\ *************************************************
\ some double cell words, mostly taken from gforth
\ more 2x and dx words are in the otional dictionary
\ *************************************************

\ requires cell.frt


\ 2rot	( w1 w2 w3 w4 w5 w6 -- w3 w4 w5 w6 w1 w2 )	double-ext	two_rote
: 2rot
 >r >r 2swap r> r> 2swap ;

\ 2nip	( w1 w2 w3 w4 -- w3 w4 )	gforth	two_nip
: 2nip
 2swap 2drop ;

\ 2tuck	( w1 w2 w3 w4 -- w3 w4 w1 w2 w3 w4 )	gforth	two_tuck
: 2tuck
 2swap 2over ;
