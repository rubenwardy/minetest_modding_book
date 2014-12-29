---
title: Node Drawtypes
layout: default
root: ../
---

Introduction
------------

In this chapter we explain all the different types of node drawtypes there are.

First of, what is a drawtype? A drawtype defines how the node is drawn onto the screen,
they are sent along with the node definition to the client where

* Normal
* Airlike
* Glasslike
* Glasslike_Framed
	* Glasslike_Framed_Optional
* Allfaces
	* Allfaces_Optional
* Torchlike
* Nodebox

This article is not complete yet. These drawtypes are missing:

* Signlike
* Plantlike
* Firelike
* Fencelike
* Raillike
* Mesh

Normal
------

<figure class="right_image">
	<img src="{{ page.root }}/static/drawtype_normal.png" alt="Normal Drawtype">
	<figcaption>
		Normal Drawtype
	</figcaption>
</figure>

This is, well, the normal drawtypes.
Nodes that use this will be cubes with textures for each side, simple-as.\\
Here is the example from the [Nodes, Items and Crafting](nodes_items_crafting.html#registering-a-basic-node) chapter.
Notice how you don't need to declare the drawtype.

{% highlight lua %}
minetest.register_node("mymod:diamond", {
	description = "Alien Diamond",
	tiles = {
		"mymod_diamond_up.png",
		"mymod_diamond_down.png",
		"mymod_diamond_right.png",
		"mymod_diamond_left.png",
		"mymod_diamond_back.png",
		"mymod_diamond_front.png"
	},
	is_ground_content = true,
	groups = {cracky = 3},
	drop = "mymod:diamond_fragments"
})
{% endhighlight %}


Airlike
-------

These nodes are see through, and thus have no textures.

Liquid
------

<figure class="right_image">
	<img src="{{ page.root }}/static/drawtype_liquid.png" alt="Liquid Drawtype">
	<figcaption>
		Liquid Drawtype
	</figcaption>
</figure>

These nodes are complete liquid nodes, the liquid flows outwards from position using the flowing liquid drawtype.
For each liquid node you should also have a flowing liquid node.

{% highlight lua %}
-- Some properties have been removed as they are beyond the scope of this chapter.
minetest.register_node("default:water_source", {
	drawtype = "liquid",
	paramtype = "light",
	-- ^ light goes through node

	inventory_image = minetest.inventorycube("default_water.png"),
	-- ^ this is required to stop the inventory image from being animated
	tiles = {
		{
			name = "default_water_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w=16,
				aspect_h=16,
				length=2.0
			}
		}
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name="default_water_source_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0},
			backface_culling = false,
		}
	},

	--
	-- Behavior
	--
	walkable = false,    -- The player falls through
	pointable = false,   -- The player can't highlight it
	diggable = false,    -- The player can't dig it
	buildable_to = true, -- The player can't build on it

	alpha = WATER_ALPHA,

	--
	-- Liquid Properties
	--
	drowning = 1,
	liquidtype = "source",

	liquid_alternative_flowing = "default:water_flowing",
	-- ^ when the liquid is flowing

	liquid_alternative_source = "default:water_source",
	-- ^ when the liquid is a source

	liquid_viscosity = WATER_VISC,
	-- ^ how far

	post_effect_color = {a=64, r=100, g=100, b=200},
	-- ^ color of screen when the player is submerged
})
{% endhighlight %}

### Flowing Liquids

See default:water_flowing in the default mod in minetest_game, it is mostly
the same as the above example

Glasslike
---------

<figure class="right_image">
	<img src="{{ page.root }}/static/drawtype_glasslike.png" alt="Glasslike Drawtype">
	<figcaption>
		Glasslike Drawtype
	</figcaption>
</figure>

When you place multiple glasslike nodes together, you'll notice that the internal
edges are hidden, like this:

<figure>
	<img src="{{ page.root }}/static/drawtype_glasslike_edges.png" alt="Glasslike's Edges">
	<figcaption>
		Glasslike's Edges
	</figcaption>
</figure>

{% highlight lua %}
minetest.register_node("default:obsidian_glass", {
	description = "Obsidian Glass",
	drawtype = "glasslike",
	tiles = {"default_obsidian_glass.png"},
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	sounds = default.node_sound_glass_defaults(),
	groups = {cracky=3,oddly_breakable_by_hand=3},
})
{% endhighlight %}

Glasslike_Framed
----------------

<figure class="right_image">
	<img src="{{ page.root }}/static/drawtype_glasslike.png" alt="Glasslike_Framed drawtype">
	<figcaption>
		Glasslike_Framed
	</figcaption>
</figure>

This makes the node's edge go around the whole thing, rather than individual nodes,
like the following:

<figure>
	<img src="{{ page.root }}/static/drawtype_glasslike_framed.png" alt="Glasslike_framed's Edges">
	<figcaption>
		Glasslike_Framed's Edges
	</figcaption>
</figure>

{% highlight lua %}
minetest.register_node("default:glass", {
	description = "Glass",
	drawtype = "glasslike_framed",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	inventory_image = minetest.inventorycube("default_glass.png"),
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})
{% endhighlight %}

### Glasslike_Framed_Optional

"optional" drawtypes need less rendering time if deactivated on the client's side.

Allfaces
--------

<figure class="right_image">
	<img src="{{ page.root }}/static/drawtype_allfaces.png" alt="Allfaces drawtype">
	<figcaption>
		Allfaces drawtype
	</figcaption>
</figure>

Allfaces nodes show every single face of the cube, even if sides are
up against another node (which would normally be hidden).
They are mainly used for leaves.

{% highlight lua %}
minetest.register_node("default:leaves", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	tiles = {"default_leaves.png"}
})
{% endhighlight %}

### Allfaces_Optional

"optional" drawtypes need less rendering time if deactivated on the client's side.

TorchLike
---------

TorchLike allows you to have different textures when placed against a wall,
on the floor or on the ceiling.

{% highlight lua %}
minetest.register_node("default:torch", {
	description = "Torch",
	drawtype = "torchlike",
	tiles = {
		{
			name = "default_torch_on_floor_animated.png",
			animation = {
				type     = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length   = 3.0
			}
		},
		{
			name = "default_torch_on_ceiling_animated.png",
			animation = {
				type     = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length   = 3.0
			}
		},
		{
			name = "default_torch_animated.png",
			animation = {
				type     = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length   = 3.0
			}
		}
	},
	inventory_image = "default_torch_on_floor.png",
	wield_image = "default_torch_on_floor.png",
	light_source = LIGHT_MAX-1,
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1},
	}
})
{% endhighlight %}

Nodebox
-------

<figure class="right_image">
	<img src="{{ page.root }}/static/drawtype_nodebox.gif" alt="Nodebox drawtype">
	<figcaption>
		Nodebox drawtype
	</figcaption>
</figure>

Nodeboxes allow you to create a node which is not cubic, but is instead made out
of as many cuboids as you like.

{% highlight lua %}
minetest.register_node("stairs:stair_stone", {
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	}
})
{% endhighlight %}

The most important part is the nodebox table:

{% highlight lua %}
{-0.5, -0.5, -0.5,       0.5,    0,  0.5},
{-0.5,    0,    0,       0.5,  0.5,  0.5}
{% endhighlight %}

Each row is a cubiod which are joined to make a single node.
The first three numbers are the co-ordinates, from -0.5 to 0.5 inclusive, of
the bottom front left most corner, the last three numbers are the opposite corner.
They are in the form X, Y, Z, where Y is up.

You can use the [NodeBoxEditor](https://forum.minetest.net/viewtopic.php?f=14&t=2840) to
create node boxes by dragging the edges, it is more visual than doing it by hand.

### Wallmounted Nodebox

Sometimes you want different nodeboxes for when it is place on the floor, wall and
ceiling, like with torches.

{% highlight lua %}
minetest.register_node("default:sign_wall", {
	drawtype = "nodebox",
	node_box = {
		type = "wallmounted",

		-- Ceiling
		wall_top    = {
			{-0.4375, 0.4375, -0.3125, 0.4375, 0.5, 0.3125}
		},

		-- Floor
		wall_bottom = {
			{-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125}
		},

		-- Wall
		wall_side   = {
			{-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375}
		}
	},
})
{% endhighlight %}


{% highlight lua %}
{% endhighlight %}


