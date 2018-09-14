---
title: Creating Games
layout: default
root: ../..
idx: 6.1
---

## Introduction

The power of Minetest is the ability to easily create games without the need
to write your own voxel graphics and algorithms or fancy networking.

* [What is a Game?](#what-is-a-game)
* [Game Directory](#game-directory)
* [Inter-game Compatibility](#inter-game-compatibility)
	* [API Compatibility](#api-compatibility)
	* [Groups and Aliases](#groups-and-aliases)
* [Your Turn](#your-turn)

## What is a Game?

Games are a collection of mods which work together to make a cohesive game.
A good game has a consistent underlying theme and a direction, for example
maybe it's a classic crafter miner with hard survival elements, or maybe
it's a space simulation game with a steam punk automation ascetic.

Game design is a complex topic, and is actually a whole field of expertise.
It's beyond the scope of the book to more than briefly touch on it.

## Game Directory

The structure and location of a game will seem rather familiar after working
with mods.
Games are found in a game location such as `minetest/games/<foo_game>`.

	foo_game
	├── game.conf
	├── menu
	│   ├── header.png
	│   ├── background.png
	│   └── icon.png
	├── minetest.conf
	├── mods
	│   └── ... mods
	├── README.txt
	└── settingtypes.txt

The only thing that is required is a mods folder, but `game.conf` and `menu/icon.png`
are recommended.

## Inter-game Compatibility

### API Compatibility

It's a good idea to try to keep as much API compatibility with Minetest Game as
convenient, as it'll make porting mods to another game much easier.

The best way to keep compatibility with another game is to keep API compatibility
with any mods which have the same name.
That is, if a mod uses the same name as another mod even if third party,
then it should have a compatible API.
For example, if a game includes a mod called `doors` then it should have the
same API as `doors` in Minetest Game.

API compatibility for a mod is the sum of the following things:

* Lua API table - All documented/advertised functions in the global table which shares the same name.
		For example, `mobs.register_mob`.
* Registered Nodes/Items - The presence of items.

It's probably fine to have partial breakages as long as 90% of dependency
usecases still works. For example, not having a random utility function that was
only actually used internally is ok, but not having `mobs.register_mobs` is bad.

It's difficult to maintain API compatibility with a disgusting God mega-mod like
*default* in Minetest Game, in which case the game shouldn't include a mod named
default.

API compatibility also applies to other third-party mods and games,
so try to make sure that any new mods have a unique mod name.
To check whether a mod name has been taken, search for it on
[content.minetest.net](https://content.minetest.net/).

### Groups and Aliases

Groups and Aliases are both massive tools in keeping compatibility between games,
as it allows item names to be different between different games. Common nodes
like stone and wood should have groups to indicate the material. It's also a
good idea to provide aliases from default nodes to any direct replacements.

## Your Turn

* Make a game - It can be simple, if you like.
