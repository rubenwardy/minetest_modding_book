Minetest Doc
============

This online book will teach you how to create mods in easy chapters.  
The chapters will explain a concept, give examples, and set tasks for you to complete.

This documentation was created by the Minetest community in order to  
help new modders gain a foothold.

You can contribute to this project on GitHub.  
It uses Jekyll to turn Markdown into a website.

Book written by rubenwardy and contributers.  
License: CC-BY-NC-SA 3.0

Contributing
------------

You don't need to run jekyll, you can just edit and create files in  
chapters. In fact, you don't even need to do markdown, send me a word document  
and I can convert it into the correct formatting. It is the writing which is the hard  
bit, not the formatting.

Running as a Website
--------------------

You can build it as a website using jekyll.

**Serving on http://localhost:4000/minetest_doc/**

```
$ jekyll serve -b /minetest_doc
```

**Building to folder**

```
$ jekyll build
```

Goes to _site/

Commits
-------

If you are editing or creating a particular chapter, then use commit messages like this:

```
Getting Started - corrected typos
Entities - created chapter
```

Just use a normal style commit message otherwise.

HTML and CSS
------------

The HTML is in _includes/.  
header.html contains all the HTML code above a chapter's content,  
footer.html contains all the HTML code below a chapter's content.  
The CSS is in static/

Example Chapter
---------------

chapters are to be saved to chapters/

```Markdown
---
title: Chapter Title
layout: default
permalink: chaptertitle/index.html
---

Introduction
------------

Explain what this chapter will cover.
You may use multiple paragraphs, but keep it fairly consise.

### What you will need:
* List tools you need to complete this chapter

### Contents
* List
* The
* Sections

Section
-------

Explaining the concept of something.

You can link to other chapters like this: [chapter title]({{ relative }}/chaptertitle/).//
Do it like wikipedia, link words in a sentence but don't explicitly tell the user to view it//
or click the link

### Mod Folder Structure
	Mod Name
	-	init.lua - the main scripting code file, which is run when the game loads.
	-	(optional) depends.txt - a list of mod names that needs to be loaded before this mod.
	-	(optional) textures/ - place images here, commonly in the format modname_itemname.png
	-	(optional) sounds/ - place sounds in here
	-	(optional) models/ - place 3d models in here
	...and any other lua files to be included by init.lua

Code snippets are tabbed one level in, except for lua snippets, which use a code highligter.

Section 2
---------

Explaining another concept

### Mod Pack Folder Structure
	Mod Name
	-	modone/
	-	modtwo/
	-	modthree/
	-	modfour/
	-	Modpack.txt – signals that this is a mod pack, content does not matter

Example Time
------------

You should include a examples.

### Mod Folder
	mymod/
	-	init.lua
	-	depends.txt


### depends.txt
	default

### init.lua
{% highlight lua %}
print("This file will be run at load time!")

minetest.register_node("mymod:node",{
	description = "This is a node",
	tiles = {
		"mymod_node.png",
		"mymod_node.png",
		"mymod_node.png",
		"mymod_node.png",
		"mymod_node.png",
		"mymod_node.png"
	},
	groups = {cracky = 1}
})
{% endhighlight %}

Explain the code here, but their is no need to explain every single line

Tasks
-----

* Set some tasks for the user to do
* Start with easier ones, and work up to harder ones.


```
