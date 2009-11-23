( ------------------------------------------------------------------------ )
( --                           slip protocol                            -- )
( ------------------------------------------------------------------------ )

hex C0 decimal constant END
hex DB decimal constant ESC
hex DC decimal constant ESC.END
hex DD decimal constant ESC.ESC

: slip>length     2+ ;   \ offset to length in ip header

( send an ip packet through the slip link )
: slip.tx ( ip -- )
  
  ( determine length )
  dup slip>length @ bs
  
  END pr.tx cl
  0 do
    dup c@
    dup END = if
      drop
      ESC pr.tx cl
      ESC.END pr.tx cl
    else
      dup ESC = if
        drop
        ESC pr.tx cl
        ESC.ESC pr.tx cl
      else
        pr.tx cl
      then
    then 
    1+
  loop
  END pr.tx cl
  drop
;

512 constant slip.mtu              \ link maximum transmission unit
create slip.buffer slip.mtu allot  \ received packet buffer
variable slip.in                   \ current point in buffer
variable slip.size                 \ size of current packet in buffer
variable slip.esc                  \ waiting for character after SLIP ESC
variable slip.overrun              \ slip overrun byte counter
variable slip.packets              \ slip packet counter

: slip.clear ( -- )
  0 slip.size !
  slip.buffer slip.in !
  false slip.esc !
  ;
  
: slip.init ( -- )
  slip.clear
  0 slip.overrun !
  0 slip.packets !
  ;

: slip.rx ( -- )
  ( is there any incoming communications line input?  process it )
  65414 c@ if
    pr.rx cl
    \ dup 16 base ! base @ >r 0 <# # # #> type ( space ) r> base !
    ( is it a SLIP END character? )
    dup END = if
      drop
      ( does buffer hold a packet? )
      slip.size @ if
        1 slip.packets +!
        slip.buffer slip.size @ pr.rx ip
      then
      ( clear buffer )
      slip.clear
    else
      ( is it a SLIP ESC character? )
      dup ESC = if
        drop
        true slip.esc !
      else
        ( were we previously slip.esc? )
        slip.esc @ if
          ( is it an escape of the SLIP END character? )
          dup ESC.END = if 
            drop END
          else
            dup ESC.ESC = if drop ESC then
          then
          ( turn off escape mode )
          false slip.esc !
        then
        ( check to see if buffer has overflowed )
        slip.size @ slip.mtu < if
          ( place character into buffer )
          1 slip.size +!
          slip.in @ c! 1 slip.in +!
        else
          ( discard characters beyond mtu )
          1 slip.overrun +!
        then
      then
    then
  then
  ;

pr.rx   ' slip.rx   ' slip pr.set
pr.tx   ' slip.tx   ' slip pr.set
pr.init ' slip.init ' slip pr.set




