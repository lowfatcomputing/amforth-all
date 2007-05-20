# user modifiable secion is up here

# AMFORTH=../../releases/2.0
AMFORTH=../../trunk
AVRDUDE=avrdude
AVRA=/opt/cdk4avr/bin/avra
INCLUDE=-I ~/lib/avra -I $(AMFORTH)

USB=-c avr911  -P /dev/ttyUSB1
PP=-c stk200  -P /dev/parport0
JTAG=-c jtag2 -P /dev/ttyUSB2

p16: p16.hex
	$(AVRDUDE) $(USB) -p atmega169 -e -U flash:w:p16.hex:i -U eeprom:w:p16.eep.hex:i

p16.hex: p16.asm $(AMFORTH)/*.asm $(AMFORTH)/words/*.asm $(AMFORTH)/devices/*.asm 
	$(AVRA) $(INCLUDE) --listmac -l p16.lst -m p16.map p16.asm

p16.back:
	$(AVRDUDE) $(USB) -p atmega169  -U flash:r:p16.hex:i -U eeprom:r:p16.eep.hex:i

p8: p8.hex
	$(AVRDUDE) $(USB) -p atmega169 -e -U flash:w:p8.hex:i -U eeprom:w:p8.eep.hex:i

p8.hex: p8.asm $(AMFORTH)/*.asm $(AMFORTH)/words/*.asm $(AMFORTH)/devices/*.asm 
	$(AVRA) $(INCLUDE) --listmac -l p8.lst -m p8.map p8.asm

p8.back:
	$(AVRDUDE) $(USB) -p atmega169  -U flash:r:p8.hex:i -U eeprom:r:p8.eep.hex:i

clean:
	rm -f p8.hex p8.eep.hex p8.lst p8.map p8.cof p8.obj
	rm -f p16.hex p16.eep.hex p16.lst p16.map p16.cof p16.obj

