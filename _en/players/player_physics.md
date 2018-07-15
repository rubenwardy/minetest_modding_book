---
title: Player Physics
layout: default
root: ../../
idx: 4.4
redirect_from: /en/chapters/player_physics.html
---

## Introduction

Player physics can be modified using physics overrides. Physics overrides can set the
walking speed, jump speed and gravity constants. Physics overrides are set on a player
by player basis, and are multipliers. For example, a value of 2 for gravity would make
gravity twice as strong.

* [Basic Example](#basic_example)
* [Available Overrides](#available_overrides)
* [Mod Incompatibility ](#mod_incompatibility)
* [Your Turn](#your_turn)

## Basic Example

Here is an example of how to add an antigravity command, which
puts the caller in low G:

{% highlight lua %}
minetest.register_chatcommand("antigravity", {
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        player:set_physics_override({
            gravity = 0.1 -- set gravity to 10% of its original value
                          -- (0.1 * 9.81)
        })
    end
})
{% endhighlight %}

## Available Overrides

player:set_physics_override() is given a table of overrides.\\
According to [lua_api.txt]({{ page.root }}lua_api.html#player-only-no-op-for-other-objects),
these can be:

* speed: multiplier to default walking speed value (default: 1)
* jump: multiplier to default jump value (default: 1)
* gravity: multiplier to default gravity value (default: 1)
* sneak: whether player can sneak (default: true)

### Old Movement Behaviour

Player movement prior to the 0.4.16 release included the sneak glitch, which
allows various movement glitches, including the ability
to climb an 'elevator' made from a certain placement of nodes by sneaking
(pressing shift) and pressing space to ascend. Though the behaviour was
unintended, it has been preserved in overrides due to its use on many servers.

Two overrides are needed to fully restore old movement behaviour:

* new_move: whether the player uses new movement (default: true)
* sneak_glitch: whether the player can use 'sneak elevators' (default: false)

## Mod Incompatibility

Please be warned that mods which override the same physics value of a player tend
to be incompatible with each other. When setting an override, it overwrites
any overrides that have been set before. This means that if multiple overrides set a
player's speed, only the last one to run will be in effect.

## Your Turn

* **Sonic**: Set the speed multiplier to a high value (at least 6) when a player joins the game.
* **Super bounce**: Increase the jump value so that the player can jump 20 meters (1 meter is 1 node).
* **Space**: Make gravity decrease as the player gets higher.
