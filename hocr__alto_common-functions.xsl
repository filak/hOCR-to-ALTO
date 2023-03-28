<?xml version="1.0" encoding="UTF-8"?>
<!--
Author:  Filip Kriz (@filak)
License: MIT
-->
<xsl:stylesheet version="2.0" 
    xmlns="http://www.loc.gov/standards/alto/ns-v2#" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:mf="http://myfunctions" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="*" 
    exclude-result-prefixes="mf">


 <xsl:function name="mf:getFname">
    <xsl:param name="titleString"/>
    <xsl:variable name="pPat">"</xsl:variable>
    <xsl:variable name="fpath" select="substring-after(tokenize(normalize-space($titleString),'; ')[1],'image &quot;')"/>
    <xsl:value-of select="reverse(tokenize(replace($fpath,$pPat,''),'\\'))[1]"/>
</xsl:function>


<xsl:function name="mf:getBoxPage">
    <xsl:param name="titleString"/>
    <xsl:value-of select="tokenize(normalize-space($titleString),'; ')[2]"/>
</xsl:function>


<xsl:function name="mf:getBox">
    <xsl:param name="titleString"/>
    <xsl:value-of select="tokenize(normalize-space($titleString),'; ')"/>
</xsl:function>


<xsl:function name="mf:getConfidence">
    <xsl:param name="titleString"/>
    <xsl:variable name="wconfString" select="tokenize(normalize-space($titleString),'; ')[2]" />
    
    <xsl:choose>
      <xsl:when test="$wconfString != ''">
        <xsl:variable name="wconf" as="xs:float" select="replace($wconfString, 'x_wconf ','') cast as xs:float"/>
        <xsl:value-of select="$wconf div 100"></xsl:value-of>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
    
</xsl:function>
</xsl:stylesheet>