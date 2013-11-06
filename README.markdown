# How to build a book

This repo contains the build framework I used to write [JavaScript Testing
Recipes](http://jstesting.jcoglan.com/). It converts the source text written in
[AsciiDoc](http://www.methods.co.nz/asciidoc/) into EPUB, MOBI and PDF formats,
checks all the example code, and gives you a word count. It includes a cover
image for each format, and has some customisation of the print formatting for
the PDF. The main tasks are:

* `make test`: runs all the tests for the example code
* `make book`: compiles the source text to all the publishing formats
* `make words`: prints a word count for the source text
* `make`: runs all the above tasks

I'm tremendously grateful to Chris Strom and Tom Stuart, who answered a lot of
my initial questions, and to the authors of
[git-scribe](https://github.com/schacon/git-scribe), which I cribbed some of my
toolchain from.


## What do I need?

You need these programs, which if you're using Ubuntu you can get using `apt-get
install`.

* `asciidoc`
* `fop`
* `kindlegen` (download from Amazon)
* `make`
* `python` and `python-pygments`
* `xsltproc`

The example code that's run by `make test` also requires
[PhantomJS](http://phantomjs.org/) and [Node.js](http://nodejs.org/).


## How does it work?

When you run `make` in this directory, the following things happen:

* All the files named `browser.html` under `code/browser` are run via PhantomJS
* All the files named `node.js` under `code/node` are run via Node.js
* The AsciiDoc source file `book/book.txt` is compiled to DocBook XML
* A Python script applies highlighting annotations to the XML
* This XML is converted into XSL-FO and EPUB using the DocBook XSLT stylesheets
* A Python script applies syntax highlighting to the XSL-FO and EPUB files
* The XSL-FO file is compiled into a PDF
* The EPUB files are bundled into a zip archive and converted to MOBI

The book's formatting is controlled by the files in the `book` directory, in
particular:

* `book.txt`: This is the root file for the book's content, written in AsciiDoc.
* `book-docinfo.xml`: Contains additional XML that specifies the cover image.
* `common.xsl`: Stylesheet with rules common to EPUB and XSL-FO output.
* `epub.xsl`: Stylesheet that controls the generation of EPUB from DocBook.
* `fo.xsl`: Controls generation of XSL-FO from DocBook, which is turned into
  PDF.
* `fop.xconf`: Configures `fop`, which turns XSL-FO into a PDF. Tells it where
  your fonts are, and so on.
* `syntax.py`: Formatting data for Pygments, which is used for syntax
   highlighting.

To make sure the code the appears in the book works correctly, it is included
from the files in `code` (which are checked by `make test`), rather than being
written inline with the source text. AsciiDoc uses the following syntax for
doing this:

```
[source,html]
----
include::../../code/browser/hello_world/browser.html[]
----
```

The AsciiDoc language annotation is then used by Pygments to highlight the
imported code.

