\ Named Port Pins
\ V 1.1 20.05.2007

\ Code: Matthias Trute
\ Text: M.Kalus

\ A named port pin puts a bitmask on stack, wherin the set bit indicates which
\ bit of the port register corresponds to the pin. 
\ And then puts the address of its port on stack too. 

\ Use it this way:
\ PORTD 7 portpin: PD.7  ( define portD pin #7)
\ PD.7 is_output         ( set DDRD so that portD pin #7 is output)
\ PD.7 on                ( turn portD pin #7 on, i.e. set it high-level)
\ PD.7 off               ( turn portD pin #7 off, i.e. set it low-level)

hex

\ At compiletime:
\ Store combination of portaddress and bit number in a cell and give it a name.
\ At runtime:
\ Get pinmask and portaddress on stack.
: portpin: create ( C: "ccc" portadr n -- ) ( R: -- pinmask portadr )
    1 swap lshift
    8 lshift or ,               \ packed value
  does> i@                      \ get packed value
    dup 8 rshift swap ff and    \ 
;

\ Turn a port pin on, dont change the others.
: on ( pinmask portadr -- )
    dup  ( -- pinmask portadr portadr )
    c@   ( -- pinmask portadr value )
    rot  ( -- portadr value pinmask )
    or   ( -- portadr new-value)
    swap ( -- new-value portadr)
    c!
;

\ Turn a port pin off, dont change the others.
: off ( pinmask portadr -- )
    dup  ( -- pinmask portadr portadr )
    c@   ( -- pinmask portadr value )
    rot  ( -- portadr value pinmask )
    invert and ( -- portadr new-value)
    swap ( -- new-value port)
    c!
;

\ Only for PORTx bits, 
\ because address of DDRx is one less than address of PORTx. (ATmega169)

\ Set DDRx so its corresponding pin is output.
: is_output ( pinmask portadr -- )
    1- on
;

\ Set DDRx so its corresponding pin is input.
: is_input  ( pinmask portadr -- )   
    1- off
;

\ finis
