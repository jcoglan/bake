dir     = example
source  = $(dir)/book.txt
foxsl   = $(dir)/fo.xsl
fopconf = $(dir)/fop.xconf

target  = Book.pdf

output  = .output
docbook = $(output)/book.xml
fo      = $(output)/book.fo

$(target): $(fo)
	fop -c "$(fopconf)" -fo "$(fo)" -pdf "$(target)"

$(fo): $(docbook)
	xsltproc -o "$(fo)" "$(foxsl)" "$(docbook)"
	./scripts/highlight fo "$(fo)" "$(dir)"

$(docbook): clean
	mkdir "$(output)"
	asciidoc -b docbook -o "$(docbook)" "$(source)"
	./scripts/highlight docbook "$(docbook)" "$(dir)"

clean:
	[ -e "$(target)" ] && rm "$(target)" || true
	rm -rf "$(output)"
