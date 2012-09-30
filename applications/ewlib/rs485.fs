\ initialize no MPC communication 8-bit
\ modul receive/transmit 8-bit data, b7=0
: -mpc7 (  --  )
    UCSRA c@ $FE and UCSRA c!  \ MPCM=0, no multiprocessor
    $86 UCSRC c!               \ UCSZ=11, no parity, 1 Stopbit
;

\ send ID, slave initialized for communication
: mpc_call ( c -- ) \ ID
  dup mpc_ID @ = if
    drop
  else
    $0 tx            \ delay
    $80 or tx        \ set 7.bit+ID, for slave
    +mpc7            \ modul off, wait for ID
  then
;

