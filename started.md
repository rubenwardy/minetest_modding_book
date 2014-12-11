---
title: Chapter One - Getting Started
layout: default
---

Chapter One – Getting Started
=============================

Introduction
------------

In this chapter we will learn how to create a mod's folder structure,
explore the modding API that Minetest has to offer, and learn how to use
it to create simple decorative mods.

### What you will need:
* A plain text editor (eg: NotePad+, ConTEXT, or GEdit)
* OR A Lua IDE such as Eclipse.
* A copy of Minetest in the 0.4 series. (eg: 0.4.10)

### Contents
* Mod Folders
* Mod Packs
*	Dependencies
*	Registering a simple node

Mod Folders
-----------

Each mod has its own folder, where all its Lua code, textures, models and sounds are placed.
These folders need to be placed in a mod location, such as minetest/mods, and they can be
placed in mod packs: as explained below.

### Mod Folder Structure
	Mod Name
	-	init.lua - the main scripting code file, which is run when the game loads.
	-	(optional) depends.txt - a list of mod names that needs to be loaded before this mod.
	-	(optional) textures/ - place images here, commonly in the format modname_itemname.png
	-	(optional) sounds/ - place sounds in here
	-	(optional) models/ - place 3d models in here
	...and any other lua files to be included by init.lua

Only the init.lua file is required in a mod for it to run on game load, however the other
items are needed by some mods to perform its functionality.

Dependencies
------------

The depends text file allows you to specify what mods this mod requires to run, and what
needs to be loaded before this mod.

	depends.txt
	modone
	modtwo
	modthree?

As you can see, each mod name is on its own line. The question mark after a mod name
means that it is not required for the mod to load, but if it is present,
then it needed to be loaded before this mod. Running your mod without having the
mods with names without a question mark above, such as ``modone``, will cause your mod to
be disabled, or if an earlier version of Minetest is used,
then the game will stop with an error message.

Mod Packs
---------

Mods can be grouped into mod packs, which are folders with the file modpack.txt in it

### Mod Pack Folder Structure
	Mod Name
	-	modone/
	-	modtwo/
	-	modthree/
	-	modfour/
	-	Modpack.txt – signals that this is a mod pack, content does not matter

Example Time
------------

Are you confused? Don't worry, here is an example putting all of this together.

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

Our mod has a name of "mymod". It has two files: init.lua and depends.txt.
The script prints a message and then registers a node – which will be explained in the next chapter.
The depends text file adds a dependency to the default mod, which is in minetest_game.

Questions
---------

* What is the minimum that a mod folder can contain?
* What language does Minetest use in its modding capability?

