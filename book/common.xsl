<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!-- If the source contains a <?asciidoc-numbered?> directive, then enable
     automatic section numbering. -->
<xsl:param name="section.autolabel">
  <xsl:choose>
    <xsl:when test="/processing-instruction('asciidoc-numbered')">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:param>

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
<xsl:param name="section.autolabel.max.depth">2</xsl:param>

<!-- Disable hyphenation -->
<xsl:param name="hyphenate">false</xsl:param>

</xsl:stylesheet>
