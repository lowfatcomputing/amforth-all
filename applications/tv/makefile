# user modifiable secion is up here

# AMFORTH=../../releases/2.0
AMFORTH=../../trunk
AVRDUDE=avrdude
AVRA=avra
INCLUDE=-I ~/lib/avra -I $(AMFORTH)

USB=-c avrisp2  -P /dev/ttyS1 -F
PP=-c stk200  -P /dev/parport0
JTAG=-c jtag2 -P /dev/ttyUSB2

tv: tv.hex
	$(AVRDUDE) $(USB) -p atmega16 -e -U flash:w:tv.hex:i -U eeprom:w:tv.eep.hex:i

tv.hex: tv.asm $(AMFORTH)/*.asm $(AMFORTH)/words/*.asm $(AMFORTH)/devices/*.asm 
	$(AVRA) $(INCLUDE) --listmac -l tv.lst -m tv.map tv.asm

tv.back:
	$(AVRDUDE) $(USB) -p atmega16  -U flash:r:tv.hex:i -U eeprom:r:tv.eep.hex:i

clean:
	rm -f tv.hex tv.eep.hex tv.lst tv.map tv.cof tv.obj

