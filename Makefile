dir     = example
source  = $(dir)/book.txt
foxsl   = $(dir)/fo.xsl
epubxsl = $(dir)/epub.xsl
fopconf = $(dir)/fop.xconf

pdf     = Book.pdf
epub    = Book.epub

output  = .output
docbook = $(output)/book.xml
fo      = $(output)/book.fo

all: $(pdf) $(epub)

$(pdf): $(fo)
	fop -c "$(fopconf)" -fo "$(fo)" -pdf "$(pdf)"

$(epub): $(docbook)
	xsltproc -o "$(epub)" "$(epubxsl)" "$(docbook)"
	find OEBPS -type f -name '*html' -exec ./scripts/highlight html {} "$(dir)" \;
	echo "application/epub+zip" > mimetype
	zip -Xr "$(epub)" mimetype OEBPS META-INF
	rm -rf mimetype OEBPS META-INF

$(fo): $(docbook)
	xsltproc -o "$(fo)" "$(foxsl)" "$(docbook)"
	./scripts/highlight fo "$(fo)" "$(dir)"

$(docbook): clean
	mkdir "$(output)"
	asciidoc -b docbook -o "$(docbook)" "$(source)"
	./scripts/highlight docbook "$(docbook)" "$(dir)"

clean:
	if [ -e "$(pdf)" ] ; then rm "$(pdf)" ; fi
	if [ -e "$(epub)" ] ; then rm "$(epub)" ; fi
	if [ -e mimetype ] ; then rm mimetype ; fi
	rm -rf "$(output)" OEBPS META-INF

