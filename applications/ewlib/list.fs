\ 2010-01-24  EW  ewlib/list.fs (amforth 3.7)
\ 2011-01-14  change for amforth 4.2
\             here -> dp   (wordlist, flash)
\             heap -> here (data, ram)
\ 2011-05-29  i@,i! -> @i,!i
\ 
\ a list is a series of locations with 2 cells each
\ 1. a pointer to the "next" entry (next == 0 is end of list)
\ 2. a pointer to the object to be referenced
\ the actual head of the list is kept outside,
\ e.g. in a value.
\ 0 value sensorList

\ words:
\   list.add ( 'object 'next -- 'list.head )
\   list.next ( addr -- addr' )
\   list.ref  ( addr -- addr' )
\   list.show ( 'list.head -- )
\   list.walk ( xt 'list.head -- )

: list.add ( 'object 'next -- 'list.head )
  dp >r           \ save new list.head
  ,                 \ link to "next"
  ,                 \ pointer to object
  r>                \ new list.head for update
;

: list.next ( addr -- addr' )  @i ;     \ addr of next entry
: list.ref  ( addr -- addr' )  1+ @i ;  \ addr of referenced object
: list.show ( 'list.head -- )
  dup 0= if ." empty" cr drop exit then
  begin
    dup       4 u0.r space
    dup    @i 4 u0.r space
    dup 1+ @i 4 u0.r cr
  list.next dup 0= until
  drop
;
: list.walk ( xt 'list.head -- )
  dup 0= if
    ." empty" cr
    drop drop
    exit
  then
  begin                         \ -- xt 'list.item
    over over                   \ -- xt 'list.item  xt 'list.item
    list.ref swap               \ -- xt 'list.item  addr-of-ref xt
    execute                     \ -- xt 'list.item
    list.next                   \ -- xt 'list.item->next
    pause
  dup 0= until
  drop drop
;
