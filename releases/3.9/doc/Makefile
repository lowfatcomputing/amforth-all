# Make to convert the documentation into all 
# relevant target formats

AM_TECHNICAL_HB = amforth.xml \
                  amforth-architecture.xml amforth-bookinfo.xml amforth-closing.xml \
                  amforth-de.xml amforth-firststeps.xml amforth-hardware.xml \
                  amforth-implementation.xml amforth-library.xml amforth-preface.xml \
                  amforth-sources.xml amforth-tools.xml amforth-version.xml
AM_TECHNICAL_HB_PICS = ram-structure.eps ram2-structure.eps \
                       flash-structure.eps flash2-structure.eps \
                       flash3-structure.eps

all:  amforth.pdf refcard.pdf

%.eps: %.dia
	dia -e $@ -t eps $<

clean:
	rm amforth.pdf refcard.pdf *.eps



amforth.pdf: ${AM_TECHNICAL_HB} ${AM_TECHNICAL_HB_PICS} jadetex.cfg 
	docbook2dvi -l /usr/share/sgml/declaration/xml.dcl amforth.xml
	dvipdf amforth.dvi amforth.pdf
	rm amforth.dvi

refcard.pdf: refcard.tex 
	pdflatex refcard.tex
	rm refcard.aux refcard.log

