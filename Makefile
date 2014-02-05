source_dir    := book
source        := $(source_dir)/book.txt
images        := $(source_dir)/images
foxsl         := $(source_dir)/fo.xsl
epubxsl       := $(source_dir)/epub.xsl
fopconf       := $(source_dir)/fop.xconf

title         := example-book
epub          := $(title).epub
mobi          := $(title).mobi
pdf           := $(title).pdf
zip           := $(title).zip

book_files    := $(shell find book -type f)
code_files    := $(shell find code -type f)
example_files := $(shell find code/browser code/node -type f)

output        := .output
docbook       := $(output)/book.xml
fo            := $(output)/book.fo

.PHONY: all book dist epub mobi pdf clean words test testcount browser node
all: test book words
book: epub mobi pdf
dist: all $(zip)
epub: $(epub)
mobi: $(mobi)
pdf: $(pdf)

$(zip): $(epub) $(mobi) $(pdf) $(code_files)
	mkdir -p "$(title)"
	cp "$(epub)" "$(title)/$(epub)"
	cp "$(mobi)" "$(title)/$(mobi)"
	cp "$(pdf)" "$(title)/$(pdf)"
	cp -r code "$(title)/Code"
	zip -r "$(zip)" "$(title)"
	rm -rf "$(title)"

$(mobi): $(epub)
	kindlegen "$(epub)" -o "$(mobi)" || true

$(epub): $(book_files) $(docbook)
	xsltproc -o "$(epub)" "$(epubxsl)" "$(docbook)"
	echo -n "application/epub+zip" > mimetype
	find OEBPS -type f -name "*html" -exec ./scripts/highlight html {} "$(source_dir)" \;
	mkdir -p "$$(dirname OEBPS/$(images))"
	cp -r "$(images)" "OEBPS/$(images)"
	zip -0X "$(epub)" mimetype
	zip -9XDr "$(epub)" META-INF OEBPS
	rm -rf mimetype META-INF OEBPS

$(pdf): $(book_files) $(fo)
	fop -c "$(fopconf)" -fo "$(fo)" -pdf "$(pdf)"

$(fo): $(book_files) $(docbook)
	xsltproc -o "$(fo)" "$(foxsl)" "$(docbook)"
	./scripts/highlight fo "$(fo)" "$(source_dir)"

$(docbook): $(book_files) $(example_files)
	mkdir -p "$(output)"
	asciidoc -a docinfo -b docbook -o "$(docbook)" "$(source)"
	./scripts/highlight docbook "$(docbook)" "$(source_dir)"

clean:
	rm -rf "$(output)" "$(epub)" "$(mobi)" "$(pdf)" "$(zip)"

words:
	find book -name "*.txt" | sort | xargs wc -w

test: browser node

testcount:
	$(MAKE) test 2> /dev/null | grep "1\.\." | cut -d. -f3 | paste -sd+ | bc

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

