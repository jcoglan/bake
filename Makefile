dir     = example
source  = $(dir)/book.txt
foxsl   = $(dir)/fo.xsl
fopconf = $(dir)/fop.xconf

target  = Book.pdf

output  = .output
xml     = $(output)/book.xml
fo      = $(output)/book.fo

$(target): $(fo)
	fop -c "$(fopconf)" -fo "$(fo)" -pdf "$(target)"

$(fo): $(xml)
	xsltproc -o "$(fo)" "$(foxsl)" "$(xml)"
	./scripts/highlight fo "$(fo)" "$(dir)"

$(xml): clean
	mkdir "$(output)"
	asciidoc -b docbook -o "$(xml)" "$(source)"
	./scripts/highlight docbook "$(xml)" "$(dir)"

clean:
	[ -e "$(target)" ] && rm "$(target)" || true
	rm -rf "$(output)"
