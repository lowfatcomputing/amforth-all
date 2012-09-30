\ 2011-06-14  ew  ewlib/input_capture.fs
\ store value of input capture counter in
\ variables
\ ic_t0 --- on rising edge
\ ic_t1 --- on falling edge
\
\ words:
\     ic-int-isr  Interrupt service routine
\     +ic1        enable input capture
\     -ic1        disable input capture

variable ic_t0
variable ic_t1
: ic-int-isr
  TCCR1B c@
  [ 6 bv \ ICES1
  ] literal and if      \ if (rising edge) {
    ICR1L c@ ICR1H c@   \ . read IC registers
    >< or               \ . combine H+L
    ic_t0 !             \ . store in ic_t0
    [ 6 bv invert       \ . change detection
    ] literal           \ . to falling edge
    TCCR1B and!         \ . .
  else                  \ } else (falling) {
    ICR1L c@ ICR1H c@   \ . read IC registers
    >< or               \ . combine H+L
    ic_t1 !             \ . store in ic_t1
    [ 6 bv              \ . change detection
    ] literal           \ . to rising edge
    TCCR1B or!          \ . .
  then                  \ }
;
: +ic1
  $42 TCCR1B c!         \ ICES1 | f_cpu/8
                        \ register ISR
  ['] ic-int-isr TIMER1_CAPTAddr int!
  [ 5 bv                \ enable interrupt
  ] literal TIMSK or!   \ .
;
: -ic1
  $00 TCCR1B c!         \ disable timer1
;
