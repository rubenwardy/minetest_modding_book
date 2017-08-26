---
---
#!/bin/sh

oldCWD="$PWD"
cd $(dirname $0)
cd ../en/

wkhtmltopdf --print-media-type {% for link in site.data.links_en %}{% if link.link %}{{ link.link }} {% endif %}{% endfor %} out.pdf
mv out.pdf $oldCWD/book.pdf
