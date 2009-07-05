\ 2006-07-25 EW adv2_i2c_rtc.fs
\ read/set time on pcf8583 real time clock

\ words: get.rtc ( -- x0 .. x5 yyyy )
\        set.rtc ( Y m d H M S S/100 -- )

\ pcf8583:
\ addr
\ 0x00    control register 3: mask_flag
\ 0x01    sec/100.bcd
\ 0x02    sec.bcd
\ 0x03    min.bcd
\ 0x04    7: 0=24h clock, 6: am/pm flag
\         5-0: hour.bcd
\ 0x05    7-6: year%4 5-0: day.bcd
\ 0x06    7-5: weekdays unless maskbit,
\         4-0: month.bcd
\ eeprom:
\ 0x10,0x11 full year, not BCD

hex
a0 constant i2c_addr_rtc
decimal
include ewlib/bcd.frt

: get.rtc
  1                     \ start address
  1 i2c_addr_rtc >i2c   \ send > rtc
  6 i2c_addr_rtc <i2c   \ read 6 Bytes
  16                    \ YEAR's address
  1 i2c_addr_rtc >i2c   \ send > rtc
  2 i2c_addr_rtc <i2c   \ read 2 Bytes
  8 lshift +            \ convert to YYYY
;
: show.rtc
  get.rtc
  4 u0.r \ year
  bcd>dec 2 u0.r
  bcd>dec 2 u0.r
  45 emit
  bcd>dec 2 u0.r
  bcd>dec 2 u0.r
  bcd>dec 2 u0.r
  46 emit
  bcd>dec 2 u0.r
;
\ convert human readable numbers to expected
\ BCD numbers and compounds
: format.rtc
  \ year month day hour min sec sec/100
  \ --
  \ year weekday|month.bcd year%4|day.bcd
  \ hour.bcd min.bcd sec.bcd sec/100.bcd
  dec>bcd >r \ sec/100.bcd
  dec>bcd >r \ sec.bcd
  dec>bcd >r \ min.bcd
  dec>bcd >r \ hour.bcd
             \ year%4<<6 | hour.bcd
  \ 2 pick => >r over r> swap
  dec>bcd
  >r over r> swap
  3 and 6 lshift + >r
  dec>bcd    \ month.bcd
  r> r> r> r> r>
;
: set.rtc ( year ... sec/100.bcd -- )
  format.rtc
  128 0                 \ stop rtc
  8 i2c_addr_rtc >i2c   \ send all args
                        \ start rtc
  8 0 2 i2c_addr_rtc >i2c

  \ year is still on stack
  dup 255 and           \ low byte
  swap
  8 rshift 255 and      \ high byte
  swap                  \ low byte first
  16                    \ start addr
  3 i2c_addr_rtc >i2c   \ send > rtc
;
: init-clock ( -- )
  get.rtc
             year  !
  bcd>dec 1- month !
  bcd>dec 1- day   !
  bcd>dec    hour  !
  bcd>dec    min   !
  bcd>dec    sec   !
  drop \ 1/100 secs
;

