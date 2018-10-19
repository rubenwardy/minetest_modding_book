---
title: Active Block Modifiers
layout: default
root: ../..
idx: 3.2
description: Learn how to make ABMs to change blocks.
redirect_from: /en/chapters/abms.html
---

## Introduction

An Active Block Modifier (ABM) is a method of periodically running a
function on nodes matching specific criteria.
As the name implies, this only works on loaded MapBlocks.

ABMs are best suited for nodes which are frequently found in the world,
such as grass.
ABMs have a high CPU overhead, as Minetest needs to scan all Active Blocks
to find matching nodes, but they have a low memory and storage overhead.

For nodes which are uncommon or already use metadata, such as furnaces
and machines, node timers should be used instead.
Node timers don't involve searching all loaded nodes to find matches,
but instead require slightly more memory and storage for the tracking
of running timers.


* [Registering an ABM](#registering-an-abm)
* [Your Turn](#your-turn)

## Registering an ABM

Alien grass, for the purposes of this chapter, is a type of grass which
has a chance to appear near water.


```lua
minetest.register_node("aliens:grass", {
    description = "Alien Grass",
    light_source = 3, -- The node radiates light. Min 0, max 14
    tiles = {"aliens_grass.png"},
    groups = {choppy=1},
    on_use = minetest.item_eat(20)
})

minetest.register_abm({
    nodenames = {"default:dirt_with_grass"},
    neighbors = {"default:water_source", "default:water_flowing"},
    interval = 10.0, -- Run every 10 seconds
    chance = 50, -- Select every 1 in 50 nodes
    action = function(pos, node, active_object_count,
            active_object_count_wider)
        local pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        minetest.set_node(pos, {name = "aliens:grass"})
    end
})
```

This ABM runs every ten seconds, and for each matching node there is
a 1 in 50 chance of it running.
If the ABM runs on a node, an alien grass node is placed above it.
Please be warned, this will delete any node previously located in that position.
To prevent this you should include a check using minetest.get_node to make sure there is space for the grass.

Specifying a neighbour is optional.
If you specify multiple neighbours, only one of them needs to be
present to meet the requirements.

Specifying chance is also optional.
If you don't specify the chance, the ABM will always run when the other conditions are met.

## Your Turn

* Midas touch: Make water turn to gold blocks with a 1 in 100 chance, every 5 seconds.
* Decay: Make wood turn into dirt when water is a neighbour.
* Burnin': Make every air node catch on fire. (Tip: "air" and "fire:basic_flame").
  Warning: expect the game to crash.
