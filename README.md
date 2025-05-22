# hOCR-to-ALTO
Convert between Tesseract hOCR and [ALTO XML](https://www.loc.gov/standards/alto/) 2.0/2.1/3/4 using XSL stylesheets

> The XSLT scripts use XSLT 2.0 features - so a **XSLT 2.0
capable transformer is required** - ie. [Saxon](https://www.saxonica.com/download/java.xml)

Running the conversion using Saxon-HE command line - example converting ALTO to hOCR:

     > java -cp "saxon-he-12.7.jar;lib/*" net.sf.saxon.Transform -s:input-alto.xml -xsl:alto__hocr.xsl -o:output-hocr.xml

See [ocr-fileformat](https://github.com/UB-Mannheim/ocr-fileformat) for an
interface to using these stylesheets.

hOCR-spec https://github.com/kba/hocr-spec

File naming scheme:   sourceFormatVersion__targetFormatVersion.xsl

## CONTENTS

  * Convert ALTO to hOCR
    * [`alto__hocr.xsl`](./alto__hocr.xsl) 
  * Convert hOCR to ALTO
    * [`hocr__alto4.xsl`](./hocr__alto4.xsl)
    * [`hocr__alto3.xsl`](./hocr__alto3.xsl)
    * [`hocr__alto2.1.xsl`](./hocr__alto2.1.xsl)     
    * [`hocr__alto2.0.xsl`](./hocr__alto2.0.xsl) 
  * Convert ALTO to plain text
    * [`alto__text.xsl`](./alto__text.xsl)
  * Convert hOCR to plain text
    * [`hocr__text.xsl`](./hocr__text.xsl)
  * Language codes
    * [`codes_lookup.xml`](./codes_lookup.xml) - generated with https://github.com/filak/iso-language-codes
