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
zip     = $(title).zip

output  = .output
docbook = $(output)/book.xml
fo      = $(output)/book.fo

all: test book
book: pdf epub mobi words
dist: $(zip)
epub: $(epub)
mobi: $(mobi)
pdf: $(pdf)

clean:
	rm -rf "$(output)" "$(epub)" "$(mobi)" "$(pdf)" "$(zip)"

test: browser node

words:
	find book -name "*.txt" | xargs wc -w

$(zip): all
	mkdir -p "$(title)"
	cp "$(epub)" "$(title)/$(epub)"
	cp "$(mobi)" "$(title)/$(mobi)"
	cp "$(pdf)" "$(title)/$(pdf)"
	cp -r code "$(title)/Code"
	zip -r "$(zip)" "$(title)"
	rm -rf "$(title)"

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
	mkdir -p "$(output)"
	asciidoc -a docinfo -b docbook -o "$(docbook)" "$(source)"
	./scripts/highlight docbook "$(docbook)" "$(dir)"

browser:
	for file in $$(find code/browser -name test.html); do \
		echo "Testing: $$file"; \
		FORMAT=tap phantomjs code/phantom.js $$file; \
		if [ $$? -ne 0 ]; then \
			exit 1; \
		fi; \
	done

node:
	for file in $$(find code/node -name test.js); do \
		echo "Testing: $$file"; \
		FORMAT=tap node $$file; \
		if [ $$? -ne 0 ]; then \
			exit 1; \
		fi; \
	done

