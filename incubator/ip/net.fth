( ------------------------------------------------------------------------ )
( --                  internet interface for tandy 102                  -- )
( ------------------------------------------------------------------------ )

\ load forth-83 compatibility suite and assembler
fast load compat.fth
fast load asm.fth

\ trigger downline load
hex code (r) 0F3F0 call decimal
: reload remote begin key 26 = until local (r) ;

\ byte and word swap, aka htons() and ntohs()
hex

code bs ( %xaabb -- %xbbaa )
  hl popw
  l a ldb
  h l ldb
  a h ldb
  hpush

code ws ( %xaabb %xccdd -- %xbbaa %xddcc )
  hl popw
  de popw
  l a ldb
  h l ldb
  a h ldb
  e a ldb
  d e ldb
  a d ldb
  de pushw
  hpush

decimal

\ calculate a 16 bit one's complement checksum
\ *** does not properly handle odd packet lengths
: checksum ( address length -- sum )
  over + swap
  0 0 2swap
  ( 0 0 a2 a1 )
  do
    i @ bs 0 d+
  2 +loop
  ( suml sumh )
  0 swap 0 d+
  0 swap 0 d+
  drop
  -1 xor
  bs
;

\ display an internet address mask
: .inet ( internet-address' -- )
       dup c@ 0 <# #s #> type 46 emit
  1+   dup c@ 0 <# #s #> type 46 emit
  1+   dup c@ 0 <# #s #> type 46 emit
  1+       c@ .
;


\ include protocol library module
fast load protocol.fth

\ create all protocol vector tables
pr.create cl
pr.create slip
pr.create ip
pr.create icmp
pr.create udp
\ pr.create tcp


\ check for and process any keyboard input
: keys
  65450 c@ if
    key
    dup 13 = if abort then         \ cr abort
    drop
  then
  ;

: main
  pr.init cl
  pr.init slip
  pr.init ip
  pr.init icmp
  pr.init udp
  0 0 0 0
  begin
    pr.rx slip
    s0 @ sp@ - 2 / 5 = not if ." stack!" abort then
    keys
    false
  until
  ;

fast load cl.fth
fast load slip.fth
fast load ip.fth
fast load icmp.fth
fast load udp.fth

\ make new dictionary words permanent
keep

\ write executable
save net.cmd
cr bye
