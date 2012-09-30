\ 2011-06-14  ew  ewlib/sonar.fs
\ seeedstudio ultrasonic range finder
\ needs ewlib/input_capture.fs
: ping.power.off ( -- )
  pwr.ping pin_highZ  ;
: ping.power.on  ( -- )
  pwr.ping pin_output pwr.ping high ;
: +ping
  ping pin_highZ
  0 ic_t0 !
  0 ic_t1 !
;
: ping.trigger ( -- )
  ping pin_output        \ trigger sonar,
  ping high ping low     \ . measurement
  ping pin_input         \ . by ICP1
  40 0 do pause 1ms loop \ wait f. completion
;
