---
title: Node Timers and ABMs
layout: default
root: ../..
idx: 3.2
description: Learn how to make ABMs to change blocks.
redirect_from:
- /en/chapters/abms.html
- /en/map/abms.html
---

## Introduction <!-- omit in toc -->

Periodically running a function on certain nodes is a common task.
Minetest provides two methods of doing this: Active Block Modifiers (ABMs) and node timers.

ABMs scan all loaded MapBlocks looking for nodes that match a criteria.
They are best suited for nodes which are frequently found in the world,
such as grass.
They have a high CPU overhead, but a low memory and storage overhead.

For nodes that are uncommon or already use metadata, such as furnaces
and machines, node timers should be used instead.
Node timers work by keeping track of pending timers in each MapBlock, and then
running them when they expire.
This means that timers don't need to search all loaded nodes to find matches,
but instead require slightly more memory and storage for the tracking
of pending timers.

- [Node Timers](#node-timers)
- [Active Block Modifiers](#active-block-modifiers)
- [Your Turn](#your-turn)

## Node Timers

Node timers are directly tied to a single node.
You can manage node timers by obtaining a NodeTimerRef object.

```lua
local timer = minetest.get_node_timer(pos)
timer:start(10.5) -- in seconds
```

When a node timer is up, the `on_timer` method in the node's definition table will
be called. The method only takes a single parameter, the position of the node:

```lua
minetest.register_node("autodoors:door_open", {
    on_timer = function(pos)
        minetest.set_node(pos, { name = "autodoors:door" })
        return false
    end
})
```

Returning true in `on_timer` will cause the timer to run again for the same interval.
It's also possible to use `get_node_timer(pos)` inside of `on_timer`, just make
sure you return false to avoid conflict.

You may have noticed a limitation with timers: for optimisation reasons, it's
only possible to have one type of timer per node type, and only one timer running per node.


## Active Block Modifiers

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

This ABM runs every ten seconds, and for each matching node, there is
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
