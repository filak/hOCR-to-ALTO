<?xml version="1.0" encoding="UTF-8"?>
<!--
Author:  Filip Kriz (@filak)
Version: 1.3.3   22-06-2018
License: MIT License (MIT)
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

  <xsl:output method="xml" encoding="utf-8" indent="no" />
  <xsl:strip-space elements="*"/>
  <!--   Optional - default language:   ISO 639-2/B 3-letter code (language) OR  Tesseract code (teslang)   -->
  <xsl:param name="language" select="'unknown'" />
  <xsl:param name="teslang" select="'notset'" />
  <xsl:variable name="langcodes" select="document('codes_lookup.xml')/*:codes/*:code" />

  <xsl:template match="/">
        <alto xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v2# http://www.loc.gov/standards/alto/alto.xsd">
            <xsl:apply-templates/>
        </alto>
  </xsl:template>
 
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
                    <softwareVersion><xsl:value-of select="*:meta[@name='ocr-system']/@content"/></softwareVersion>
                </processingSoftware>
            </ocrProcessingStep>
            </OCRProcessing>
        </Description>
  </xsl:template>
  

  <xsl:template match="*:body[*:div[@class='ocr_page']]">
        <Layout>
            <xsl:apply-templates select="*:div[@class='ocr_page']"/>
        </Layout>
  </xsl:template>
  <xsl:template match="*:div[@class='ocr_page']">
        <!--  bbox 552 999 1724 1141 x1-L2-T3-R4-B5 -->
        <xsl:variable name="box" select="tokenize(mf:getBoxPage(@title), ' ')"/>
        <Page ID="{@id}" PHYSICAL_IMG_NR="1" HEIGHT="{$box[5]}" WIDTH="{$box[4]}">
            <PrintSpace HEIGHT="{$box[5]}" WIDTH="{$box[4]}" VPOS="0" HPOS="0">

                <xsl:apply-templates select="*:div[@class='ocr_carea']"/>

            </PrintSpace>
        </Page>
  </xsl:template>
  
  
  <xsl:template match="*:div[@class='ocr_carea']">
      <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
      <ComposedBlock ID="{@id}" HEIGHT="{number($box[5]) - number($box[3])}" WIDTH="{number($box[4]) - number($box[2])}" VPOS="{$box[3]}" HPOS="{$box[2]}">
      
          <xsl:apply-templates select="*:p[@class='ocr_par']"/>

      </ComposedBlock>
  </xsl:template>
 
 
  <xsl:template match="*:p[@class='ocr_par']">
      <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
      <TextBlock ID="{@id}" HEIGHT="{number($box[5]) - number($box[3])}" WIDTH="{number($box[4]) - number($box[2])}" VPOS="{$box[3]}" HPOS="{$box[2]}">

          <xsl:choose>
          
              <xsl:when test="@lang != ''">
                  <xsl:variable name="lookup" select="@lang" />
                  <xsl:attribute name="LANG">
                      <xsl:value-of select="$langcodes[@a2=$lookup]/@a3b" />
                  </xsl:attribute>
              </xsl:when>
              
              <xsl:when test="$language != 'unknown'">
                  <xsl:attribute name="LANG">
                      <xsl:value-of select="$language" />
                  </xsl:attribute>
              </xsl:when>

              <xsl:when test="$teslang != 'notset'">
                  <xsl:attribute name="LANG">
                      <xsl:value-of select="$langcodes[@a3h=$teslang]/@a3b" />
                  </xsl:attribute>
              </xsl:when>

          </xsl:choose>
      
          <xsl:apply-templates select="*:span[@class='ocr_line']"/>
      
      </TextBlock>
  </xsl:template>
 
 
  <xsl:template match="*:span[@class='ocr_line']">
      <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
      <TextLine ID="{@id}" HEIGHT="{number($box[5]) - number($box[3])}" WIDTH="{number($box[4]) - number($box[2])}" VPOS="{$box[3]}" HPOS="{$box[2]}">
      
          <xsl:apply-templates select="*:span[@class='ocrx_word']"/>
      
      </TextLine>
  </xsl:template>


  <xsl:template match="*:span[@class='ocrx_word']">
      <xsl:variable name="box" select="tokenize(mf:getBox(@title), ' ')"/>
      <xsl:variable name="wc" select="mf:getConfidence(@title)"/>
        <xsl:choose>
          <xsl:when test="*:strong">
             <String ID="{@id}" CONTENT="{normalize-space(.)}" HEIGHT="{number($box[5]) - number($box[3])}" WIDTH="{number($box[4]) - number($box[2])}" VPOS="{$box[3]}" HPOS="{$box[2]}" WC="{$wc}" STYLE="bold"/>
          </xsl:when>
          <xsl:when test="*:em">
              <String ID="{@id}" CONTENT="{normalize-space(.)}" HEIGHT="{number($box[5]) - number($box[3])}" WIDTH="{number($box[4]) - number($box[2])}" VPOS="{$box[3]}" HPOS="{$box[2]}" WC="{$wc}" STYLE="italics"/>
          </xsl:when>
          <xsl:when test="*:i">
              <String ID="{@id}" CONTENT="{normalize-space(.)}" HEIGHT="{number($box[5]) - number($box[3])}" WIDTH="{number($box[4]) - number($box[2])}" VPOS="{$box[3]}" HPOS="{$box[2]}" WC="{$wc}" STYLE="italics"/>
          </xsl:when>
          <xsl:otherwise>
              <String ID="{@id}" CONTENT="{normalize-space(.)}" HEIGHT="{number($box[5]) - number($box[3])}" WIDTH="{number($box[4]) - number($box[2])}" VPOS="{$box[3]}" HPOS="{$box[2]}" WC="{$wc}" />
          </xsl:otherwise>
        </xsl:choose>
  </xsl:template>

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
    <xsl:variable name="confString" as="xs:integer" select="replace($titleString, '.* x_wconf (\d+)','$1') cast as xs:integer"/>
    <xsl:value-of select="$confString div 100"></xsl:value-of>
</xsl:function>
  
</xsl:stylesheet>
