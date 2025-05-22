<?xml version="1.0" encoding="UTF-8"?>
<!--
Author:  Filip Kriz (@filak)
License: MIT
Version: 1.2 2025-05-22
Changes:
Version 1.1
- add recursion to the *:ComposedBlock template - apply-templates select="*:TextBlock|*:ComposedBlock"
Version 1.2
- making mf:getBox robust to handle empty/missing input params (https://github.com/filak/hOCR-to-ALTO/issues/31)
- functions now return sequence instead of value-of
- style caching
-->
<xsl:stylesheet version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mf="http://myfunctions"
    exclude-result-prefixes="#all">

  <xsl:output method="xml" encoding="utf-8"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <!-- Default language code - fallback value -->
  <xsl:param name="language" select="'unknown'" />

  <!-- Cache text styles -->
  <xsl:variable name="styles" select="//*:alto/*:Styles/*:TextStyle" as="element()*"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$language != 'unknown'">
        <html xml:lang="{$language}" lang="{$language}">
          <xsl:apply-templates/>
        </html>
      </xsl:when>
      <xsl:otherwise>
        <html>
          <xsl:apply-templates/>
        </html>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*:Description">
    <head>
      <title>Image: <xsl:apply-templates select="*:sourceImageInformation"/></title>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <xsl:apply-templates select="*:OCRProcessing/*:ocrProcessingStep"/>
      <meta name="ocr-capabilities" content="ocr_page ocr_header ocr_footer ocr_carea ocr_par ocr_line ocrx_word"/>
    </head>
  </xsl:template>

  <xsl:template match="*:sourceImageInformation">
    <xsl:value-of select="*:fileName"/>
  </xsl:template>

  <xsl:template match="*:OCRProcessing/*:ocrProcessingStep|*:Processing/*:processingStep">
    <meta name="ocr-system" content="{*:processingSoftware/*:softwareName} {*:processingSoftware/*:softwareVersion}"/>
  </xsl:template>

  <xsl:template match="*:Styles"/>

  <xsl:template match="*:Layout">
    <body>
      <xsl:apply-templates select="*:Page"/>
    </body>
  </xsl:template>

  <xsl:template match="*:Page">
    <xsl:variable name="fname" select="//*:alto/*:Description/*:sourceImageInformation/*:fileName"/>
    <div class="ocr_page" id="{mf:getId(@ID,'page',.)}"
         title="image {$fname}; bbox 0 0 {@WIDTH} {@HEIGHT}; ppageno 0">
      <xsl:apply-templates select="*:TopMargin"/>
      <xsl:apply-templates select="*:PrintSpace"/>
      <xsl:apply-templates select="*:BottomMargin"/>
    </div>
  </xsl:template>

  <xsl:template match="*:TopMargin">
    <div class="ocr_header" id="{mf:getId(@ID,'block',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
      <xsl:apply-templates select="*:ComposedBlock|*:TextBlock"/>
    </div>
  </xsl:template>

  <xsl:template match="*:PrintSpace">
    <xsl:apply-templates select="*:ComposedBlock|*:TextBlock"/>
  </xsl:template>

  <xsl:template match="*:BottomMargin">
    <div class="ocr_footer" id="{mf:getId(@ID,'block',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
      <xsl:apply-templates select="*:ComposedBlock|*:TextBlock"/>
    </div>
  </xsl:template>

  <xsl:template match="*:ComposedBlock">
    <div class="ocr_carea" id="{mf:getId(@ID,'block',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
      <xsl:apply-templates select="*:TextBlock|*:ComposedBlock"/>
    </div>
  </xsl:template>

  <xsl:template match="*:TextBlock">
    <p class="ocr_par" dir="ltr" id="{mf:getId(@ID,'par',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
      <xsl:variable name="lang" select="@language|@LANG"/>
      <xsl:choose>
        <xsl:when test="$lang != ''">
          <xsl:attribute name="lang"><xsl:value-of select="$lang"/></xsl:attribute>
        </xsl:when>
        <xsl:when test="$language != 'unknown'">
          <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="*:TextLine"/>
    </p>
  </xsl:template>

  <xsl:template match="*:TextLine">
    <span class="ocr_line" id="{mf:getId(@ID,'line',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
      <xsl:apply-templates select="*:String"/>
    </span>
  </xsl:template>

  <xsl:template match="*:String">
    <xsl:variable name="textstyleid" select="@STYLEREFS"/>
    <xsl:variable name="style" select="$styles[@ID = $textstyleid]"/>
    <xsl:variable name="fontfamily" select="string($style/@FONTFAMILY)"/>
    <xsl:variable name="fontsize" select="string($style/@FONTSIZE)"/>

    <span class="ocrx_word" id="{mf:getId(@ID,'word',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
      <xsl:if test="normalize-space($fontfamily)">
        <xsl:attribute name="x_font"><xsl:value-of select="$fontfamily"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="normalize-space($fontsize)">
        <xsl:attribute name="x_fsize"><xsl:value-of select="$fontsize"/></xsl:attribute>
      </xsl:if>
      <xsl:call-template name="style_and_content"/>
    </span>
  </xsl:template>

  <xsl:template name="style_and_content">
    <xsl:choose>
      <xsl:when test="@STYLE = 'bold'"><strong><xsl:call-template name="content"/></strong></xsl:when>
      <xsl:when test="@STYLE = 'italics'"><em><xsl:call-template name="content"/></em></xsl:when>
      <xsl:when test="@STYLE = 'subscript'"><sub><xsl:call-template name="content"/></sub></xsl:when>
      <xsl:when test="@STYLE = 'superscript'"><sup><xsl:call-template name="content"/></sup></xsl:when>
      <xsl:when test="@STYLE = 'underline'"><u><xsl:call-template name="content"/></u></xsl:when>
      <xsl:when test="@STYLE = 'smallcaps'"><span class="small-caps"><xsl:call-template name="content"/></span></xsl:when>
      <xsl:otherwise><xsl:call-template name="content"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="content">
    <xsl:choose>
      <xsl:when test="@CONTENT != ''">
        <xsl:value-of select="@CONTENT"/>
        <xsl:if test="local-name(following-sibling::*[1]) = 'HYP'">
          <xsl:text>-</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise><xsl:text/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:function name="mf:getBox" as="xs:string">
    <xsl:param name="HEIGHT"/>
    <xsl:param name="WIDTH"/>
    <xsl:param name="VPOS"/>
    <xsl:param name="HPOS"/>
    <xsl:param name="WC"/>

    <xsl:variable name="HPOSn" select="number($HPOS)"/>
    <xsl:variable name="VPOSn" select="number($VPOS)"/>
    <xsl:variable name="WIDTHn" select="number($WIDTH)"/>
    <xsl:variable name="HEIGHTn" select="number($HEIGHT)"/>

    <xsl:variable name="left" select="if ($HPOSn = $HPOSn) then $HPOSn else 0"/>
    <xsl:variable name="top" select="if ($VPOSn = $VPOSn) then $VPOSn else 0"/>
    <xsl:variable name="width" select="if ($WIDTHn = $WIDTHn) then $WIDTHn else 0"/>
    <xsl:variable name="height" select="if ($HEIGHTn = $HEIGHTn) then $HEIGHTn else 0"/>

    <xsl:variable name="right" select="$left + $width"/>
    <xsl:variable name="bottom" select="$top + $height"/>

    <xsl:variable name="wconf" select="number($WC)"/>
    <xsl:variable name="wconfString"
      select="if ($WC != '' and $wconf = $wconf)
              then concat('; x_wconf ', string($wconf * 100))
              else ''"/>

    <xsl:variable name="parts" as="xs:string*">
      <xsl:sequence select="('bbox', string($left), string($top), string($right), string($bottom))"/>
      <xsl:if test="normalize-space($wconfString)">
        <xsl:sequence select="$wconfString"/>
      </xsl:if>
    </xsl:variable>

    <xsl:sequence select="string-join($parts, ' ')"/>
  </xsl:function>

  <xsl:function name="mf:getId" as="xs:string">
    <xsl:param name="ID"/>
    <xsl:param name="nodetype"/>
    <xsl:param name="node"/>
    <xsl:sequence select="if ($ID != '') then $ID else concat($nodetype, '_', generate-id($node))"/>
  </xsl:function>

</xsl:stylesheet>
