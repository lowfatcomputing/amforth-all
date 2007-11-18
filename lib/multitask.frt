\ cooperative multitasker
\ need amforth 2.5 and up due to changed user area
\ version 0.1 (alfa quality)

marker _multitask_

0 user status
2 user follower

:noname ( tcb1 -- tcb2 ) cell+ @  dup @ 1+ >r ; 
    constant pass
:noname  ( tcb1 -- )  up! sp @ sp! rp! ;
    constant wake

\ let next task execute
: multitaskpause   ( -- )     rp@ sp@ sp ! follower @ dup @ 1+  >r ; 

: stop         ( -- )     pass status ! pause ; \ sleep current task
: task-sleep   ( tcb -- ) pass swap ! ;         \ sleep another task
: task-awake   ( tcb -- ) wake swap ! ;         \ wake another task

\ continue the code as a task in a predefined tcb
: activate ( tcb -- )
    \ save the current TOR to the TOR of the task
    r> over 4 +  @ 2 - !      ( -- tcb )
    \ fake some stack operations rp@
    dup dup cell+ cell+ @ 4 -  \ calculate the value of rp
    \ read the data stack pointer
        swap 6 + @ 2 - ( -- tcb rp sp0 )
	swap over !    ( -- tcb sp0 )
	\ write sp
	4 - ( new sp value ) over 8 + ( location of sp in tcb) 
	! ( -- tcb )
    task-awake
;

\ stop multitasking
: single ( -- ) \ initialize the multitasker with the serial terminal
    ['] noop is pause
;

\ start multitasking
: multi ( -- )
    ['] multitaskpause is pause
;

\ task:     creates the task data structures, leaves the TCB on stack
\ alsotask  appends the TCB to the (circular, existing) list of TCB

decimal

: task: ( rs-size ds-size -- tcb )
	\ allocate stack memory
	heap e@ >r ( allocate user area, move to return stack )
	24 allot \ user size
	allot heap e@ 1-  ( -- rs-size sp0 )
	r@ 6 + !          (  ... place it in tcb )
	allot heap e@ 1-  ( -- rp0 )
	   r@  4 + !      (  ... place it in tcb )
	0  r@  8 + !      (  ... init handler )
	0  r@ 10 + !   ( clear handler )
	10 r@ 12 + !  ( set base to decimal )
	r>            ( -- tcb )
;

\ initialize the multitasker with the current task only
: onlytask ( -- ) 
    wake status !   \ own status is running
    up@  follower ! \ point to myself
;

\ insert new task structure into task list
: alsotask      ( tcb -- )
   ['] pause defer@ >r \ stop multitasking
   single
   follower @   ( -- tcb f) 
   over         ( -- tcb f tcb )
   follower !   ( -- tcb f )
   swap cell+   ( -- f tcb-f )
   !
   r> is pause  \ restore multitasking
;


: task-list ( -- )
    status ( -- tcb ) \ starting value
    dup
    begin      ( -- tcb1 ctcb )
	dup u.  ( -- tcb1 ctcb )
	dup @  ( -- tcb1 ctcb status )
	  dup 
	    wake = if ."  running"  drop else
	    pass = if ."  sleeping" else
	              ."  unknown"  then
	then
	cr
	cell+ @ ( -- tcb1 next-tcb )
	over  over =     ( -- f flag)
    until
    drop drop
;
