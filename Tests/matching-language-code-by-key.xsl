<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 exclude-result-prefixes="xs math xd"
 version="2.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Apr 3, 2023</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <!-- 
  Optional param:
       - default language code (param:  language), can be 2 or 3 letters
  -->
 <xsl:param name="language" select="'unknown'" />
 <!--
   Optional param:
        - Tesseract language code (param:  teslang), 3 letters
 -->
 <xsl:param name="teslang" select="'notset'" />
 
 <!--
   Optional param:
         - name of the language attribute in the ALTO:
          language for version 2.0, LANG for versions 2.1 and higher
  -->
 <xsl:param name="lang-attribute-name" select="'LANG'"/>

 <xd:doc>
  <xd:desc>Lookup document with language codes; used by <xd:i>key</xd:i> function.</xd:desc>
 </xd:doc>
 <xsl:variable name="language-codes-lookup" select="document('../codes_lookup.xml')"/>
 

 
 <xd:doc>
  <xd:desc>Looking for code element with non empty @a2 attribute using value of @a3h attribute.</xd:desc>
 </xd:doc>
 <xsl:key name="language-code" match="code[@a2!='']" use="@a3h" />
 
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
   
   <!-- 
      Looking for language code in the lookup table (ie. codes_lookup.xml document).
      Only first matched value from different lookups will be used.
      
      If the @lang attribute exists, it's value is searched in the lookup file: 
      if no language code is found, the value of the @lang attribute itself is used.
      
      If the $language parameter is set, it's value is searched in the lookup file:
      if no language code is found, the value of $language parameter itself is used.
      
      If the $teslang parameter is set, it's value is searched in the lookup file:
      if no language code is found, the value of new parameter is not set.
      
      If there are more results of the lookups only first match is used with this precedens:
      1) found value for the @lang parameter
      2) @lang
      3) $language
      4) $teslang
    -->
   <xsl:variable name="language" select="(
    if(@lang) then (key('language-code', @lang, $language-codes-lookup)/@a2, @lang)[1] else (),
    if($language = 'unknown') then () else (key('language-code', $language, $language-codes-lookup)/@a2, $language)[1],
    if($teslang = 'notset') then () else key('language-code', $teslang, $language-codes-lookup)/@a2
    )[1]"
   />
   
   <!-- if value for language exists, attribute value is set -->
   <xsl:if test="$language">
    <!-- creating attribute with name reflecting ALTO version (@language for version 2, @LANG for higher versions) -->
    <xsl:attribute name="{$lang-attribute-name}" select="$language" />
   </xsl:if>
   
  </language>
 </xsl:template>
 
</xsl:stylesheet>