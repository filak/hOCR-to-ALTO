<?xml version="1.0" encoding="UTF-8"?>
<!--
Author:  Filip Kriz (@filak), Boris Lehečka (@daliboris)
License: MIT
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:a20="http://www.loc.gov/standards/alto/ns-v2#"
 xmlns:a21="http://www.loc.gov/standards/alto/ns-v2#"
 xmlns:a3="http://www.loc.gov/standards/alto/ns-v3#"
 xmlns:a4="http://www.loc.gov/standards/alto/ns-v4#" 
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:dlb="http://www.daliboris.cz/ns/xslt/"
 xmlns:mf="http://myfunctions"
 exclude-result-prefixes="xd xs mf a20 a21 a3 a4"
 version="2.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Apr 3, 2023</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris Lehečka</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:output method="xml" encoding="utf-8" indent="yes" />
 <xsl:strip-space elements="*"/>

 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:b>Optional param:</xd:b> 
    the version of the ALTO standard to which the input will be converted.
   </xd:p>
   <xd:p>It can be either of the following values:</xd:p>
   <xd:ul>
    <xd:li>2</xd:li>
    <xd:li>2.0</xd:li>
    <xd:li>2.1</xd:li>
    <xd:li>3</xd:li>
    <xd:li>3.0</xd:li>
    <xd:li>4</xd:li>
    <xd:li>4.0</xd:li>
   </xd:ul>
   <xd:p>Default value is <xd:b>4.0</xd:b>.</xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:param name="alto-version" select="4.0" as="xs:double" />
 
 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:b>Optional param:</xd:b> 
    default language code (param:  language), can be 2-letter or 3-letter.
   </xd:p>
  </xd:desc>
 </xd:doc>
 <xsl:param name="language" select="'unknown'" as="xs:string" />

 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:b>Optional param:</xd:b> 
    Tesseract language code, 3-letter.
   </xd:p>
  </xd:desc>
 </xd:doc>
 <xsl:param name="teslang" select="'notset'"  as="xs:string" />
 
 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:b>Internal variable:</xd:b> 
    a name of the language attribute in ALTO: <xd:i>language</xd:i> for version 2.0, <xd:i>LANG</xd:i> for version 2.1 and higher.
   </xd:p>
  </xd:desc>
 </xd:doc>
 <xsl:variable name="lang-attribute-name" select="if($alto-version eq 2.0) then 'language' else 'LANG'"/>
 
 <xd:doc>
  <xd:desc>
   <xd:p>
     <xd:b>Internal variable:</xd:b> 
    a document with language codes used to convert between three-letter and two-letter codes.
   </xd:p>
  </xd:desc>
 </xd:doc>
 <xsl:variable name="language-codes-lookup" select="document('codes_lookup.xml')"/>
 
 <xd:doc>
  <xd:desc>
   <xd:p>Looking for code element with non empty <xd:i>@a2</xd:i> attribute using value of <xd:i>@a3h</xd:i> attribute.</xd:p>
  </xd:desc>
 </xd:doc>
 <xsl:key name="language-code" match="code[@a2!='']" use="@a3h" />
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="/">
  <xsl:choose>
   <xsl:when test="$alto-version = 2.0">
    <alto xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v2# https://www.loc.gov/standards/alto/v2/alto-2-0.xsd">
     <xsl:apply-templates/>
    </alto>    
   </xsl:when>
   <xsl:when test="$alto-version = 2.1">
    <alto xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v2# https://www.loc.gov/standards/alto/alto-2.xsd">
     <xsl:apply-templates/>
    </alto>
   </xsl:when>
   <xsl:when test="$alto-version = 3.0">
    <alto xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v3# https://www.loc.gov/standards/alto/v3/alto.xsd">
     <xsl:apply-templates/>
    </alto>   
   </xsl:when>
   <xsl:when test="$alto-version = 4.0">
    <alto xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v4# https://www.loc.gov/standards/alto/v4/alto.xsd">
     <xsl:apply-templates/>
    </alto>  
   </xsl:when>
  </xsl:choose>
 </xsl:template>
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:head">
  <Description>
   <MeasurementUnit>pixel</MeasurementUnit>
   <sourceImageInformation>
    <xsl:variable name="title" select="//*:body/*:div[@class='ocr_page'][1]/@title"/>
    <fileName><xsl:value-of select="mf:getFname($title)"/></fileName>
   </sourceImageInformation>
   <OCRProcessing ID="IdOcr">
    <ocrProcessingStep>
     <processingSoftware>
      <softwareName><xsl:value-of select="*:meta[@name='ocr-system']/@content"/></softwareName>
     </processingSoftware>
    </ocrProcessingStep>
   </OCRProcessing>
  </Description>
 </xsl:template>
 
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:body[*:div[@class='ocr_page']]">
  <Layout>
   <xsl:apply-templates select="*:div[@class='ocr_page']"/>
  </Layout>
 </xsl:template>
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:div[@class='ocr_page']">
  
  <xsl:variable name="properties">
   <xsl:call-template name="get-hocr-properties" />
  </xsl:variable>
  
  <xsl:variable name="id" select="if (@id) then @id else generate-id()"/>
  <xsl:variable name="img-nr" select="if($properties/dlb:property[@name='ppageno']) then $properties/dlb:property[@name='ppageno']/dlb:item/@value else 1"/>
  <!--  bbox 552 999 1724 1141 x1-L2-T3-R4-B5 -->
  <xsl:variable name="box" select="tokenize(mf:getBoxPage(@title), ' ')"/>
  <Page ID="{$id}" PHYSICAL_IMG_NR="{$img-nr}" HEIGHT="{$box[5]}" WIDTH="{$box[4]}">
   
   <xsl:apply-templates select="*:div[@class='ocr_header']"/>
   
   <PrintSpace HEIGHT="{$box[5]}" WIDTH="{$box[4]}" VPOS="0" HPOS="0">
    <xsl:apply-templates select="*:div[@class=('ocr_carea', 'ocrx_block')] | *:p[@class=('ocr_par')]"/>
   </PrintSpace>
   
   <xsl:apply-templates select="*:div[@class='ocr_footer']"/>
  </Page>
 </xsl:template>
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:div[@class='ocrx_block']">
  <xsl:apply-templates select="*:p[@class='ocr_par']"/>
 </xsl:template>
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:div[@class='ocr_header']">
  
  <xsl:variable name="properties">
   <xsl:call-template name="get-hocr-properties" />
  </xsl:variable>
  
  <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
  
  <TopMargin ID="{@id}">
   
   <xsl:call-template name="add-position-attributes">
    <xsl:with-param name="box" select="$box" />
   </xsl:call-template>
   <xsl:apply-templates/>
   
  </TopMargin>
  
 </xsl:template>
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:div[@class='ocr_footer']">
  <xsl:variable name="id" select="if (@id) then @id else generate-id()"/>
  <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
  
  <BottomMargin ID="{$id}">
   
   <xsl:call-template name="add-position-attributes">
    <xsl:with-param name="box" select="$box" />
   </xsl:call-template>    
   
   <xsl:apply-templates/>
   
  </BottomMargin>
 </xsl:template>
 
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:div[@class='ocr_carea']">
  <xsl:variable name="id" select="if (@id) then @id else generate-id()"/>
  <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
  <ComposedBlock ID="{$id}">
   
   <xsl:call-template name="add-position-attributes">
    <xsl:with-param name="box" select="$box" />
   </xsl:call-template>
   
   <xsl:apply-templates/>
   
  </ComposedBlock>
 </xsl:template>
 
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:p[@class='ocr_par']">
  <xsl:variable name="id" select="if (@id) then @id else generate-id()"/>
  <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
  <TextBlock ID="{$id}">
   
   
   <xsl:call-template name="add-position-attributes">
    <xsl:with-param name="box" select="$box" />
   </xsl:call-template>    
   
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
   <xsl:variable name="language-value" select="(
    if(@lang) then (key('language-code', @lang, $language-codes-lookup)/@a2, @lang)[1] else (),
    if($language = 'unknown') then () else (key('language-code', $language, $language-codes-lookup)/@a2, $language)[1],
    if($teslang = 'notset') then () else key('language-code', $teslang, $language-codes-lookup)/@a2
    )[1]"
   />
   
   <!-- if value for language exists, attribute value is set -->
   <xsl:if test="$language-value">
    <!-- creating attribute with name reflecting ALTO version (@language for version 2, @LANG for higher versions) -->
    <xsl:attribute name="{$lang-attribute-name}" select="$language-value" />
   </xsl:if>
   
   <xsl:apply-templates/>
   
  </TextBlock>
 </xsl:template>
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:span[@class='ocr_line']">
  <xsl:variable name="id" select="if (@id) then @id else generate-id()"/>
  <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
  <TextLine ID="{$id}">
   
   
   <xsl:call-template name="add-position-attributes">
    <xsl:with-param name="box" select="$box" />
   </xsl:call-template>    
   
   <xsl:choose>
    <xsl:when test="*:span[@class='ocrx_word']">
     <xsl:apply-templates select="*:span[@class='ocrx_word']"/>
    </xsl:when>
    <xsl:otherwise>
     <String CONTENT="{normalize-space(.)}"/>
    </xsl:otherwise>
   </xsl:choose>
   
  </TextLine>
 </xsl:template>
 
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template match="*:span[@class='ocrx_word']">
  <xsl:variable name="id" select="if (@id) then @id else generate-id()"/>
  <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
  <xsl:variable name="wc" select="mf:getConfidence(@title)"/>
  <xsl:choose>
   <xsl:when test="*:strong">
    <String ID="{$id}" CONTENT="{normalize-space(.)}"  WC="{$wc}" STYLE="bold">
     <xsl:call-template name="add-position-attributes">
      <xsl:with-param name="box" select="$box" />
     </xsl:call-template>
    </String>
   </xsl:when>
   <xsl:when test="*:em">
    <String ID="{$id}" CONTENT="{normalize-space(.)}" WC="{$wc}" STYLE="italics">
     <xsl:call-template name="add-position-attributes">
      <xsl:with-param name="box" select="$box" />
     </xsl:call-template>
    </String>
   </xsl:when>
   <xsl:when test="*:i">
    <String ID="{$id}" CONTENT="{normalize-space(.)}" WC="{$wc}" STYLE="italics">
     <xsl:call-template name="add-position-attributes">
      <xsl:with-param name="box" select="$box" />
     </xsl:call-template>
    </String>
   </xsl:when>
   <xsl:otherwise>
    <String ID="{$id}" CONTENT="{normalize-space(.)}" WC="{$wc}">
     <xsl:call-template name="add-position-attributes">
      <xsl:with-param name="box" select="$box" />
     </xsl:call-template>
    </String>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 
 
 <xd:doc>
  <xd:desc/>
  <xd:param name="titleString"/>
 </xd:doc>
 <xsl:function name="mf:getFname">
  <xsl:param name="titleString"/>
  <xsl:variable name="pPat">"</xsl:variable>
  <xsl:variable name="fpath" select="substring-after(tokenize(normalize-space($titleString),'; ')[1],'image &quot;')"/>
  <xsl:value-of select="reverse(tokenize(replace($fpath,$pPat,''),'\\'))[1]"/>
 </xsl:function>
 
 
 <xd:doc>
  <xd:desc/>
  <xd:param name="titleString"/>
 </xd:doc>
 <xsl:function name="mf:getBoxPage">
  <xsl:param name="titleString"/>
  <!--<xsl:value-of select="tokenize(normalize-space($titleString),'; ')[2]"/>-->
  <xsl:value-of select="tokenize(normalize-space($titleString),'; ')[contains(., 'bbox')]"/>
 </xsl:function>
 
 
 <xd:doc>
  <xd:desc/>
  <xd:param name="titleString"/>
 </xd:doc>
 <xsl:function name="mf:getBox">
  <xsl:param name="titleString"/>
  <xsl:value-of select="tokenize(normalize-space($titleString),'; ')"/>
 </xsl:function>
 
 
 <xd:doc>
  <xd:desc/>
  <xd:param name="titleString"/>
 </xd:doc>
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
 
 
 <xd:doc>
  <xd:desc/>
  <xd:param name="box"/>
 </xd:doc>
 <xsl:template name="add-position-attributes">
  <xsl:param name="box"/>
  <xsl:attribute name="HEIGHT" select="number($box[5]) - number($box[3])" />
  <xsl:attribute name="WIDTH" select="number($box[4]) - number($box[2])" />
  <xsl:attribute name="VPOS" select="$box[3]" />
  <xsl:attribute name="HPOS" select="$box[2]" />
 </xsl:template>
 
 <xd:doc>
  <xd:desc/>
 </xd:doc>
 <xsl:template name="get-hocr-properties">
  <xsl:variable name="title" select="@title"/>
  <xsl:variable name="items" select="tokenize(@title, ';')"/>
  <xsl:for-each select="$items">
   <xsl:variable name="properties" select="tokenize(normalize-space(.))"/>
   <dlb:property name="{$properties[1]}">
    <xsl:for-each select="$properties[position() > 1]">
     <dlb:item value="{.}">
      <xsl:call-template name="get-value-name">
       <xsl:with-param name="property" select="$properties[1]" />
       <xsl:with-param name="position" select="position()" />
      </xsl:call-template>      
     </dlb:item>
    </xsl:for-each>
   </dlb:property>
  </xsl:for-each>
 </xsl:template>
 
 <xd:doc>
  <xd:desc/>
  <xd:param name="property"/>
  <xd:param name="position"/>
 </xd:doc>
 <xsl:template name="get-value-name">
  <xsl:param name="property"/>
  <xsl:param name="position"/>
  <xsl:variable name="attribute-name">
   <xsl:choose>
    <xsl:when test="$property = 'bbox'">
     <xsl:choose>
      <xsl:when test="position() = 1"><xsl:value-of select="'left'"/></xsl:when>
      <xsl:when test="position() = 2"><xsl:value-of select="'top'"/></xsl:when>
      <xsl:when test="position() = 3"><xsl:value-of select="'right'"/></xsl:when>
      <xsl:when test="position() = 4"><xsl:value-of select="'bottom'"/></xsl:when>
     </xsl:choose>
    </xsl:when>
   </xsl:choose>
  </xsl:variable>
  
  <xsl:if test="$attribute-name != ''">
   <xsl:attribute name="name" select="$attribute-name">
   </xsl:attribute>
  </xsl:if>
 </xsl:template>
 
</xsl:stylesheet>