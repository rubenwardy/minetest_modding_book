---
title: Active Block Modifiers
layout: default
root: ../..
idx: 3.2
description: Learn how to make ABMs to change blocks.
redirect_from: /en/chapters/abms.html
---

## Introduction

An **A**ctive **B**lock **M**odifier (**ABM**) allows you to run code on
certain nodes at specific intervals.

Please be warned, ABMs which are too frequent or act on many nodes
cause massive amounts of lag. Use them sparingly.

* [Example: Growing Alien Grass](#example-growing-alien-grass)
* [Your Turn](#your-turn)

## Example: Growing Alien Grass

Alien grass, for the purposes of this chapter, is a type of grass which
has a chance to appear near water.

To create it, you first need to register the grass, then
write an ABM.

{% highlight lua %}
minetest.register_node("aliens:grass", {
    description = "Alien Grass",
    light_source = 3, -- The node radiates light. Values can be from 1 to 15
    tiles = {"aliens_grass.png"},
    groups = {choppy=1},
    on_use = minetest.item_eat(20)
})

minetest.register_abm({
    nodenames = {"default:dirt_with_grass"},
    neighbors = {"default:water_source", "default:water_flowing"},
    interval = 10.0, -- Run every 10 seconds
    chance = 50, -- Select every 1 in 50 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
        minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "aliens:grass"})
    end
})
{% endhighlight %}

This ABM runs every ten seconds. There is a 1 in 5 chance of the ABM running on each
node that has the correct name and the correct neighbours. If the ABM runs on a
node, an alien grass node is placed above it. Please be warned, this will delete any
node previously located in that position. To prevent this you should include a check
using minetest.get_node to make sure there is space for the grass.

Specifying a neighbour is optional. If you specify multiple neighbours, only one of them
needs to be present to meet the requirements.

Specifying chance is also optional. If you don't specify the chance, the ABM will
always run when the other conditions are met.

## Your Turn

* **Midas touch**: Make water turn to gold blocks with a 1 in 100 chance, every 5 seconds.
* **Decay**: Make wood turn into dirt when water is a neighbour.
* **Burnin'**: Make every air node catch on fire. (Tip: "air" and "fire:basic_flame").
  Warning: expect the game to crash.
