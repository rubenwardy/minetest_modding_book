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

- [License Choices](#license-choices)
  - [LGPL and CC-BY-SA](#lgpl-and-cc-by-sa)
  - [CC0](#cc0)
  - [MIT](#mit)
- [Packaging](#packaging)
  - [README.txt](#readmetxt)
  - [description.txt](#descriptiontxt)
  - [screenshot.png](#screenshotpng)
- [Uploading](#uploading)
  - [Version Control Systems](#version-control-systems)
  - [Forum Attachments](#forum-attachments)
- [Forum Topic](#forum-topic)
  - [Subject](#subject)

## License Choices

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

### description.txt

This should explain what your mod does. Be concise without being vague.
It should be short because it will be displayed in the content installer which has
limited space.

Good example:

    Adds soup, cakes, bakes and juices.

Avoid this:

    (BAD)  The food mod for Minetest.

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
* **Direct link** - You should be able to click a link on the forum and download the file
                   without having to view another page.
* **Virus Free**  - Mods with malicious content will be removed from the forum.

### Version Control Systems

It is recommended that you use a version control system which:

* Allows other developers to easily submit changes.
* Allows the code to be previewed before downloading.
* Allows users to submit bug reports.

The majority of Minetest modders use GitHub as a website to host their code,
but alternatives are possible.

Using a GitHub can be difficult at first. If you need help with this, for
information on using GitHub, please see:

* [Pro Git book](http://git-scm.com/book/en/v1/Getting-Started) - Free to read online.
* [GitHub for Windows app](https://help.github.com/articles/getting-started-with-github-for-windows/) -
Using a graphical interface on Windows to upload your code.

### Forum Attachments

As an alternative to using a version management system, you can use forum attachments to share
your mods. This can be done when creating a mod's forum topic (covered below).

You need to zip the files for the mod into a single file. How to do this varies from
operating system to operating system.
This is nearly always done using the right click menu after selecting all files.

When making a forum topic, on the "Create a Topic" page (see below), go to the
"Upload Attachment" tab at the bottom.
Click "Browse" and select the zipped file. It is recommended that you
enter the version of your mod in the comment field.

<figure>
    <img src="{{ page.root }}/static/releasing_attachments.png" alt="Upload Attachment">
    <figcaption>
        Upload Attachment tab.
    </figcaption>
</figure>

## Forum Topic

You can now create a forum topic. You should create it in
the ["WIP Mods"](https://forum.minetest.net/viewforum.php?f=9) (Work In Progress)
forum.\\
When you no longer consider your mod a work in progress, you can
[request that it be moved](https://forum.minetest.net/viewtopic.php?f=11&t=10418)
to "Mod Releases."

The forum topic should contain similar content to the README, but should
be more promotional and also include a link to download the mod.
It's a good idea to include screenshots of your mod in action, if possible.

The Minetest forum uses bbcode for formatting. Here is an example for a
mod named superspecial:


    Adds magic, rainbows and other special things.

    See download attached.

    [b]Version:[/b] 1.1
    [b]License:[/b] LGPL 2.1 or later

    Dependencies: default mod (found in minetest_game)

    Report bugs or request help on the forum topic.

    [h]Installation[/h]

    Unzip the archive, rename the folder to superspecial and
    place it in minetest/mods/

    (  GNU/Linux: If you use a system-wide installation place
        it in ~/.minetest/mods/.  )

    (  If you only want this to be used in a single world, place
        the folder in worldmods/ in your world directory.  )

    For further information or help see:
    [url]https://wiki.minetest.net/Installing_Mods[/url]

If you modify the above example for your mod topic, remember to
change "superspecial" to the name of your mod.

### Subject

The subject of topic must be in one of these formats:

* [Mod] Mod Title [modname]
* [Mod] Mod Title [version number] [modname]

For example:

* [Mod] More Blox [0.1] [moreblox]
