---
title: README for Contributors
layout: default
---

## Welcome!

This project uses Jekyll to turn Markdown into HTML, but you don't need to
do that. You can just create Markdown files and pull request them. In fact,
you don't even need to use Markdown: send me a document via the forum PM, topic
or my email address (see my github profile).
It is the writing which is the hard bit, not the formatting.

Book written by rubenwardy.  
License: CC-BY-SA 3.0

## Why is this a GitHub repo, rather than a wiki?

I want to be able to review any changes to make sure that they
fit my idea of quality.

## Finding your way around

* `_data/` - Contains the navigation bar file.
          (a list of links and link text for the navbar.)
* `_includes/` - Contains HTML templates.
* `_layouts/` - You can safely ignore this.
* `static/` - CSS, images, scripts.
* `<lang>/`
    * `chapters/` - Markdown files for each chapter.

## Adding a new language

* Add entry to `_data/languages.yml`
* Copy links_en, and customise it for your language
* Add your language to the if else in `_includes/header.html`
* Copy en/ to your language code
* Translate your language code folder

## Using Jeykll

I use [Jekyll](http://jekyllrb.com/) 2.5.3

    # For Linux based:

    $ sudo apt-get install ruby-dev
    $ gem install jekyll
    $ gem install jekyll-sitemap

    # You may need to use sudo on the above commands

### Building as a website

You can build it as a website using [Jekyll](http://jekyllrb.com/)

    $ jekyll build

Goes to _site/

### Webserver for Development

You can start a webserver on localhost which will automatically
rebuild pages when you modify their markdown source.

    $ jekyll serve


This serves at <http://localhost:4000> on my computer, but the port
may be different. Check the console for the "server address"

## Commits

If you are editing or creating a particular chapter, then use commit messages like this:

```
Getting Started - corrected typos
Entities - created chapter
```

Just use a normal style commit message otherwise.

## Making a Chapter

To create a new chapter, make a new file in chapters/.
Name it something that explains what the chapter is about.
Replace spaces with underscores ( _ )

**Template**

{% raw %}

    ---
    title: Player Physics
    layout: default
    root: ../
    ---

    Introduction
    ------------

    Write an paragraph or so explaining what will be covered in this chapter.
    Explain why/how these concepts are useful in modding

    * List the
    * Parts in
    * This chapter

    Section
    -------

    Explaining the concept of something.

    You can link to other chapters like this: [chapter title]({{ relative }}/chaptertitle/).//
    Do it like Wikipedia, link words in a sentence but avoid explicitly telling the user to view it//
    or click the link.

        Mod Name
        -    init.lua - the main scripting code file, which is run when the game loads.
        -    (optional) depends.txt - a list of mod names that needs to be loaded before this mod.
        -    (optional) textures/ - place images here, commonly in the format modname_itemname.png
        -    (optional) sounds/ - place sounds in here
        -    (optional) models/ - place 3d models in here
        ...and any other lua files to be included by init.lua

    Code snippets are tabbed one level in, except for lua snippets, which use a code highligter.

    Section 2
    ---------

    Explaining another concept

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

    Use the highlight tags to highlight Lua code.

    Section 3
    ---------

    You should include plenty of examples. Each example should
    be able to be installed in a mod and used. Don't do the thing where
    you make the reading create the mod line-by-line, it is rather annoying
    and good code can explain itself. Explaining line-by-line is needed in earlier chapters,
    and when introducing new concepts.

    ### Mod Folder
        mymod/
        -    init.lua
        -    depends.txt


        default

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

    Explain the code here, but there is no need to explain every single line.
    Use comments and indentation well.

    Your Turn
    ---------

    * **Set Tasks:** Make tasks for the reader to do.
    * **Start easy, get hard:** Start with easier ones, and work up to harder ones.

{% endraw %}

Please note that the above is a guideline on how to make good chapter, but isn't
exhustive and there are many exceptions. The priority is explaining the concepts
to the reader efficiently and in a way which is understandable.
