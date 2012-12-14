source  = example/book.txt
foxsl   = example/fo.xsl
fopconf = example/fop.xconf
target  = Book.pdf
output  = .output

all: clean
	mkdir "$(output)"
	asciidoc -b docbook -o "$(output)/book.xml" "$(source)"
	./scripts/highlight docbook "$(output)/book.xml" example
	xsltproc -o "$(output)/book.fo" "$(foxsl)" "$(output)/book.xml"
	./scripts/highlight fo "$(output)/book.fo" example
	fop -c "$(fopconf)" -fo "$(output)/book.fo" -pdf "$(target)"

clean:
	[ -e "$(target)" ] && rm "$(target)" || true
	rm -rf "$(output)"
