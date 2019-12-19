# hOCR-to-ALTO
Convert between Tesseract hOCR and [ALTO XML](https://www.loc.gov/standards/alto/) 2.0/2.1/3/4 using XSL stylesheets

The XSLT scripts are written as XSLT 2.0 scripts, so they require an XSLT 2.0
capable transformer, like [Saxon](https://www.saxonica.com/download/java.xml).

See [ocr-fileformat](https://github.com/UB-Mannheim/ocr-fileformat) for an
interface to using these stylesheets.

File naming scheme:   sourceFormatVersion__targetFormatVersion.xsl

## CONTENTS

  * Convert ALTO to hOCR
    * [`alto2__hocr.xsl`](./alto2__hocr.xsl) 
    * [`alto3__hocr.xsl`](./alto3__hocr.xsl)  
    * [`alto4__hocr.xsl`](./alto4__hocr.xsl)  
  * Convert hOCR to ALTO
    * [`hocr__alto2.0.xsl`](./hocr__alto2.0.xsl) 
    * [`hocr__alto2.1.xsl`](./hocr__alto2.1.xsl)  
    * [`hocr__alto3.xsl`](./hocr__alto3.xsl)     
    * [`hocr__alto4.xsl`](./hocr__alto4.xsl)
  * Convert ALTO to plain text
    * [`alto2__text.xsl`](./alto2__text.xsl)
    * [`alto3__text.xsl`](./alto3__text.xsl)     
    * [`alto4__text.xsl`](./alto4__text.xsl)
  * Convert hOCR to plain text
    * [`hocr__text.xsl`](./hocr__text.xsl)
  * Language codes
    * [`codes_lookup.xml`](./codes_lookup.xml)
    * file generated with https://github.com/filak/iso-language-codes

