\ stolen from lib/misc.frt
\ dump free ressources
: .res ( -- ) 
    base @ >r
    decimal
        ." free FLASH cells      " unused u. cr
        ." free RAM cells        " sp@ here - u. cr
        ." used EEPROM cells     " edp u. cr
        ." used data stack cells " depth u. cr
        ." used return stack     " rp0 rp@ - 1- 1- u. cr
        ." free return stack     " rp@ sp0 - 1+ 1+ u. cr
    r> base !
;
