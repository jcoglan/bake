<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<!-- Start with the DocBook->FO rules from the DocBook XSL library -->
<xsl:import href="../docbook-xsl-1.78.1/fo/docbook.xsl" />
<xsl:import href="common.xsl" />

<!-- Enable extensions. Among other things, this gives the PDF a browsable
     section index. -->
<xsl:param name="fop1.extensions">1</xsl:param>

<!-- Layout and typography -->
<xsl:param name="paper.type">A4</xsl:param>
<xsl:param name="title.font.family">Ubuntu, FreeSans, sans-serif</xsl:param>

<xsl:attribute-set name="section.title.level1.properties">
  <xsl:attribute name="font-size">1.6em</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="section.title.level2.properties">
  <xsl:attribute name="font-size">1.4em</xsl:attribute>
  <xsl:attribute name="font-weight">normal</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="body.font.family">serif</xsl:param>
<xsl:param name="body.font.size">11pt</xsl:param>
<xsl:param name="body.margin.inner">0</xsl:param>
<xsl:param name="body.start.indent">0</xsl:param>

<xsl:attribute-set name="monospace.properties">
  <xsl:attribute name="font-family">Liberation Mono, Courier New, monospace</xsl:attribute>
  <xsl:attribute name="font-size">0.8em</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="monospace.verbatim.properties">
  <xsl:attribute name="font-size">0.7em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="formal.title.properties">
  <xsl:attribute name="font-size">0.8em</xsl:attribute>
  <xsl:attribute name="font-style">italic</xsl:attribute>
  <xsl:attribute name="font-weight">normal</xsl:attribute>
</xsl:attribute-set>

<!-- Formatting for code blocks -->
<xsl:param name="shade.verbatim" select="1"/>
<xsl:attribute-set name="shade.verbatim.style">
  <xsl:attribute name="background-color">transparent</xsl:attribute>
  <xsl:attribute name="border-left-width">1em</xsl:attribute>
  <xsl:attribute name="border-left-style">solid</xsl:attribute>
  <xsl:attribute name="border-left-color">#f0f0f0</xsl:attribute>
  <xsl:attribute name="line-height">1.4em</xsl:attribute>
  <xsl:attribute name="margin-left">0</xsl:attribute>
  <xsl:attribute name="padding-left">2em</xsl:attribute>
</xsl:attribute-set>

<!-- Front page templates
     See https://lists.oasis-open.org/archives/docbook-apps/201008/msg00131.html
     and https://lists.oasis-open.org/archives/docbook-apps/201309/msg00025.html -->
<xsl:template name="front.cover">
  <xsl:call-template name="page.sequence">
    <xsl:with-param name="master-reference">titlepage</xsl:with-param>
    <xsl:with-param name="content">
       <fo:block-container absolute-position="absolute"
                           width="{$page.width}"
                           height="{$page.height}"
                           top="-(1mm + {$page.margin.top} + {$body.margin.top})"
                           left="-({$page.margin.inner})">
        <fo:block text-align="center">
          <fo:external-graphic src="url(book/images/cover.jpg)" content-width="21cm"/>
        </fo:block>
      </fo:block-container>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>
<xsl:template name="book.titlepage"/>

</xsl:stylesheet>

