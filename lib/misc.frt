\ some definitions that may be useful

: within? ( n lo hi -- f )
    >r 1- over < swap r> 1+ < and 
;

: u.r ( u w -- )
      >r  <# #s #>  r> over - 0 max spaces type ;


\ dump flash content
: idump ( addr len -- )
    hex
    0 do
	i 
	    over +  dup 5 u.r
	    i@ 5 u.r
	    cr
    loop
    drop
;

: .(  \ (s -- )
   char ) parse type
; immediate

\ dump free ressources
: .res ( -- ) 
	." free FLASH cells  " unused . cr
	." free RAM cells    " sp@ here - . cr
	-" used EEPROM cells " edp e@ . cr
	." used data stack   " depth . cr
	-" used return stack " rp0 rp@ - . cr
;	." free return stack " rp@ sp0 - . cr
