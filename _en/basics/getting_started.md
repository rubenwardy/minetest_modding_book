---
title: Getting Started
layout: default
root: ../..
idx: 1.1
description: Learn how to make a mod folder, including init.lua, mod.conf and more.
redirect_from:
- /en/chapters/folders.html
- /en/basics/folders.html
---

## Introduction

Understanding the basic structure of a mod's folder is an essential skill when
creating mods.

* [What are Games and Mods?](#what-are-games-and-mods)
* [Mod Directory](#mod-directory)
* [Dependencies](#dependencies)
* [Mod Packs](#mod-packs)
* [Example](#example)


## What are Games and Mods?

The power of Minetest is the ability to easily develop games without the need
to create your own voxel graphics, voxel algorithms, or fancy networking code.

In Minetest, a game is a collection of modules which work together to provide the
content and behaviour of a game.
A module, commonly known as a mod, is a collection of scripts and resources.
It's possible to make a game using only one mod, but this is rarely done because it
reduces the ease by which parts of the game can be adjusted and replaced
independently of others.

It's also possible to distribute mods outside of a game, in which case they
are also *mods* in the more traditional sense - modifications. These mods adjust
or extend the features of a game.

Both the mods contained in a game and third-party mods use the same API.

This book will cover the main parts of the Minetest API,
and is applicable for both game developers and modders.

## Mod Directory

Each mod has its own directory where its Lua code, textures, models, and
sounds are placed. These directories need to be placed in a mod location such as
minetest/mods.

![Find the mod's directory]({{ page.root }}/static/folder_modfolder.jpg)

A *mod name* is used to refer to a mod. Each mod should have a unique name.
Mod names can include letters, numbers, and underscores. A good name should
describe what the mod does, and the directory which contains the components of a mod
must have the same name as the mod name.
To find out if a mod name is available, try searching for it on
[content.minetest.net](https://content.minetest.net).

    mymod
    ├── init.lua (required) - Runs when the game loads.
    ├── mod.conf (recommended) - Contains description and dependencies.
    ├── textures (optional)
    │   └── ... any textures or images
    ├── sounds (optional)
    │   └── ... any sounds
    └── ... any other files or directories

Only the init.lua file is required in a mod for it to run on game load;
however, mod.conf is recommended and other components may be needed
depending on the mod's functionality.

## Dependencies

A dependency occurs when a mod requires another mod to be loaded before itself.
One mod may require another mod's code, items, or other resources to be available
for it to use.

There are two types of dependencies: hard and optional dependencies.
Both require the mod to be loaded first. If the mod being depended on isn't
available, a hard dependency will cause the mod to fail to load, while an optional
dependency might lead to fewer features being enabled.

An optional dependency is useful if you want to optionally support another mod; it can
enable extra content if the user wishes to use both the mods at the same time.

Dependencies should be listed in mod.conf.

### mod.conf

This file is used for mod metadata including the mod's name, description, and other
information. For example:

    name = mymod
    description = Adds foo, bar, and bo.
    depends = modone, modtwo
    optional_depends = modthree

### depends.txt

For compatibility with 0.4.x versions of Minetest, instead of only specifying
dependencies in mod.conf, you need to provide a depends.txt file in which
you list all dependencies:

    modone
    modtwo
    modthree?

Each mod name is on its own line, and mod names with a question mark
following them are optional dependencies.
If an optional dependency is installed, it is loaded before the mod;
however, if the dependency is not installed, the mod still loads.
This is in contrast to normal dependencies which will cause the current
mod not to work if the dependency is not installed.

## Mod Packs

Mods can be grouped into mod packs which allow multiple mods to be packaged
and moved together. They are useful if you want to supply multiple mods to
a player, but don't want to make them download each one individually.

    modpack1
    ├── modpack.lua (required) - signals that this is a mod pack
    ├── mod1
    │   └── ... mod files
    └── mymod (optional)
        └── ... mod files

Please note that a modpack is not a *game*.
Games have their own organisational structure which will be explained in the
Games chapter.

## Example

Here is an example which puts all of this together:

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
```lua
print("This file will be run at load time!")

minetest.register_node("mymod:node", {
    description = "This is a node",
    tiles = {"mymod_node.png"},
    groups = {cracky = 1}
})
```

### mod.conf
    name = mymod
    descriptions = Adds a node
    depends = default

This mod has the name "mymod". It has three text files: init.lua, mod.conf,
and depends.txt.\\
The script prints a message and then registers a node –
which will be explained in the next chapter.\\
There's a single dependency, the
[default mod](https://content.minetest.net/metapackages/default/), which is
usually found in Minetest Game.\\
There is also a texture in textures/ for the node.
