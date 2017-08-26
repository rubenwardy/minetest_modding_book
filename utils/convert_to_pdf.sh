---
---
#!/bin/sh

oldCWD="$PWD"
cd $(dirname $0)
cd ../en/

#wkhtmltopdf --print-media-type {% for link in site.data.links_en %}{% if link.link %}{{ link.link }} {% endif %}{% endfor %} out.pdf
#mv out.pdf $oldCWD/book.pdf

{% for link in site.data.links_en %}
{% if link.link %}
/opt/google/chrome/google-chrome --headless  --disable-gpu --print-to-pdf file:///${PWD}/{{ link.link }}

{% if link.num %}
mv output.pdf page_{{ link.num }}.pdf
{% else %}
mv output.pdf page_0_{{ link.link | replace:".","_" }}.pdf
{% endif %}

{% endif %}
{% endfor %}

pdfunite page*.pdf ${oldCWD}/book.pdf
