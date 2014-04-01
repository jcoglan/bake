source_dir    := book
source        := $(source_dir)/book.txt
assets        := $(source_dir)/css $(source_dir)/images
foxsl         := $(source_dir)/fo.xsl
epubxsl       := $(source_dir)/epub.xsl
fopconf       := $(source_dir)/fop.xconf

title         := example-book
epub          := $(title).epub
mobi          := $(title).mobi
pdf           := $(title).pdf
zip           := $(title).zip

epub_files    := mimetype META-INF OEBPS

book_files    := $(shell find book -type f)
example_files := $(shell find code/browser code/node -type f)

output        := .output
docbook       := $(output)/book.xml
fo            := $(output)/book.fo

.PHONY: all book dist epub mobi pdf clean words test testcount compile browser node
all: test book words
book: epub mobi pdf
dist: all $(zip)
epub: $(epub)
mobi: $(mobi)
pdf: $(pdf)

$(zip): $(epub) $(mobi) $(pdf) $(example_files)
	mkdir -p $(title)
	cp $(epub) $(title)/$(epub)
	cp $(mobi) $(title)/$(mobi)
	cp $(pdf) $(title)/$(pdf)
	cp -r code $(title)/Code
	zip -r $@ $(title)
	rm -rf $(title)

$(mobi): $(epub)
	ebook-convert $< $@ || true

$(epub): $(book_files) $(docbook)
	xsltproc -o $@ $(epubxsl) $(docbook)
	echo -n "application/epub+zip" > mimetype
	find OEBPS -type f -name "*.html" -exec ./scripts/highlight html {} $(source_dir) \;
	for dir in $(assets); do \
		mkdir -p $$(dirname OEBPS/$$dir); \
		cp -r $$dir OEBPS/$$dir; \
	done
	zip -0X $@ mimetype
	zip -9XDr $@ META-INF OEBPS
	rm -rf $(epub_files)

$(pdf): $(book_files) $(fo)
	fop -c $(fopconf) -fo $(fo) -pdf $@

$(fo): $(book_files) $(docbook)
	xsltproc -o $@ $(foxsl) $(docbook)
	./scripts/highlight fo $@ $(source_dir)

$(docbook): $(book_files) $(example_files)
	mkdir -p $(output)
	asciidoc -a docinfo -b docbook -o $@ $(source)
	./scripts/highlight docbook $@ $(source_dir)

clean:
	rm -rf $(output) $(epub_files) $(epub) $(mobi) $(pdf) $(zip)

words:
	find book -name "*.txt" | sort | xargs wc -w

test: browser node

testcount:
	$(MAKE) test 2> /dev/null | grep "1\.\." | cut -d. -f3 | paste -sd+ | bc

compile:
	for file in $$(find code/browser -type f -name Makefile); do \
		echo "Compiling: $$file"; \
		$(MAKE) -C $$(dirname $$file);\
		$(MAKE) -C $$(dirname $$file) test.js || true; \
	done

browser: compile
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

