<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 	        xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:f="https://nwalsh.com/ns/org-to-xml/functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:js="http://saxonica.com/ns/globalJS"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template match="/">
  <ixsl:schedule-action document="../html/index.html">
    <xsl:call-template name="render-main">
      <xsl:with-param name="href" select="'../html/index.html'"/>
    </xsl:call-template>
  </ixsl:schedule-action>
  <ixsl:schedule-action document="../html/toc.xml">
    <xsl:call-template name="render-sitenav">
      <xsl:with-param name="href" select="'../html/toc.xml'"/>
    </xsl:call-template>
  </ixsl:schedule-action>
</xsl:template>

<xsl:template name="render-main">
  <xsl:param name="href" as="xs:string?"/>

  <xsl:call-template name="render-page">
    <xsl:with-param name="href" select="$href"/>
  </xsl:call-template>

  <xsl:result-document href="#om_pagefooter" method="ixsl:replace-content">
    <xsl:sequence select="doc($href)/html/body
                          /nav[contains-token(@class, 'bottom')]
                          /div[contains-token(@class, 'infofooter')]"/>
  </xsl:result-document>
</xsl:template>

<xsl:template name="render-sitenav">
  <xsl:param name="href" as="xs:string?"/>

  <xsl:result-document href="#om_sitenav" method="ixsl:replace-content">
    <div class="panels">
      <div class="panel">
        <div class="toc">
          <xsl:apply-templates select="doc($href)/div/*"
                               mode="toc"/>
        </div>
      </div>
      <div class="panel">Second panel</div>
    </div>
  </xsl:result-document>
</xsl:template>

<xsl:template name="render-page">
  <xsl:param name="href" as="xs:string"/>
  <xsl:param name="fragid" as="xs:string?" select="()"/>
  <xsl:param name="id" as="xs:string?" select="()"/>

  <xsl:result-document href="#om_main" method="ixsl:replace-content">
    <xsl:sequence select="doc($href)/html/body/main/*/node()"/>
  </xsl:result-document>

  <xsl:result-document href="#om_pagenav" method="ixsl:replace-content">
    <xsl:variable name="body" select="doc($href)/html/body/main/div"/>
    <xsl:if test="$body/h:section">
      <div class="toc">
        <ul class="toc">
          <xsl:apply-templates select="$body/h:section" mode="pagenav"/>
        </ul>
      </div>
    </xsl:if>
  </xsl:result-document>

  <xsl:result-document href="#om_footer" method="ixsl:replace-content">
    <xsl:sequence select="doc($href)/html/body
                          /nav[contains-token(@class, 'bottom')]
                          /div[contains-token(@class, 'navrow')]"/>
  </xsl:result-document>

  <xsl:if test="$id">
    <xsl:apply-templates select="doc('../html/toc.xml')" mode="breadcrumbs">
      <xsl:with-param name="id" select="if (contains($id, '#'))
                                        then substring-before($id, '#')
                                        else $id"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="toc">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()" mode="toc"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="h:ul" mode="toc">
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="toc"/>
    <xsl:attribute name="class"
                   select="if (parent::h:li/parent::h:ul)
                           then 'toc-hidden'
                           else 'toc-revealed'"/>
    <xsl:apply-templates select="node()" mode="toc"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="h:li" mode="toc">
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="toc"/>
    <xsl:choose>
      <xsl:when test="h:ul">
        <span class="toc-arrow toc-closed">⏵</span>
      </xsl:when>
      <xsl:otherwise>
        <span class="toc-arrow"></span>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="node()" mode="toc"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|comment()|text()|processing-instruction()"
              mode="toc">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="pagenav">
  <xsl:apply-templates select="*" mode="pagenav"/>
</xsl:template>

<xsl:template match="h:section" mode="pagenav">
  <li>
    <a href="#{@id}">
      <xsl:sequence
          select="string((h:header/h:h2|h:header/h:h3|h:header/h:h4|h:header/h:h5)[1])"/>
    </a>
    <xsl:if test="h:section">
      <ul class="toc">
        <xsl:apply-templates select="h:section" mode="pagenav"/>
      </ul>
    </xsl:if>
  </li>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="/" mode="breadcrumbs">
  <xsl:param name="id" as="xs:string"/>

  <xsl:variable name="li" select="//h:li[a[@href=$id]]"/>

  <xsl:result-document href="#om_toolbar" method="ixsl:replace-content">
    <div class="breadcrumbs" aria-label="breadcrumbs">
      <ul>
        <li><a href="index.html">Home</a></li>
        <xsl:for-each select="($li/ancestor::h:li)">
          <li>
            <xsl:sequence select="h:a"/>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:result-document>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="h:span[contains-token(@class, 'toc-arrow')]"
              mode="ixsl:onclick">
  <xsl:choose>
    <xsl:when test="contains-token(@class, 'toc-closed')">
      <xsl:result-document href="?." method="ixsl:replace-content">
        <xsl:text>⏷</xsl:text>
      </xsl:result-document>
      <ixsl:set-attribute name="class"
                          select="'toc-arrow toc-open'"
                          object="."/>
      <ixsl:set-attribute name="class"
                          select="'toc-revealed'"
                          object="../h:ul"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:result-document href="?." method="ixsl:replace-content">
        <xsl:text>⏵</xsl:text>
      </xsl:result-document>
      <ixsl:set-attribute name="class"
                          select="'toc-arrow toc-closed'"
                          object="."/>
      <ixsl:set-attribute name="class"
                          select="'toc-hidden'"
                          object="../h:ul"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="h:aside[@id='om_sitenav']//a[@href]
                     |h:div[@id='om_toolbar']//a[@href]"
              mode="ixsl:onclick">
  <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>

  <xsl:variable name="uri" select="if (contains(@href, '#'))
                                   then substring-before(@href, '#')
                                   else @href/string()"/>
  <xsl:variable name="fragid" select="if (contains(@href, '#'))
                                      then substring-after(@href, '#')
                                      else ()"/>


  <ixsl:schedule-action document="../html/{$uri}">
    <xsl:call-template name="render-page">
      <xsl:with-param name="href" select="'../html/' || $uri"/>
      <xsl:with-param name="fragid" select="$fragid"/>
      <xsl:with-param name="id" select="@href"/>
    </xsl:call-template>
  </ixsl:schedule-action>
</xsl:template>

</xsl:stylesheet>
