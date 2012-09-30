\ 2010-12-27  EW

\ multi processor communication (mpc), forth code space


\ initialize multi-processor communication 7-bit
\ modul is waiting for address, b7=1
: +mpc7 (  --  )
    txc                        \ wait for tx complete
    UCSRA c@ $01 or UCSRA c!   \ MPCM=1, multiprocessor
    $8C UCSRC c!               \ UCSZ=10, no parity, 2 Stopbits
;

\ initialize no MPC communication 8-bit
\ modul receive/transmit 8-bit data, b7=0
: -mpc7 (  --  )
    UCSRA c@ $FE and UCSRA c!  \ MPCM=0, no multiprocessor
    $86 UCSRC c!               \ UCSZ=11, no parity, 1 Stopbit
;

\ send ID, slave initialized for communication
: mpc_call ( c -- ) \ ID
  dup stationID @ = if
    drop
  else
    $0 emit          \ delay
    $80 or emit      \ set 7.bit+ID, for slave
    -emit            \ drop any output!
    +mpc7            \ modul off, wait for ID
  then
;
