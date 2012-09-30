\ 2011-06-03  EW
\ block to hold one sensors data
\
\ offset
\  0    src   senders stationID
\  1    dst   recipients stationID
\  2    cnt   count up on all data frames
\  3          empty
\  4    dat   5 cells: id,N,min,mean,max <-- .
\  4    sid   mandatory id
\  6      N   . usage free
\  8    min   .
\ 10   mean   .
\ 12    max   .
\ 14    crc   fletcher16 crc of complete frame
\ 16 -- beyond end

$10 constant df.size
df.size &6 - constant df.payloadsize
\ C:( cxxx -- )  R:( -- addr )
: data.frame:
  variable df.size allot
;

\ define header offsets
 &0 constant df:src    : df:src+ ( addr -- addr' ) ( df:src + ) ;
 &1 constant df:dst    : df:dst+                     df:dst +   ;
 &2 constant df:flg    : df:flg+                     df:flg +   ;
 &3 constant df:len    : df:len+                     df:len +   ;
 &4 constant df:sid    : df:sid+                     df:sid +   ;
 &4 constant df:dat    : df:dat+                     df:dat +   ;
&14 constant df:crc    : df:crc+                     df:crc +   ;

: df.erase ( addr -- )  df.size erase ;
: df.dump  ( addr -- )
  df.size 0 do
    dup i + c@ 2 u0.r space
  loop
  drop
;
: df.show  ( addr -- )
  hex
  ." .....source:" space dup df:src+ c@ 2 u0.r cr
  ." destination:" space dup df:dst+ c@ 2 u0.r cr
  ." ......flags:" space dup df:flg+ c@ 2 u0.r cr
  ." .....length:" space dup df:len+ c@ 2 u0.r cr
  ." ...sensorid:" space dup df:sid+  @ 4 u0.r cr
  ." .......data: $" df.payloadsize 2/ 0 ?do
    dup df:dat+ i cells + @ space 4 u0.r
  loop cr
  decimal
  ." ...........: &" df.payloadsize 2/ 0 ?do
    dup df:dat+ i cells + @ space .
  loop cr
  hex
  ." ........crc:" space dup df:crc+  @ 4 u0.r cr
  drop
;

\ fin