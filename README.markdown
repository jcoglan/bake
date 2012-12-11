# How to build a book

I'm trying to figure out how to build a book using plain text and free software.
After lots of annoying questions and some generous help from Chris Strom and Tom
Stuart, I'm getting there. I've been poking around in
[git-scribe](https://github.com/schacon/git-scribe) and looking at the
underlying tools it's using so I have a better grasp of how to customize things.


## What do I need?

You need these programs, which you can get from apt-get or homebrew or wherever,
probably.

* asciidoc
* xsltproc
* fop


## How does it work?

Run `./build` in this directory. This takes a book written in AsciiDoc, turns it
into DocBook, turns that into XSL-FO, and turns that into PDF. There is room for
preprocessing between steps, which will probably be necessary for stuff like
syntax highlighting.


## What's in here?

* The DocBook XSL library, version 1.77.1. This is a big library of standard
  XSL files for turning DocBook into other formats.
* An example AsciiDoc book
* An example XSL formatting file for tweaking the book's final appearance
* An example FOP configuration file

