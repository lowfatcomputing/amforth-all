( ------------------------------------------------------------------------ )
( --                          protocol library                          -- )
( ------------------------------------------------------------------------ )

\ protocol vector numbers
0 constant pr.init    ( -- )          ( initialise protocol         )
1 constant pr.rx      ( packet -- )   ( protocol packet receiver    )
2 constant pr.tx      ( packet -- )   ( protocol packet transmitter )
3 constant pr.dump    ( packet -- )   ( protocol packet dumper      )

\ maximum protocol vector number
3 constant pr.max

\ define a word to create a protocol vector table
: pr.create
  <builds
    pr.max 1+ 0 do ['] noop , loop
  does>
    swap pr.max min cells + @ execute
  ;

\ set a protocol handler vector
: pr.set ( vector-number procedure protocol -- )
  rot pr.max min cells swap cfa pfa + ! ;

\ example use of pr.set
( pr.init ' cl.init ' cl pr.set )




