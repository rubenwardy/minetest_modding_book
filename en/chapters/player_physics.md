---
title: Player Physics
layout: default
root: ../../
---

## Introduction

Player physics can be modified using physics overrides. Physics overrides can set the
walking speed, jump speed and gravity constants. Physics overrides are set on a player
by player basis, and are multipliers - a value of 2 for gravity would make gravity twice
as strong.

* Basic Interface
* Your Turn

## Basic Interface

Here is an example which adds an antigravity command, which
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

### Possible Overrides

player:set_physics_override() is given a table of overrides.\\
According to [lua_api.txt](../lua_api.html#player-only-no-op-for-other-objects),
these can be:

* speed: multiplier to default walking speed value (default: 1)
* jump: multiplier to default jump value (default: 1)
* gravity: multiplier to default gravity value (default: 1)
* sneak: whether player can sneak (default: true)
* sneak_glitch: whether player can use the sneak glitch (default: true)

The sneak glitch allows the player to climb an 'elevator' made out of
a certain placement of blocks by sneaking (pressing shift) and pressing
space to ascend. It was originally a bug in Minetest, but was kept as
it is used on many servers to get to higher levels.
They added the option above so you can disable it.

### Multiple mods

Please be warned that mods that override the same physics values of a player tend
to be incompatible with each other. When setting an override, it overwrites
any overrides that have been set before, by your or anyone else's mod.

## Your Turn

* **sonic**: Set the speed multiplayer to a high value (at least 6) when a player joins the game.
* **super bounce**: Increase the jump value so that the player can jump up 20 meters (1 meter is 1 block).
* **space**: Make the gravity decrease as the player gets higher and higher up.
