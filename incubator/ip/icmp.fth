( ------------------------------------------------------------------------ )
( --                           icmp protocol                            -- )
( ------------------------------------------------------------------------ )

variable icmp.trace
0 icmp.trace !

: icmp.init ;

: ip>data 20 + ;  ( *** needs to know how to skip ip header options )
: icmp>type ;
: icmp>code 1+ ;
: icmp>check 2+ ;
: icmp>data 2+ 2+ ;

8 constant icmp_type_echo_request

: icmp.dump ( packet -- )
  hex
  ." typ" dup icmp>type c@ .
  ." cod" dup icmp>code c@ .
  ." chk"     icmp>check @ bs u.
  decimal
  cr
;

( handle received icmp packet )
: icmp.rx ( ip -- )
  
  ( point to the icmp packet in the ip packet )
  dup ip>data
  ( ip icmp )
  
  ( trace the packet if required )
  icmp.trace @ if dup icmp.dump then
  ( ip icmp )
  
  ( is it an echo request? )
  dup icmp>type c@ icmp_type_echo_request = if

    ( ip icmp )
    
    ( change packet type to echo reply )
    0 over icmp>type c!
    ( ip icmp )
    
    ( recalculate checksum )
    0 over icmp>check !
    ( ip icmp )
    
    ( calculate icmp packet length )
    over ip>length @ bs 20 - ( *** does not account for ip header options )
    ( ip icmp size )
    
    ( calculate checksum )
    over swap checksum
    ( ip icmp checksum )
    
    over icmp>check !
    ( ip icmp )
    
    icmp.trace @ if dup icmp.dump then
    
    ( swap source and destination ip addresses )
    over ip.return
    
    ( *** actually, source should be moved to destination, and source should )
    ( *** be set to our interface address )
    
    ( send it back )
    over pr.tx ip
    
  then
  
  ( discard packet )
  drop drop
;

pr.rx   ' icmp.rx   ' icmp pr.set
\ pr.tx   ' icmp.tx   ' icmp pr.set
pr.init ' icmp.init ' icmp pr.set
pr.dump ' icmp.dump ' icmp pr.set




