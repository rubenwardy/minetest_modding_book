import markdown, urllib2, datetime


#
# Downloading lua_api.txt
#
print("Downloading lua_api.txt...")

url = "https://raw.githubusercontent.com/minetest/minetest/master/doc/lua_api.txt"
text = urllib2.urlopen(url).read()
header = """Minetest Lua Modding API Reference 0.4.13
========================================="""
text = text.replace(header, "")



#
# Generating HTML
#
print("Generating HTML...")
md = markdown.Markdown(extensions=['markdown.extensions.toc'])

links = """<ul>
<li>More information at <a href="http://www.minetest.net/">http://www.minetest.net/</a></li>
<li>Developer Wiki: <a href="http://dev.minetest.net/">http://dev.minetest.net/</a></li>
</ul>"""

html = md.convert(text).replace("{{", "{ {")
html = html.replace(links, "")
links += "This page was last updated "
links += datetime.date.today().strftime("%d/%B/%Y")
links += ".<br />See <a href=\"https://github.com/minetest/minetest/blob/master/doc/lua_api.txt\">doc/lua_api.txt</a> for the latest version (in plaintext)."
links += "<br />Generated using <a href=\"https://github.com/rubenwardy/minetest_modding_book/blob/gh-pages/update_lua_api.py\">a Python script</a>."
html = html.replace("<h2 id=\"programming-in-lua\">", links + "<h2 id=\"programming-in-lua\">")

#
# Writing to file
#
print("Writing to file...")
file = open("lua_api.html", "w")
file.write("---\ntitle: Lua Modding API Reference\nlayout: default\n---\n")
file.write("<h2 id=\"table-of-contents\">Table of Contents</h2>\n")
file.write(md.toc)
file.write(html)
file.close()

print("Done")


