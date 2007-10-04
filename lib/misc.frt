\ some definitions that may be useful

: within? ( n lo hi -- f )
    >r 1- over < swap r> 1+ < and 
;

: u.r ( u w -- )
      >r  s>d <# #s #>  ( -- addr n )
      r> over ( -- addr n w n )
      - 0 max spaces type ;


\ dump flash content
: idump ( addr len -- )
    base @ >r hex
    0 do
	i 
	    over +  dup 5 u.r
	    i@ 5 u.r
	    cr
    loop
    drop
    r> base !
;

: .(  \ (s -- )
   [char] ) word count type
; immediate

\ dump free ressources
: .res ( -- ) 
    base @ >r
    decimal
	." free FLASH cells      " unused . cr
	." free RAM cells        " sp@ heap e@ - . cr
	." used EEPROM cells     " edp e@ . cr
	." used data stack cells " depth . cr
	." used return stack     " rp0 rp@ - 1- 1- . cr
	." free return stack     " rp@ sp0 - 1+ 1+ . cr
    r> base !
;

