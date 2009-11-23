! cflags = $(cflags)/debug/nooptimize
! linkflags = $(linkflags)/debug

all : net.cmd 
	! all built, ready to download

reload : all 
	mcr sys$disk:[]send load.bas net.cmd

net.cmd : -
    t102.exe -
    t102_rom.cmd -
    t102.cmd -
    compat.fth -
    asm.fth -
    protocol.fth -
    cl.fth -
    slip.fth -
    ip.fth -
    icmp.fth -
    udp.fth -
    net.fth
	mcr sys$disk:[]t102 t102.cmd -r net.fth

