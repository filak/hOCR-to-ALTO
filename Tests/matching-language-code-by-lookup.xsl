<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 exclude-result-prefixes="xs math xd"
 version="3.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Apr 3, 2023</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 
 <xsl:param name="language" select="'unknown'" />
 <xsl:param name="teslang" select="'notset'" />
 
 <xsl:param name="lang-attribute-name" select="'LANG'"/>
 
 <xsl:variable name="langcodes" select="document('../codes_lookup.xml')/*:codes/*:code" />

 <xsl:template match="/*">
  <xsl:copy>
   <xsl:attribute name="language" select="$language" />
   <xsl:attribute name="teslang" select="$teslang" />
   <xsl:attribute name="lang-attribute-name" select="$lang-attribute-name" />
   <xsl:apply-templates />
  </xsl:copy>
 </xsl:template>
 
 
 <xsl:template match="language">
  <language>
   <xsl:choose>
    
    <xsl:when test="@lang != ''">
     <xsl:variable name="lookup" select="@lang" />
     <xsl:attribute name="{$lang-attribute-name}">
      <xsl:choose>
       <xsl:when test="$langcodes[@a3h=$lookup]/@a2!=''">
        <xsl:value-of select="$langcodes[@a3h=$lookup]/@a2" />
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select="@lang" />
       </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
    </xsl:when>
    
    <xsl:when test="$language != 'unknown'">
     <xsl:attribute name="{$lang-attribute-name}">
      <xsl:value-of select="$language" />
     </xsl:attribute>
    </xsl:when>
    
    <xsl:when test="$teslang != 'notset'">
     <xsl:variable name="lookup" select="$teslang" />
     <xsl:attribute name="{$lang-attribute-name}">
      <xsl:value-of select="$langcodes[@a3h=$lookup]/@a2" />
     </xsl:attribute>
    </xsl:when>
    
   </xsl:choose>
  </language>
 </xsl:template>
 
</xsl:stylesheet>