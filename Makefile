source_dir    := book
source        := $(source_dir)/book.txt
assets        := $(source_dir)/css $(source_dir)/images

config_dir    := config
foxsl         := $(config_dir)/fo.xsl
epubxsl       := $(config_dir)/epub.xsl
fopconf       := $(config_dir)/fop.xconf

title         := example-book
epub          := $(title).epub
mobi          := $(title).mobi
pdf           := $(title).pdf
zip           := $(title).zip

epub_files    := mimetype META-INF OEBPS

book_files    := $(shell find book -type f)
config_files  := $(shell find config -type f)
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

clean:
	rm -rf $(output) $(epub_files) $(epub) $(mobi) $(pdf) $(zip)

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

$(epub): $(docbook)
	xsltproc -o $@ $(epubxsl) $(docbook)
	echo -n 'application/epub+zip' > mimetype
	find OEBPS -type f -name '*.html' -exec ./config/scripts/highlight html {} $(config_dir) \;
	for dir in $(assets) ; do \
		mkdir -p $$(dirname OEBPS/$$dir) ; \
		cp -r $$dir OEBPS/$$dir ; \
	done
	zip -0X $@ mimetype
	zip -9XDr $@ META-INF OEBPS
	rm -rf $(epub_files)

$(pdf): $(fo)
	fop -c $(fopconf) -fo $(fo) -pdf $@

$(fo): $(docbook)
	xsltproc -o $@ $(foxsl) $(docbook)
	./config/scripts/highlight fo $@ $(config_dir)

$(docbook): $(book_files) $(config_files) $(example_files)
	mkdir -p $(output)
	asciidoc -a docinfo -b docbook -o $@ $(source)
	./config/scripts/highlight docbook $@ $(config_dir)

words:
	find book -name '*.txt' | sort | xargs wc -w

test: browser node

testcount:
	$(MAKE) test 2> /dev/null | grep '1\.\.' | cut -d. -f3 | paste -sd+ | bc

compile:
	for file in $$(find code/browser -type f -name Makefile) ; do \
		echo "Compiling: $$file" ; \
		$(MAKE) -C $$(dirname $$file) ; \
		$(MAKE) -C $$(dirname $$file) test.js || true ; \
	done

browser: compile
	for file in $$(find code/browser -name test.html) ; do \
		echo "Testing: $$file" ; \
		FORMAT=tap phantomjs code/phantom.js $$file || exit 1 ; \
	done

node:
	for file in $$(find code/node -name test.js) ; do \
		echo "Testing: $$file" ; \
		BROWSER=phantomjs FORMAT=tap node $$file || exit 1 ; \
	done
