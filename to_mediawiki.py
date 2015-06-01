import pandoc, sys

pandoc.PANDOC_PATH = '/usr/bin/pandoc'

if len(sys.argv) != 2:
	sys.stderr.write("USAGE: to_mediawiki.py path/to/chapter.md")
	sys.exit(-1)

sys.stderr.write("Reading from " + sys.argv[1] + "\n")

ifile = open(sys.argv[1])
input_t = ""
for line in ifile.readlines():
	if len(line.strip()) > 0 and line.strip()[len(line.strip()) - 1] == "\\":
		sys.stderr.write("found 1!\n")
		line = line.strip("\n").strip("\\")
		line += "<br />\n"
	input_t += line

doc = pandoc.Document()

input_t = input_t.replace("{% highlight lua %}", "<pre>")
input_t = input_t.replace("{% endhighlight %}", "</pre>")
input_t = input_t.replace("{{ page.root }}/static/", "modding_book_")
input_t = input_t.replace("{{ page.root }}", "")

doc.markdown = input_t

sys.stdout.write("{{ ModdingBook }}\n\n")
sys.stdout.write(doc.mediawiki)
