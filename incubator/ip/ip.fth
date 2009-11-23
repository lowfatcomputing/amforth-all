( ------------------------------------------------------------------------ )
( --                            ip protocol                             -- )
( ------------------------------------------------------------------------ )

variable ip.size
variable ip.version
variable ip.trace
create ip.address 2 cells allot

( 10.0.1.2 ) hex 000A0201. decimal ip.address 2!

\  version
\  length
\  type of service
\  total length
\  identification
\  flag
\  fragmentation index
\  time to live
\  protocol
\  checksum
\  source
\  destination

\ offsets to fields in ip header
: ip>tos        1+ ;
: ip>length     2+ ;
: ip>ident     4 + ;
: ip>protocol  9 + ;
: ip>check    10 + ;
: ip>source   12 + ;
: ip>dest     16 + ;

: ip.dump ( packet -- )
  hex
  dup ip>length @ bs over swap checksum ." sum" u.
  dup c@ dup 16 / ." ver" . 15 and ." len" . 1+
  dup c@ ." tos" . 1+
  dup @ ." tln" bs . 2+
  dup @ ." idn" bs . 2+
  dup @ dup 8192 / ." flg" . 8191 and ." frg" . 2+
  dup c@ ." ttl" . 1+
  dup c@ ." pro" . 1+
  dup @ ." chk" bs u. 2+
  decimal
  dup ." sip" .inet 4 +
  dup ." dip" .inet 4 +
  drop
  cr
;

\ swap source and destination addresses in ip packet
: ip.return ( ip -- )
  >r
  r@ ip>source 2@
  r@ ip>dest   2@
  r@ ip>source 2!
  r> ip>dest   2!
;

: ip.tx ( ip -- )
  ip.trace @ if dup ip.dump then
  pr.tx slip
;

: ip.init
  0 ip.size !
  0 ip.version !
;

: ip.rx ( packet size -- )

  ( ensure ip version 4 packet )
  over c@ 16 / 4 = not if
    1 ip.version +!
    ip.trace @ if ." ip: discard: version" cr then
    drop drop
    exit
  then
  
  ( validate size of slip packet against total length in ip header )
  over 2+ @ bs over = not
  if
    1 ip.size +!
    ip.trace @ if ." ip: discard: size" cr then
    drop drop
    exit
  then
  
  ( trace the packet if required )
  ip.trace @ if over ip.dump then
    
  ( drop size, we need it not from here )
  drop
    
  ( ensure destination address matches our interface or broadcast address )
  ( ip.address 2@ over d= ... )
    
  ( examine protocol and deliver upwards )
  dup ip>protocol c@ 
    dup  1 = if dup pr.rx icmp then
    dup 17 = if dup pr.rx udp  then
    drop
    
  ( discard packet )
  drop
;

pr.rx   ' ip.rx   ' ip pr.set
pr.tx   ' ip.tx   ' ip pr.set
pr.init ' ip.init ' ip pr.set
pr.dump ' ip.dump ' ip pr.set

0 ip.trace !




