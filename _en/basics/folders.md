---
title: Folder Structure
layout: default
root: ../..
idx: 1.1
description: Learn how to make a mod folder, including init.lua, depends.txt and more.
redirect_from: /en/chapters/folders.html
---

## Introduction

Understanding the basic structure of a mod's folder
is an essential skill when creating mods.

* [Mod Folders](#mod-folders)
* [Dependencies](#dependencies)
* [Mod Packs](#mod-packs)
* [Example](#example)

## Mod Folders

Each mod has its own folder where all its Lua code, textures, models, and sounds
are placed. These folders need to be placed in a mod location such as
`minetest/mods`.

![Find the mod's folder]({{ page.root }}//static/folder_modfolder.jpg)

A "mod name" is used to refer to a mod. Each mod should have a unique mod name.
Mod names can include letters, numbers, and underscores. A good mod name should
describe what the mod does, and the folder which contains the components of a mod
needs to be given the same name as the mod name.

### Mod Folder Structure

    <mod_name>/ (eg: "mymod")
    |──  init.lua - the main scripting code file, which runs when the game loads.
    |──  (optional) mod.conf - config. file which stores mod-name, dependencies, description, etc.
    |──  (optional) depends.txt - a list of mods that need to be loaded before this mod.
    |──  (optional) description.txt - a short description of the mod.
    |──  (optional) textures/ - images used by the mod, commonly in the format <modname>_<itemname>.png.
    |──  (optional) sounds/ - sounds used by the mod.
    └──  (optional) models/ - 3D models used by the mod.
    ...and any other Lua files to be included.

Only `init.lua` is required in a mod for it to run on game load. However,
the other items are needed by some mods to perform their functionality.

### mod.conf

    name=modname
    description=This is a food mod which supports a huge variety of recipes.
    depends=mod1,mod2
    optional_depends=mod3,mod4

This file stores key-value pairs of mod details, and will replace `depends.txt` and `description.txt` in 5.0.0. In order to retain support for 0.4.x, it's recommended to have a `mod.conf` for 5.0.0 and also `depends.txt` and `description.txt` for 0.4.x versions.

### description.txt

{% include notice.html level="warning" message="This will be deprecated when 5.0.0 is released" %}

    This is a food mod which supports a huge variety of recipes.

This file should contain a short description of the mod, which is used by mod stores (like the builtin
[content browser](https://content.minetest.net)) and mod managers.

### depends.txt

{% include notice.html level="warning" message="This will be deprecated when 5.0.0 is released" %}

This file allows you to specify which mods are required for this mod to run and what
needs to be loaded before this mod.

    modone
    modtwo
    modthree?

As you can see, each modname is on its own line.

Mod names with a question mark following them are optional dependencies.
If an optional dependency is installed, it is loaded before the mod;
however, if the dependency is not installed, the mod still loads.
This is in contrast to normal dependencies which will cause the current
mod not to work if the dependency is not installed.

## Mod Packs

Mods can be grouped into mod packs which allow multiple mods to be packaged
and moved together. They are useful if you want to supply multiple mods to
a player but don't want to make them download each one individually.

### Mod Pack Folder Structure

    <modpack_name>/
    |──  modone/
    |──  modtwo/
    |──  modthree/
    |──  modfour/
    └──  modpack.txt – signals that this is a mod pack, content does not matter

## Example

Are you confused? Don't worry, here is an example which puts all of this together:

### Mod Folder

    mymod/
    |──  textures/
    |    └──  mymod_node.png
    |──  init.lua
    └──  depends.txt

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

This mod has the name `mymod`. It has two text files: `init.lua` and `depends.txt`.\\
The script prints a message and then registers a node – which will be explained in the next chapter.\\
The depends text file adds a dependency on the `default` mod which is in `minetest_game`.\\
There is also a texture in `textures/` for the node.
