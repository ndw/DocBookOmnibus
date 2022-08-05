<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:ext="http://docbook.org/extensions/xslt"
                xmlns:f="http://docbook.org/ns/docbook/functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/ns/docbook/modes"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:mp="http://docbook.org/ns/docbook/modes/private"
                xmlns:t="http://docbook.org/ns/docbook/templates"
                xmlns:tp="http://docbook.org/ns/docbook/templates/private"
                xmlns:v="http://docbook.org/ns/docbook/variables"
                xmlns:vp="http://docbook.org/ns/docbook/variables/private"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="db ext f h m map mp t tp v vp xs"
                version="3.0">

<xsl:import href="https://cdn.docbook.org/release/xsltng/current/xslt/docbook.xsl"/>

<xsl:variable name="v:debug" select="('intra-chunk-hrefs')"/>

<xsl:param name="refentry.generate.name" select="false()"/>
<xsl:param name="refentry.generate.title" select="true()"/>
<xsl:param name="dynamic-profiles" as="xs:string" select="'true'"/>

<xsl:param name="funcsynopsis-default-style" select="'ansi'"/>
<xsl:param name="funcsynopsis-trailing-punctuation" select="''"/>
<xsl:param name="funcsynopsis-table-threshold" select="0"/>

<xsl:param name="chunk-exclude"
           select="('self::db:partintro',
                    'self::*[ancestor::db:partintro]',
                    'self::db:section')"/>

<xsl:param name="component-numbers-inherit" select="true()"/>

<xsl:param name="section-toc-depth" select="1"/>
<xsl:param name="footnote-numeration" select="('*', '**', '†','‡', '§', '1')"/>

<xsl:param name="refentry-generate-name" select="false()"/>
<xsl:param name="chunk-nav" select="'true'"/>
<xsl:param name="persistent-toc" select="'false'"/>

<xsl:param name="generate-toc" as="xs:string">
  self::db:book
</xsl:param>

<xsl:template name="t:chunk-cleanup" as="document-node()">
  <xsl:param name="source" as="document-node()" select="."/>
  <xsl:param name="docbook" as="document-node()" required="yes"/>

  <xsl:document>
    <xsl:apply-templates select="$source" mode="m:chunk-cleanup">
      <xsl:with-param name="docbook" select="$docbook" tunnel="yes"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="($source/h:html/h:div[@db-chunk])[1]"
                         mode="generate-toc">
      <xsl:with-param name="source" select="$source"/>
      <xsl:with-param name="docbook" select="$docbook"/>
    </xsl:apply-templates>
  </xsl:document>
</xsl:template>

<xsl:template match="h:div" mode="generate-toc">
  <xsl:param name="source" as="document-node()" required="yes"/>
  <xsl:param name="docbook" as="document-node()" required="yes"/>

  <script type="application/xml" id="om_toc">
    <div>
      <xsl:variable name="list-of-titles"
                    select="($source//h:div[contains-token(@class, 'list-of-titles')])[1]"/>
      <xsl:apply-templates
          select="$list-of-titles/h:div[contains-token(@class, 'toc')]/h:ul"
          mode="mp:copy-patch-toc">
        <!-- source must be a descendant of a chunk div -->
        <xsl:with-param name="source" select="(./*)[1]"/>
        <xsl:with-param name="prefix" select="''"/>
      </xsl:apply-templates>
    </div>
  </script>
</xsl:template>

<xsl:template match="/" as="map(xs:string, item()*)" mode="m:chunk-output">
  <xsl:map>
    <xsl:next-match/>
    <xsl:map-entry key="'toc.xml'">
      <xsl:sequence select="/h:script/node()"/>
    </xsl:map-entry>
  </xsl:map>
</xsl:template>

</xsl:stylesheet>
