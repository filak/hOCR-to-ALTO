<?xml version="1.1" encoding="UTF-8"?>
<!--
Author:  konstantin baierer
License: MIT
-->
<xsl:stylesheet version="2.0" 
    xmlns="http://www.loc.gov/standards/alto/ns-v4#" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="utf-8" indent="no" />
  <xsl:strip-space elements="*"/>
  <xsl:param name="ansi" select="'no'"/>

  <xsl:template name='ansi'>
      <xsl:param name="sgr"/>
      <xsl:if test="$ansi = 'yes'">
          <xsl:text>&#x1b;</xsl:text>
          <xsl:value-of select="$sgr"/>
      </xsl:if>
  </xsl:template>

  <xsl:template match="/">
      <xsl:apply-templates select="//*[local-name()='Page']"/>
  </xsl:template>
 
  <xsl:template match="*[local-name()='Page']">
      <xsl:apply-templates select=".//*[local-name()='TextLine']"/>
      <xsl:text>&#x0c;</xsl:text>
  </xsl:template>

  <xsl:template match="*[local-name()='TextLine']">
      <xsl:apply-templates select="*"/>
      <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template match="*[local-name()='SP']">
      <xsl:text>&#x20;</xsl:text>
  </xsl:template>

  <xsl:template match="*[local-name()='HYP']">
      <xsl:text>-</xsl:text>
  </xsl:template>

  <xsl:template match="*[local-name()='String']">
      <!-- <xsl:choose> -->
      <!--     <xsl:when test="local-name() = 'strong'"> -->
      <!--         <xsl:call-template name='ansi'><xsl:with-param name='sgr'>1m</xsl:with-param></xsl:call-template> -->
      <!--     </xsl:when> -->
      <!--     <xsl:when test="local-name() = 'em'"> -->
      <!--         <xsl:call-template name='ansi'><xsl:with-param name='sgr'>3m</xsl:with-param></xsl:call-template> -->
      <!--     </xsl:when> -->
      <!-- </xsl:choose> -->
      <xsl:value-of select="@CONTENT"/>
      <xsl:call-template name='ansi'><xsl:with-param name='sgr'>0m</xsl:with-param></xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
