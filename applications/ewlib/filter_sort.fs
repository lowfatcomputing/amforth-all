\ marker --sort--

\ 2012-08-03  ew  ewlib/filter_sort
\ insert new values in numerical sort order into cache (ram)

: filter_sort:
  create ( n  -- )
    1 cells allot       \ place for N_used
    here ,              \ store pointer to RAM space
    dup ,   	        \ store length (cells)
    ( n ) cells allot   \ alloc ram space
  does> ( -- ram_addr n )
    dup @i
    swap 1+ @i
;

: usort_reset ( ram_addr n -- )
  over swap
  cells $ff fill
  0 swap 1 cells - !   \ clear used amount
;
: sort_reset ( ram_addr n -- )
  over over over       \ -- ram_addr n ram_addr n ram_addr
  swap cells +         \ -- ram_addr n ram_addr ram_addr[n]
  swap ?do
    $7fff i !
  [ 1 cells ] literal +loop
  drop
  0 swap 1 cells - !
;

: usort_next ( x_new ram_addr n -- x_new ram_addr i )
  ( n ) 0 ?do          \ -- x_new ram_addr
    dup                \ -- x_new ram_addr ram_addr
    i cells + @        \ -- x_new ram_addr x[i]
    &2 pick            \ -- x_new ram_addr x[i] x_new
    u> if i leave then \ -- x_new ram_addr i
  loop
;
: sort_next ( x_new ram_addr n -- x_new ram_addr i )
  ( n ) 0 ?do          \ -- x_new ram_addr
    dup                \ -- x_new ram_addr ram_addr
    i cells + @        \ -- x_new ram_addr x[i]
    &2 pick            \ -- x_new ram_addr x[i] x_new
    > if i leave then  \ -- x_new ram_addr i
  loop
;

: sort_get_half ( ram_addr n -- addr[3n/4] addr[n/4] )
  over over 3 * 4 / cells +
  rot rot       4 / cells +
;
: usort_insert ( x_new ram_addr n -- )                    \ n == size!
  noop                  \ -- x_new ram_addr n
  \ do nothing if x_new == $ffff
  2 pick $ffff u< if
    over >r             \ -- x_new ram_addr n            R: &x[0]
    sort_next           \ -- x_new ram_addr i
    swap over cells +   \ -- x_new i &x[i]
    swap over           \ -- x_new &x[i] i &x[i]
    swap over 1 cells + \ -- x_new &x[i] &x[i] i &x[i+1]
    swap                \ -- x_new &x[i] &x[i] &x[i+1] i
    r@ 1 cells - @      \ -- x_new &x[i] &x[i] &x[i+1] i N_used
    swap - cells        \ -- x_new &x[i] &x[i] &x[i+1] 2*(N_used-i)
    cmove>              \ -- x_new &x[i]
    !                   \ --
    1 r> 1 cells - +!   ( N_used++ )
  else
    drop drop drop
  then
;

: sort_insert ( x_new ram_addr n -- )                    \ n == size!
  noop                  \ -- x_new ram_addr n
  \ do nothing if x_new == $ffff
  2 pick $7fff < if
    over >r             \ -- x_new ram_addr n            R: &x[0]
    sort_next           \ -- x_new ram_addr i
    swap over cells +   \ -- x_new i &x[i]
    swap over           \ -- x_new &x[i] i &x[i]
    swap over 1 cells + \ -- x_new &x[i] &x[i] i &x[i+1]
    swap                \ -- x_new &x[i] &x[i] &x[i+1] i
    r@ 1 cells - @      \ -- x_new &x[i] &x[i] &x[i+1] i N_used
    swap - cells        \ -- x_new &x[i] &x[i] &x[i+1] 2*(N_used-i)
    cmove>              \ -- x_new &x[i]
    !                   \ --
    1 r> 1 cells - +!   ( N_used++ )
  else
    drop drop drop
  then
;

: .uFsort ( ram_addr n -- )
  over 1 cells - @ 4 u0.r space space \ N_used
  cells over + swap \ ram_addr+n*cells ram_addr
  ?do
    i @ 6 u0.r space
  [ 1 cells ] literal +loop
;
: .Fsort ( ram_addr n -- )
  over 1 cells - @ 4 u0.r space space \ N_used
  cells over + swap \ ram_addr+n*cells ram_addr
  ?do
    i @ 6 .r space
  [ 1 cells ] literal +loop
;
