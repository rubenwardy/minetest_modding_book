---
title: Folder Structure
layout: default
root: ../
---

## Introduction

In this chapter we will learn the basic structure of a mod's folder.
This is an essential skill when creating mods.

* Mod Folders
* Dependencies
* Mod Packs

## Mod Folders

![Find the mod's folder]({{ page.root }}/static/folder_modfolder.jpg)

Each mod has its own folder where all its Lua code, textures, models, and sounds
are placed. These folders need to be placed in a mod location such as
minetest/mods. Mods can be grouped into mod packs which are explained below.

A "mod name" is used to refer to a mod. Each mod should have a unique mod name,
which you can choose - a good mod name describes what the mod does.
Mod names can be made up of letters, numbers, or underscores. The folder a mod is
in needs to be called the same as the mod name.

### Mod Folder Structure
	Mod name (eg: "mymod")
	-	init.lua - the main scripting code file, which is run when the game loads.
	-	(optional) depends.txt - a list of mod names that needs to be loaded before this mod.
	-	(optional) textures/ - place images here, commonly in the format modname_itemname.png
	-	(optional) sounds/ - place sounds in here
	-	(optional) models/ - place 3d models in here
	...and any other lua files to be included by init.lua

Only the init.lua file is required in a mod for it to run on game load; however,
the other items are needed by some mods to perform their functionality.

## Dependencies

The depends text file allows you to specify which mods this mod requires to run and what
needs to be loaded before this mod.

**depends.txt**

	modone
	modtwo
	modthree?

As you can see, each modname is on its own line.

Mod names with a question mark following them are optional dependencies.
If an optional dependency is installed, it is loaded before the mod.
However, if the dependency is not installed, the mod still loads.
This is in contrast to normal dependencies which will cause the current
mod not to work if the dependency is not installed.

## Mod Packs

Modpacks allow multiple mods to be packaged together and be moved together.
They are useful if you want to supply multiple mods to a player but don't
want to make them download each one individually.

### Mod Pack Folder Structure
	modpackfolder/
	-	modone/
	-	modtwo/
	-	modthree/
	-	modfour/
	-	modpack.txt – signals that this is a mod pack, content does not matter

## Example Time

Are you confused? Don't worry, here is an example putting all of this together.

### Mod Folder
	mymod/
	-	textures/
	-	-	mymod_node.png
	-	init.lua
	-	depends.txt


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

Our mod has a name of "mymod". It has two text files: init.lua and depends.txt.\\
The script prints a message and then registers a node – which will be explained in the next chapter.\\
The depends text file adds a dependency to the default mod which is in minetest_game.\\
There is also a texture in textures/ for the node.
