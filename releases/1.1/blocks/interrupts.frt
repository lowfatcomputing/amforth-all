( make noop the default interrupt word )
: initIntVectors
    4 0 do
	['] noop i intvector !
	0 i intcounter !
    loop
;

( print intcounters )
: .ic
    4 0 do
	i dup . intcounter @ space . cr 
    loop
;

