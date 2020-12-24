---
title: Releasing a Mod
layout: default
root: ../..
idx: 8.6
redirect_from: /en/chapters/releasing.html
---

## Introduction <!-- omit in toc -->

Releasing, or publishing, a mod allows other people to make use of it. Once a mod has been
released it might be used in singleplayer games or on servers, including public servers.

- [Choosing a License](#choosing-a-license)
	- [LGPL and CC-BY-SA](#lgpl-and-cc-by-sa)
	- [CC0](#cc0)
	- [MIT](#mit)
- [Packaging](#packaging)
	- [README.txt](#readmetxt)
	- [mod.conf / game.conf](#modconf--gameconf)
	- [screenshot.png](#screenshotpng)
- [Uploading](#uploading)
	- [Version Control Systems](#version-control-systems)
- [Releasing on ContentDB](#releasing-on-contentdb)
- [Forum Topic](#forum-topic)

## Choosing a License

You need to specify a license for your mod. This is important because it tells other
people the ways in which they are allowed to use your work. If your mod doesn't have
a license, people won't know whether they are allowed to modify, distribute or use your
mod on a public server.

Your code and your art need different things from the licenses they use. For example,
Creative Commons licenses shouldn't be used with source code,
but can be suitable choices for artistic works such as images, text and meshes.

You are allowed any license; however, mods which disallow derivatives are banned from the
official Minetest forum. (For a mod to be allowed on the forum, other developers must be
able to modify it and release the modified version.)

Please note that **public domain is not a valid licence**, because the definition varies
in different countries.

### LGPL and CC-BY-SA

This is a common license combination in the Minetest community, and is what
Minetest and Minetest Game use.
You license your code under LGPL 2.1 and your art under CC-BY-SA.
This means that:

* Anyone can modify, redistribute and sell modified or unmodified versions.
* If someone modifies your mod, they must give their version the same license.
* Your copyright notice must be kept.

### CC0

These licenses allow anyone to do what they want with your mod,
which means they can modify, redistribute, sell, or leave-out attribution.
These licenses can be used for both code and art.

It is important to note that WTFPL is strongly discouraged and people may
choose not to use your mod if it has this license.

### MIT

This is a common license for mod code. The only restriction it places on users
of your mod is that they must include the same copyright notice and license
in any copies of the mod or of substantial parts of the mod.

## Packaging

There are some files that are recommended to include in your mod
before you release it.

### README.txt

The README file should state:

* What the mod does.
* What the license is.
* What dependencies there are.
* How to install the mod.
* Current version of the mod.
* Optionally, the where to report problems or get help.

### mod.conf / game.conf

Make sure you add a description key to explain what your mod does. Be concise without being vague.
It should be short because it will be displayed in the content installer which has
limited space.

Good example:

    description = Adds soup, cakes, bakes and juices.

Avoid this:

    description = The food mod for Minetest. (<-- BAD! It's vague)

### screenshot.png

Screenshots should be 3:2 (3 pixels of width for every 2 pixels of height)
and have a minimum size of 300 x 200px.

The screenshot is displayed in the mod store.

## Uploading

So that a potential user can download your mod, you need to upload it somewhere
publicly accessible. There are several ways to do this, but you should use the
approach that works best for you, as long as it meets these requirements, and any
others which may be added by forum moderators:

* **Stable**      - The hosting website should be unlikely to shut down without warning.
* **Direct link** - You should be able to click a link and download the file
                   without having to view another page.
* **Virus Free**  - Mods with malicious content will be removed from the forum.

ContentDB allows you to upload zip files, and meets these criteria.

### Version Control Systems

A Version Control System (VCS) is software that manages changes to software,
often making it easier to distribute and receive contributed changes.

The majority of Minetest modders use Git and a website like GitHub to distribute
their code.

Using git can be difficult at first. If you need help with this please see:

* [Pro Git book](http://git-scm.com/book/en/v1/Getting-Started) - Free to read online.
* [GitHub for Windows app](https://help.github.com/articles/getting-started-with-github-for-windows/) -
Using a graphical interface on Windows to upload your code.

## Releasing on ContentDB

ContentDB is the official place to find and distribute mods and games. Users can
find content using the website, or download and install using the integration
built into the Minetest main menu.

Sign up to [ContentDB](https://content.minetest.net) and add your mod or game.
Make sure to read the guidance given in the Help section.

## Forum Topic

You can also create a forum topic to let users discuss your mod or game.

Mod topics should be created in ["WIP Mods"](https://forum.minetest.net/viewforum.php?f=9) (Work In Progress)
forum, and Game topics in the ["WIP Games"](https://forum.minetest.net/viewforum.php?f=50) forum.
When you no longer consider your mod a work in progress, you can
[request that it be moved](https://forum.minetest.net/viewtopic.php?f=11&t=10418)
to "Mod Releases."

The forum topic should contain similar content to the README, but should
be more promotional and also include a link to download the mod.
It's a good idea to include screenshots of your mod in action, if possible.

The subject of topic must be in one of these formats:

* [Mod] Mod Title [modname]
* [Mod] Mod Title [version number] [modname]

For example:

* [Mod] More Blox [0.1] [moreblox]
