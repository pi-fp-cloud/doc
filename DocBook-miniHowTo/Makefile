# Makefile para la generación automática en PDF y XHTML de documentos XML DocBook

STYLESHEETS_DIR=/usr/share/xml/docbook/stylesheet/docbook-xsl-ns
SOURCE=bk-docbook-miniHowTo
XSLTPROC=/usr/bin/xsltproc
OPTS=--xinclude --stringparam paper.type A4
XSL=none

all: html pdf

html:
	xsltproc -o $(SOURCE).html $(STYLESHEETS_DIR)/xhtml/docbook.xsl $(SOURCE).xml
fo:
	xsltproc $(OPTS) -o $(SOURCE).fo $(STYLESHEETS_DIR)/fo/docbook.xsl $(SOURCE).xml

pdf: fo
	fop $(SOURCE).fo -pdf $(SOURCE).pdf	

clean:
	rm $(SOURCE).fo $(SOURCE).pdf $(SOURCE).html
