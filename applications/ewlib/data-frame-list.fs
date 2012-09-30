\ 2011-11-17  ew  ewlib/data-frame-list.fs
\ handle data-frames organized in a singly linked list

: df.head:
  create ( prec D.idid  idid  --  )
  ,         \ store idid
  ,         \ store &D.idid (data.frame:)
  ,         \ store decimal places for data.ls
does>    ( -- addr )
  \ place addr on stack
;
: df.list.find ( idid addr -- addr[data.frame]>0 | 0 )
  begin
    over over               \ id addr id addr
    1+ @i @i = if           \ id addr id id(addr(addr))
      dup 1+ @i 1+ @i
      swap drop swap drop   \ clean up
      exit                  \ ok
    then
    list.next ( addr.next)
  dup 0= until
  drop drop 0               \ false
;

: df.list.reset ( addr -- )
  1+ @i df.size erase
;
: df.list.eval ( addr -- )
  dup 2 + @i             \ -- addr prec
  swap 1+ @i             \ -- prec df
  dup @  0= not if       \ -- prec df
    \ frame with data
    df:dat+ swap         \ -- df:dat prec
    .Dn
  else
    \ frame erased
    drop drop
  then
;
