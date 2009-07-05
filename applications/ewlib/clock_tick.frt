\ 2007-12-26 EW   w4_clock_tick.fs
\ geklaut aus appl/tv/blocks/realtimeclock.frt
\ words: timer2    variable
\        tick_isr  interupt service routine: increments timer2
\        +ticks    register and enable interupt
\        -ticks    disable interupt

variable timer2

\ hex
\ overflow2 interupt service routine
\ increment tick
: tick_isr
  1 timer2 +!
;

\ enable ticks
\ crystal:   32768 /sec
\ clock src: 32768 /sec
\ overflow:  32768/256 = 128 /sec =^= 7.8125 milli-sec ticks
: +ticks
  $1 TCCR2 c! ( 001 = clock_ts2/1 )
  $8 ASSR  c! ( source: 32 kiHz crystal )
  \ ['] tick_isr OVF2addr int! ( register interupt )
  ['] tick_isr TIMER2_OVFAddr int! ( register interupt )
  TIMSK c@ $40 or TIMSK c! ( enable timer2 interupt )
;

\ disable ticks
: -ticks
  TIMSK c@
  [ $40 invert $ff and ] literal
  and TIMSK c! ( clr Timer 2 )
;
