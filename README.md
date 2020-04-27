# Minetest Modding Book

[![Build status](https://gitlab.com/rubenwardy/minetest_modding_book/badges/master/pipeline.svg)](https://gitlab.com/rubenwardy/minetest_modding_book/pipelines)<br>
[Read Online](https://rubenwardy.com/minetest_modding_book/)

Book written by rubenwardy.  
License: CC-BY-SA 3.0

## Finding your way around

* `_data/` - Contains list of languages
* `_layouts/` - Layouts to wrap around each page.
* `static/` - CSS, images, scripts.
* `_<lang>/`
    * `<section>/` - Markdown files for each chapter.

## Contributing chapters

* Create a pull request with a new chapter in markdown.
* Write a new chapter in the text editor of your choice and
 [send them to me](https://rubenwardy.com/contact/).

I'm happy to fix the formatting of any chapters. It is
the writing which is the hard bit, not the formatting.

### Chapter Guidelines

* Prefer pronounless text, but `you` if you must. Never `we` nor `I`.
* Do not rely on anything that isn't printable to a physical book.
* Any links must be invisible - ie: if they're removed, then the chapter must
  still make sense.
* Table of contents for each chapter with anchor links.
* Add `your turn`s to the end of a chapter when relevant.
* Titles and subheadings should be in Title Case.

### Making a Chapter

To create a new chapter, make a new file in _en/section/.
Name it something that explains what the chapter is about.
Replace spaces with underscores ( _ )

```markdown
---
title: Chapter Name
layout: default
root: ..
idx: 4.5
long_notice:
  level: tip
  title: This is a long tip!
  message: This is a very long tip, so it would be unreadable if
           placed in the main body of the chapter. Therefore,
           it is a good idea to put it in the frontmatter instead.
---

## Chapter Name

Write a paragraph or so explaining what will be covered in this chapter.
Explain why/how these concepts are useful in modding

* [List the](#list-the)
* [Parts in](#parts-in)
* [This Chapter](#this-chapter)

## List the

{% include notice.html notice=page.long_notice %}

Paragraphs

\```lua
code
\```

## Parts in

## This Chapter
```

## Commits

If you are editing or creating a particular chapter, then use commit messages like this:

```
Getting Started - corrected typos
Entities - created chapter
```

Just use a normal style commit message otherwise.

## Adding a new language

1. Copy `_en/` to your language code
2. Add entry to `_data/languages.yml`
3. Add entry to `collections` in `_config.yml`
4. Add your language to the if else in `layouts/default.html`
5. Translate your language code folder (that you made in step 1)
   You can translate the file paths, just make sure you keep any ids the same.


## Using Jeykll

I use [Jekyll](http://jekyllrb.com/) 3.8.0

    # For Debian/Ubuntu based:
    sudo apt install ruby-dev
    gem install jekyll github-pages

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
