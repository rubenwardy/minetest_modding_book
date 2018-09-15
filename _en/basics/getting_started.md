---
title: Getting Started
layout: default
root: ../..
idx: 1.1
description: Learn how to make a mod folder, including init.lua, depends.txt and more.
redirect_from:
- /en/chapters/folders.html
- /en/basics/folders.html
---

## Introduction

Understanding the basic structure of a mod's folder
is an essential skill when creating mods.

* [Mod Directory](#mod-directory)
* [Dependencies](#dependencies)
* [Mod Packs](#mod-packs)
* [Example](#example)

## Mod Directory

Each mod has its own directory where all its Lua code, textures, models, and
sounds are placed. These directories need to be placed in a mod location such as
minetest/mods.

![Find the mod's directory]({{ page.root }}/static/folder_modfolder.jpg)

A "mod name" is used to refer to a mod. Each mod should have a unique name.
Mod names can include letters, numbers, and underscores. A good name should
describe what the mod does, and the directory which contains the components of a mod
needs to be given the same name as the mod name.
To find out if a mod name is available, try searching for it on
[content.minetest.net](https://content.minetest.net).

    mymod
    ├── init.lua (required) - The main scripting code file. Runs when the game loads.
    ├── mod.conf (recommended) - Mod metadata file. Contains description and dependencies.
    ├── textures (optional)
    │   └── ... any textures or images
    ├── sounds (optional)
    │   └── ... any sounds
    └── ... any other files or directories

Only the init.lua file is actually required in a mod for it to run on game load;
however, mod.conf is recommended and other components may be needed
to perform a mod's functionality.

## Dependencies

A dependency is another mod which the mod requires to be loaded before itself.
The mod may require the other's mods code, items, or other resources to be available.
There are two types of dependencies: hard and optional dependencies.
Both require the mod to be loaded first, but a hard dependency will cause the mod to
fail to load if the required mod isn't available.
An optional dependency is useful if you want to optionally support another mod if the
user wishes to use it.

### mod.conf

Dependencies should be listed in mod.conf.
The file is used for mod metadata such as the mod's name, description, and other information.

    name = mymod
    description = Adds foo, bar, and bo
    depends = modone, modtwo
    optional_depends = modthree

### depends.txt

For compatibility with 0.4.x versions of Minetest, you'll need to also provide
a depends.txt file:

    modone
    modtwo
    modthree?

Each modname is on its own line.
Mod names with a question mark following them are optional dependencies.
If an optional dependency is installed, it is loaded before the mod;
however, if the dependency is not installed, the mod still loads.
This is in contrast to normal dependencies which will cause the current
mod not to work if the dependency is not installed.

## Mod Packs

Mods can be grouped into mod packs which allow multiple mods to be packaged
and moved together. They are useful if you want to supply multiple mods to
a player but don't want to make them download each one individually.

    modpack1
    ├── modpack.lua (required) - signals that this is a mod pack, content does not matter
    ├── mod1
    │   └── ... mod files
    └── mymod (optional)
        └── ... mod files


## Example

Are you confused? Don't worry, here is an example which puts all of this together:

### Mod Folder
    mymod
    ├── textures
    │   └── mymod_node.png files
    ├── depends.txt
    ├── init.lua
    └── mod.conf

### depends.txt
    default

### init.lua
{% highlight lua %}
print("This file will be run at load time!")

minetest.register_node("mymod:node", {
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

### mod.conf
    name = mymod
    descriptions = Adds a node
    depends = default

This mod has the name "mymod". It has three text files: init.lua, mod.conf,
and depends.txt.\\
The script prints a message and then registers a node –
which will be explained in the next chapter.\\
There's a single dependency, the
[default mod](https://content.minetest.net/metapackages/default/) which is
usually found in Minetest Game.\\
There is also a texture in textures/ for the node.

Please note that a *game* is not a modpack.
Games have their own organisational structure which will be explained in the
Games chapter.
