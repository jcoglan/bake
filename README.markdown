# How to build a book

I'm trying to figure out how to build a book using plain text and free software.
After lots of annoying questions and some generous help from Chris Strom and Tom
Stuart, I'm getting there. I've been poking around in
[git-scribe](https://github.com/schacon/git-scribe) and looking at the
underlying tools it's using so I have a better grasp of how to customize things.


## What do I need?

You need these programs, which you can get from apt-get or homebrew or wherever,
probably.

* `asciidoc`
* `xsltproc`
* `python` and `python-pygments`
* `fop`


## How does it work?

Run `make` in this directory. This takes a book written in AsciiDoc, turns it
into DocBook, turns that into XSL-FO, and turns that into PDF. After generating
both the DocBook and XSL-FO files, it does some post-processing to add syntax
highlighting using a Python script. It also generates EPUB from the Docbook
output, including syntax highlighting.

See `Makefile` for more detail. The files in `example` work as follows:

* `book.txt`: This is the root file for the book's content, written in AsciiDoc.
* `common.xsl`: Stylesheet with rules common to EPUB and XSL-FO output.
* `epub.xsl`: Stylesheet that controls the generation of EPUB from DocBook.
* `fo.xsl`: Controls generation of XSL-FO from DocBook, which is turned into PDF.
* `fop.xconf`: Configures `fop`, which turns XSL-FO into a PDF. Tells it where
  your fonts are, and so on.
* `syntax.py`: Formatting data for Pygments, which is used for syntax
  highlighting.

