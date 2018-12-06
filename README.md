# hOCR-to-ALTO
Convert between Tesseract hOCR and ALTO XML 2.0/2.1 using XSL stylesheets

The XSLT scripts are written as XSLT 2.0 scripts, so they require an XSLT 2.0
capable transformer, like [Saxon](http://www.saxonica.com/ce/user-doc/1.1/).

See [ocr-fileformat](https://github.com/UB-Mannheim/ocr-fileformat) for an
interface to using these stylesheets.

## CONTENTS

  * [`./alto2hocr.xsl`](./alto2hocr.xsl)
    * Convert ALTO 2.0 / ALTO 2.1 to hOCR
  * [`./hocr2alto2.0.xsl`](./hocr2alto2.0.xsl)
    * Convert hOCR to ALTO 2.0
  * [`./hocr2alto2.1.xsl`](./hocr2alto2.1.xsl)
    * Convert hOCR to ALTO 2.1
  * [`./alto2text.xsl`](./alto2text.xsl)
    * Convert ALTO 2.0 / ALTO 2.1 to plain text
  * [`./alto2text.xsl`](./alto2text.xsl)
    * Convert hOCR to plain text
  * [`codes_lookup.xml`](./codes_lookup.xml)
    * ISO language codes
    * file generated with https://github.com/filak/iso-language-codes

## LICENSE

The MIT License (MIT)

Copyright (c) 2016-2018 Filip Kriz (@filak)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
