<?xml version="1.0" encoding="UTF-8"?>
<!--
Author:  Filip Kriz (@filak)
License: MIT
-->
<xsl:stylesheet version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:mf="http://myfunctions" 
    xpath-default-namespace="http://www.loc.gov/standards/alto/ns-v4#" 
    exclude-result-prefixes="#all">

  <xsl:output method="xml" encoding="utf-8" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes" />
  <xsl:strip-space elements="*"/>
  <!-- Default language code - fallback value -->
  <xsl:param name="language" select="'unknown'" />


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
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <xsl:apply-templates select="*:OCRProcessing/*:ocrProcessingStep"/>
      <meta name='ocr-capabilities' content='ocr_page ocr_header ocr_footer ocr_carea ocr_par ocr_line ocrx_word' />
    </head>
  </xsl:template>
  
  
  <xsl:template match="*:sourceImageInformation">
        <xsl:value-of select="*:fileName"/>
  </xsl:template>

 
  <xsl:template match="*:OCRProcessing/*:ocrProcessingStep|*:Processing/*:processingStep">
      <meta name='ocr-system' content='{*:processingSoftware/*:softwareName} {*:processingSoftware/*:softwareVersion}' />
  </xsl:template>


  <xsl:template match="*:Styles">
  </xsl:template>

  
  <xsl:template match="*:Layout">
    <body>
        <xsl:apply-templates select="*:Page"/>
     </body>
  </xsl:template>
 
 
 <xsl:template match="*:Page">
    <xsl:variable name="fname"><xsl:value-of select="//*:alto/*:Description/*:sourceImageInformation/*:fileName"/></xsl:variable>
    <div class="ocr_page" id="{mf:getId(@ID,'page',.)}" title="image {$fname}; bbox 0 0 {@WIDTH} {@HEIGHT}; ppageno 0">
        <xsl:apply-templates select="*:TopMargin"/>
        <xsl:apply-templates select="*:PrintSpace"/>
        <xsl:apply-templates select="*:BottomMargin"/>
     </div>
  </xsl:template>
  
  
 <xsl:template match="*:TopMargin">
    <div class="ocr_header" id="{mf:getId(@ID,'block',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
        <xsl:apply-templates select="*:ComposedBlock"/>
         <xsl:apply-templates select="*:TextBlock"/>
     </div>
  </xsl:template>
  
  
 <xsl:template match="*:PrintSpace">
        <xsl:apply-templates select="*:ComposedBlock"/>
        <xsl:apply-templates select="*:TextBlock"/>
  </xsl:template>
  
    
 <xsl:template match="*:BottomMargin">
    <div class="ocr_footer" id="{mf:getId(@ID,'block',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
        <xsl:apply-templates select="*:ComposedBlock"/>
         <xsl:apply-templates select="*:TextBlock"/>
     </div>
  </xsl:template>
  
  
  <xsl:template match="*:ComposedBlock">
    <div class="ocr_carea" id="{mf:getId(@ID,'block',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
         <xsl:apply-templates select="*:TextBlock"/>
     </div>
  </xsl:template>


  <xsl:template match="*:TextBlock">
    <p class="ocr_par" dir="ltr" id="{mf:getId(@ID,'par',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">

      <xsl:variable name="lang" select="@language|@LANG" />

        <xsl:choose>
            <xsl:when test="$lang != ''">
                <xsl:attribute name="lang">
                    <xsl:value-of select="$lang" />
                </xsl:attribute>
            </xsl:when>

            <xsl:when test="$language != 'unknown'">
                <xsl:attribute name="lang">
                    <xsl:value-of select="$language" />
                </xsl:attribute>
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
 
    <xsl:variable name="textstyleid"><xsl:value-of select="@STYLEREFS"/></xsl:variable>
    <xsl:variable name="fontfamily"><xsl:value-of select="//Styles/TextStyle[@ID=$textstyleid]/@FONTFAMILY" /></xsl:variable>
    <xsl:variable name="fontsize"><xsl:value-of select="//Styles/TextStyle[@ID=$textstyleid]/@FONTSIZE" /></xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$textstyleid != ''">
        <span class="ocrx_word" id="{mf:getId(@ID,'word',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}" x_font="{$fontfamily}" x_size="{$fontsize}">
           <xsl:call-template name="style_and_content"/>
        </span>
      </xsl:when>

      <xsl:otherwise>
        <span class="ocrx_word" id="{mf:getId(@ID,'word',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS,@WC)}">
           <xsl:call-template name="style_and_content"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  
  <xsl:template name="style_and_content">
 
      <xsl:choose>
        <xsl:when test="@STYLE = 'bold'">
          <strong>
              <xsl:call-template name="content"/>
          </strong>
        </xsl:when>
        <xsl:when test="@STYLE = 'italics'">
          <em>
              <xsl:call-template name="content"/>
          </em>
        </xsl:when>
        <xsl:when test="@STYLE = 'subscript'">
          <sub>
              <xsl:call-template name="content"/>
          </sub>
        </xsl:when>
        <xsl:when test="@STYLE = 'superscript'">
          <sup>
              <xsl:call-template name="content"/>
          </sup>
        </xsl:when>
        <xsl:when test="@STYLE = 'underline'">
          <u>
              <xsl:call-template name="content"/>
          </u>
        </xsl:when>
        <xsl:when test="@STYLE = 'smallcaps'">
          <span class="small-caps">
              <xsl:call-template name="content"/>
          </span>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="content"/>
        </xsl:otherwise>
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

      <xsl:otherwise>
            <xsl:text>
            </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
 
  </xsl:template>
  

<xsl:function name="mf:getBox">
    <xsl:param name="HEIGHT"/>
    <xsl:param name="WIDTH"/>
    <xsl:param name="VPOS"/>
    <xsl:param name="HPOS"/>
    <xsl:param name="WC"/>

    <xsl:variable name="right" select="number($WIDTH) + number($HPOS)"/>
    <xsl:variable name="bottom" select="number($HEIGHT) + number($VPOS)"/>
    
    <xsl:choose>
      <xsl:when test="$WC!=''">
        <xsl:variable name="wconf" select="number($WC) * 100"/>
        <xsl:variable name="wconfString" select="concat('; x_wconf ',string($wconf))"/>
        <xsl:value-of select="string-join(('bbox', $HPOS, $VPOS, string($right), string($bottom), $wconfString),' ')"/>
      </xsl:when>

      <xsl:otherwise>
          <xsl:value-of select="string-join(('bbox', $HPOS, $VPOS, string($right), string($bottom)),' ')"/>
      </xsl:otherwise>
    </xsl:choose>

</xsl:function>


<xsl:function name="mf:getId">
    <xsl:param name="ID"/>
    <xsl:param name="nodetype"/>
    <xsl:param name="node"/>
    
    <xsl:choose>
      <xsl:when test="$ID!=''">
            <xsl:value-of select="$ID"/>
      </xsl:when>

      <xsl:otherwise>
            <xsl:value-of select="concat($nodetype,'_',generate-id($node))"/>
      </xsl:otherwise>
    </xsl:choose>

</xsl:function>
  
  
</xsl:stylesheet>
