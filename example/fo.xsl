<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<!-- Start with the DocBook->FO rules from the DocBook XSL library -->
<xsl:import href="../docbook-xsl-1.77.1/fo/docbook.xsl" />

<!-- Enable extensions. Among other things, this gives the PDF a browsable
     section index. -->
<xsl:param name="fop1.extensions">1</xsl:param>

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

<!-- Generated text settings - these control generated titles, cross references,
     and so forth. -->
<xsl:param name="local.l10n.xml" select="document('')" />
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">
    <l:context name="title-numbered">
      <l:template name="chapter" text="%n. %t" />
      <l:template name="section" text="%n. %t" />
    </l:context>
    <l:gentext key="TableofContents" text="Contents" />
  </l:l10n>
</l:i18n>

<!-- Include chapter numbers in section numbers -->
<xsl:param name="section.label.includes.component.label">1</xsl:param>

<!-- Layout and typography -->
<xsl:param name="paper.type">A4</xsl:param>
<xsl:param name="body.start.indent">0</xsl:param>
<xsl:param name="title.font.family">Ubuntu, FreeSans, sans-serif</xsl:param>
<xsl:param name="body.font.family">serif</xsl:param>
<xsl:param name="body.font.size">10pt</xsl:param>
<xsl:param name="body.margin.inner">0</xsl:param>
<xsl:param name="monospace.font.family">Liberation Mono, Courier New, monospace</xsl:param>

<!-- Formatting for code blocks -->
<xsl:param name="shade.verbatim" select="1"/>
<xsl:attribute-set name="shade.verbatim.style">
  <xsl:attribute name="background-color">transparent</xsl:attribute>
  <xsl:attribute name="border-left-width">1em</xsl:attribute>
  <xsl:attribute name="border-left-style">solid</xsl:attribute>
  <xsl:attribute name="border-left-color">#dcdcdc</xsl:attribute>
  <xsl:attribute name="font-size">0.8em</xsl:attribute>
  <xsl:attribute name="line-height">1.4em</xsl:attribute>
  <xsl:attribute name="margin-left">0</xsl:attribute>
  <xsl:attribute name="padding-left">2em</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>

