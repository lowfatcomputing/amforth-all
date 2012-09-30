\ 2011-06-08  EW  ewlib/rfm12_rx_int0.fs

\ collect data frames (16 bytes) from rfm12 radio.
\ radio will wait for $aa sync pattern and $2d $d4 magic bytes
\ bytes will be stored in D.in

\ needs:

\ include ewlib/data-frame.fs
\ data.frame: D.in

\ PORTD 2 portpin: int0  ( hard wired )
\ variable wFlags                 \ wireless status flags
\ wFlags 0 flag: wFactive         \ allowed receiving block
\ wFlags 1 flag: wFcomplete       \ received complete block

: -int0
  GICR  c@ %01000000 invert and GICR  c!  \ disable INT0
;
: int0_isr
  0 (>wc) drop                  \ read status register
  $b000 (>wc) $00ff and         \ read received byte

  wFactive fset? if             \ if receiving
    \ df.index @  df.size  < if \ old version
    D.in df.index @ + c!   \ store into D.in
    df.index++             \ incr index
    df.index @ 0= if       \ index == 0 AFTER increment
      wFactive fclr        \   no more bytes to receive
      wFcomplete fset      \   flag block complete
      w.rx.clearfifo     \ data frame complete, listen to magic bytes again
    then
  else
    drop
  then
;

: int0.enable
  _int0 pin_highZ                \ input low --> init?
  ['] int0_isr INT0Addr int!     \ register isr
;
: +int0
  MCUCR c@ %00000010 or MCUCR c! \ falling edge triggers INT0
           %01000000    GIFR  c! \ clear  INT0 flag, just in bloody case!
  GICR  c@ %01000000 or GICR  c! \ enable INT0
;

\ fin  
