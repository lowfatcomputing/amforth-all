# simple makefile for building the 
# template project. 

# versions before 2.1 may produce some warnings
# but should produce a running system. You should
# _always_ use the trunk.

#AMFORTH=../../releases/1.8
AMFORTH=../../trunk

# the MCU should be identical to the device
# setting in template.asm
MCU=atmega169

# some programs
AVRDUDE=avrdude
AVRA=/opt/cdk4avr/bin/avra
INCLUDE=-I ~/lib/avra -I $(AMFORTH)

# some settings
USB=-c avr911  -P /dev/ttyUSB1
PP=-c stk200  -P /dev/parport0
JTAG=-c jtag2 -P /dev/ttyUSB2

template: template.hex
	$(AVRDUDE) $(USB) -p $(MCU) -e -U flash:w:template.hex:i -U eeprom:w:template.eep.hex:i

template.hex: template.asm $(AMFORTH)/*.asm $(AMFORTH)/words/*.asm $(AMFORTH)/devices/*.asm 
	$(AVRA) $(INCLUDE) --listmac -l template.lst -m template.map template.asm

template.back:
	$(AVRDUDE) $(USB) -p $(MCU)  -U flash:r:template.hex:i -U eeprom:r:template.eep.hex:i

clean:
	rm -f template.hex template.eep.hex template.lst template.map template.cof template.obj

