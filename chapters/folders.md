---
title: Folder Structure
layout: default
root: ../
---

Introduction
------------

In this chapter we will learn how the basic structure of a mod's folder.
This is essential for creating mods.

* Mod Folders
* Dependencies
* Mod Packs

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

As you can see, each mod name is on its own line.

Mod names with a question mark following them are optional dependencies.
If an optional mod is installed, it is loaded before the current mod.
However, if the mod is not installed, the current one still loads.
This is in contrast to normal dependencies, which will cause the current
mod not to work if the mod is not installed.

Mod Packs
---------

Modpacks allow multiple mods to be packaged together, and move together.
They are useful if you want to supply multiple mods to an end user, and don't
want to make them download each one individually.

### Mod Pack Folder Structure
	modpackfolder/
	-	modone/
	-	modtwo/
	-	modthree/
	-	modfour/
	-	modpack.txt – signals that this is a mod pack, content does not matter

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
