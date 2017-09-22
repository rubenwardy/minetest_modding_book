#!/bin/sh

# this is QUITE hacky, sorry

jekyll build
mkdir -p tmp
n use latest _site/utils/convert_to_pdf.js
pdfunite tmp/page*.pdf tmp/book.pdf

echo ""
echo "Word count is:"
pdftotext book.pdf - | wc -w
