# hOCR-to-ALTO
Convert between Tesseract hOCR and ALTO XML 2.0/2.1/3.0 using XSL stylesheets

The XSLT scripts are written as XSLT 2.0 scripts, so they require an XSLT 2.0
capable transformer, like [Saxon](http://www.saxonica.com/ce/user-doc/1.1/).

See [ocr-fileformat](https://github.com/UB-Mannheim/ocr-fileformat) for an
interface to using these stylesheets.

## CONTENTS

  * [`./alto2hocr.xsl`](./alto2hocr.xsl)
    * Convert ALTO v2.0-1 to hOCR
  * [`./hocr2alto2.0.xsl`](./hocr2alto2.0.xsl)
    * Convert hOCR to ALTO v2.0
  * [`./hocr2alto2.1.xsl`](./hocr2alto2.1.xsl)  
    * Convert hOCR to ALTO v2.1
  * [`./hocr2alto3.0.xsl`](./hocr2alto3.0.xsl)     
    * Convert hOCR to ALTO v3
  * [`./alto2text.xsl`](./alto2text.xsl)
    * Convert ALTO v2.0-1 to plain text
  * [`./hocr2text.xsl`](./hocr2text.xsl)
    * Convert hOCR to plain text
  * [`codes_lookup.xml`](./codes_lookup.xml)
    * ISO language codes
    * file generated with https://github.com/filak/iso-language-codes

