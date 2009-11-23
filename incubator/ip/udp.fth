( ------------------------------------------------------------------------ )
( --                           udp protocol                             -- )
( ------------------------------------------------------------------------ )

variable udp.trace
0 udp.trace !

: udp.init ;

\ offsets to fields in udp header
: udp>sp                  ; immediate
: udp>dp      2+          ;
: udp>len     2+ 2+       ;
: udp>sum     2+ 2+ 2+    ;
: udp>data    2+ 2+ 2+ 2+ ;

: udp.dump ( packet -- )
  ." sp" dup @ bs u. 2+
  ." dp" dup @ bs u. 2+
  hex
  ." len" dup @ bs u. 2+
  ." sum" @ bs u. 2+
  decimal
  cr
;

( handle received udp packet )
: udp.rx ( ip -- )
  
  ( point to the udp packet in the ip packet )
  dup ip>data
  ( ip udp )
  
  ( trace the packet if required )
  udp.trace @ if dup udp.dump then
  ( ip udp )
  
  ( *** construct psuedo header and verify udp packet checksum )
  ( *** and then check to see if we are interested in this packet )
  
  ( discard packet )
  drop drop
;

\ : udp.tx ( address length source destination internet-address -- )
\   >r
\   \ build udp packet
\   \ build psuedo header
\   \ calculate checksum
\   17
\   r>
\   ip.tx ( address length protocol internet-address -- )
\   
\ ;

pr.rx   ' udp.rx   ' udp pr.set
pr.tx   ' udp.tx   ' udp pr.set
pr.init ' udp.init ' udp pr.set
pr.dump ' udp.dump ' udp pr.set

0 udp.trace !




