<?xml version="1.0" encoding="UTF-8"?>
<!--
Author:  Filip Kriz (@filak), Boris Lehečka (@daliboris)
License: MIT
-->
<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 exclude-result-prefixes="xd">
 
 <xd:doc>
  <xd:desc>
   <xd:p>The version of the ALTO standard to which the input will be converted.</xd:p>
  </xd:desc>
 </xd:doc>
 <xsl:variable name="alto-version" select="4.0" />
 
 <xd:doc>
  <xd:desc>
   <xd:p>Imported XSLT stylesheet with main functionality.</xd:p>
  </xd:desc>
 </xd:doc>
 <xsl:import href="hocr__alto.xsl"/>
 
</xsl:stylesheet>