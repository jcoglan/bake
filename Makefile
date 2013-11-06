dir     = book
source  = $(dir)/book.txt
images  = $(dir)/images
foxsl   = $(dir)/fo.xsl
epubxsl = $(dir)/epub.xsl
fopconf = $(dir)/fop.xconf

title   = example-book
pdf     = $(title).pdf
epub    = $(title).epub
mobi    = $(title).mobi

output  = .output
docbook = $(output)/book.xml
fo      = $(output)/book.fo

all: test book
book: pdf epub mobi words
pdf: $(pdf)
epub: $(epub)
mobi: $(mobi)

test: browser node

words:
	find book -name "*.txt" | xargs wc -w

$(mobi): $(epub)
	kindlegen "$(epub)" -o "$(mobi)" || true

$(epub): $(docbook)
	xsltproc -o "$(epub)" "$(epubxsl)" "$(docbook)"
	echo -n "application/epub+zip" > mimetype
	find OEBPS -type f -name "*html" -exec ./scripts/highlight html {} "$(dir)" \;
	mkdir -p "$$(dirname OEBPS/$(images))"
	cp -r "$(images)" "OEBPS/$(images)"
	zip -0X "$(epub)" mimetype
	zip -9XDr "$(epub)" META-INF OEBPS
	rm -rf mimetype META-INF OEBPS

$(pdf): $(fo)
	fop -c "$(fopconf)" -fo "$(fo)" -pdf "$(pdf)"

$(fo): $(docbook)
	xsltproc -o "$(fo)" "$(foxsl)" "$(docbook)"
	./scripts/highlight fo "$(fo)" "$(dir)"

$(docbook): clean
	mkdir "$(output)"
	asciidoc -a docinfo -b docbook -o "$(docbook)" "$(source)"
	./scripts/highlight docbook "$(docbook)" "$(dir)"

clean:
	rm -rf "$(output)" "$(epub)" "$(mobi)" "$(pdf)"

browser:
	for file in $$(find code/browser -name browser.html); do \
		echo "Testing: $$file"; \
		FORMAT=tap phantomjs code/phantom.js $$file; \
		if [ $$? -ne 0 ]; then \
			exit 1; \
		fi; \
	done

node:
	for file in $$(find code/node -name node.js); do \
		echo "Testing: $$file"; \
		FORMAT=tap node $$file; \
		if [ $$? -ne 0 ]; then \
			exit 1; \
		fi; \
	done

