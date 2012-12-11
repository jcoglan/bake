<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<!-- Start with the DocBook->FO rules from the DocBook XSL library -->
<xsl:import href="../docbook-xsl-1.77.1/fo/docbook.xsl" />

<!-- Enable extensions. Among other things, this gives the PDF a browsable
     section index. -->
<xsl:param name="fop1.extensions">1</xsl:param>

<!-- Paper size configuration -->
<xsl:param name="paper.type">A4</xsl:param>

<!-- If the source contains a <?asciidoc-numbered?> directive, then enable
     automatic section numbering. -->
<xsl:param name="section.autolabel">
  <xsl:choose>
    <xsl:when test="/processing-instruction('asciidoc-numbered')">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<!-- Convert asciidoc page breaks into FO equivalents -->
<xsl:template match="processing-instruction('asciidoc-pagebreak')">                                                                                                                               
  <fo:block break-after="page" />
</xsl:template>

<!-- Font settings -->
<xsl:param name="title.font.family">Georgia</xsl:param>
<xsl:param name="body.font.family">FreeSans</xsl:param>
<xsl:param name="monospace.font.family">'Andale Mono'</xsl:param>

</xsl:stylesheet>

