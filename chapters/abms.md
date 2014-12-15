---
title: Active Block Modifiers
layout: default
root: ../
---

Introduction
------------

In this chapter we will learn how to create an **A**ctive **B**lock **M**odifier (**ABM**).
An active block modifier allows you to run code on certain nodes at certain
intervals.
Please be warned, ABMs which are too frequent or act on too many nodes cause
massive amounts of lag. Use them lightly.

* Special Growing Grass

Special Growing Grass
---------------------

We are now going to make a mod (yay!).
It will add a type of grass called alien grass - it grows near water on grassy
blocks.

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

Every ten seconds the ABM is run. Each node which has the correct nodename and
the correct neighbors then has a 1 in 5 chance of being run. If  a node is run on,
an alien grass block is placed above it. Please be warned, that will delete any
blocks above grass blocks - you should check there is space by doing minetest.get_node.

That's really all there is to ABMs. Specifying a neighbor is optional, so is chance.

Tasks
-----

* **Midas touch**: Make water turn to gold blocks with a 1 in 100 chance, every 5 seconds.
* **Decay**: Make wood turn into dirt when water is a neighbor.
* **Burnin'**: Make every air node catch on fire. (Tip: "air" and "fire:basic_flame").
  Warning: expect the game to crash.
