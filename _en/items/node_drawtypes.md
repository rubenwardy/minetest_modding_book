---
title: Node Drawtypes
layout: default
root: ../..
idx: 2.3
description: Guide to all drawtypes, including node boxes/nodeboxes and mesh nodes.
redirect_from: /en/chapters/node_drawtypes.html
---

## Introduction

In this chapter we explain all the different types of node drawtypes there are.

First of all, what is a drawtype?
A drawtype defines how the node is to be drawn.
A torch looks different to water, water looks different to stone.

The string you use to determine the drawtype in the node definition is the same as
the title of the sections, except in lower case.

* [Normal](#normal)
* [Airlike](#airlike)
* [Liquid](#liquid)
    * [FlowingLiquid](#flowingliquid)
* [Glasslike](#glasslike)
* [Glasslike_Framed](#glasslike_framed)
    * [Glasslike_Framed_Optional](#glasslike_framed_optional)
* [Allfaces](#allfaces)
    * [Allfaces_Optional](#allfaces_optional)
* [Torchlike](#torchlike)
* [Nodebox](#nodebox)
* [Mesh](#mesh)
* [Signlike](#signlike)
* [Plantlike](#plantlike)
* [Firelike](#firelike)

This article is not complete yet. The following drawtypes are missing:

* Fencelike
* Plantlike rooted
* Raillike

## Normal

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_normal.png" alt="Normal Drawtype">
    <figcaption>
        Normal Drawtype
    </figcaption>
</figure>

This is, well, the normal drawtypes.
Nodes that use this will be cubes with textures for each side, simple-as.\\
Here is the example from the [Nodes, Items and Crafting](nodes_items_crafting.html#registering-a-basic-node) chapter.
Notice how you don't need to declare the drawtype.

```lua
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
```


## Airlike

These nodes are see through and thus have no textures.

```lua
minetest.register_node("myair:air", {
    description = "MyAir (you hacker you!)",
    drawtype = "airlike",

    paramtype = "light",
    -- ^ Allows light to propagate through the node with the
    --   light value falling by 1 per node.

    sunlight_propagates = true, -- Sunlight shines through
    walkable     = false, -- Would make the player collide with the air node
    pointable    = false, -- You can't select the node
    diggable     = false, -- You can't dig the node
    buildable_to = true,  -- Nodes can be replace this node.
                          -- (you can place a node and remove the air node
                          -- that used to be there)

    air_equivalent = true,
    drop = "",
    groups = {not_in_creative_inventory=1}
})
```

## Liquid

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_liquid.png" alt="Liquid Drawtype">
    <figcaption>
        Liquid Drawtype
    </figcaption>
</figure>

These nodes are complete liquid nodes, the liquid flows outwards from position
using the flowing liquid drawtype.
For each liquid node you should also have a flowing liquid node.

```lua
-- Some properties have been removed as they are beyond
--  the scope of this chapter.
minetest.register_node("default:water_source", {
    drawtype = "liquid",
    paramtype = "light",

    inventory_image = minetest.inventorycube("default_water.png"),
    -- ^ this is required to stop the inventory image from being animated

    tiles = {
        {
            name = "default_water_source_animated.png",
            animation = {
                type     = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length   = 2.0
            }
        }
    },

    special_tiles = {
        -- New-style water source material (mostly unused)
        {
            name      = "default_water_source_animated.png",
            animation = {type = "vertical_frames", aspect_w = 16,
                aspect_h = 16, length = 2.0},
            backface_culling = false,
        }
    },

    --
    -- Behavior
    --
    walkable     = false, -- The player falls through
    pointable    = false, -- The player can't highlight it
    diggable     = false, -- The player can't dig it
    buildable_to = true,  -- Nodes can be replace this node

    alpha = 160,

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
    -- ^ how fast

    liquid_range = 8,
    -- ^ how far

    post_effect_color = {a=64, r=100, g=100, b=200},
    -- ^ colour of screen when the player is submerged
})
```

### FlowingLiquid

See default:water_flowing in the default mod in minetest_game, it is mostly
the same as the above example.

## Glasslike

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_glasslike.png" alt="Glasslike Drawtype">
    <figcaption>
        Glasslike Drawtype
    </figcaption>
</figure>

When you place multiple glasslike nodes together, you'll notice that the internal
edges are hidden, like this:

<figure>
    <img src="{{ page.root }}//static/drawtype_glasslike_edges.png" alt="Glasslike's Edges">
    <figcaption>
        Glasslike's Edges
    </figcaption>
</figure>

```lua
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
```

## Glasslike_Framed

This makes the node's edge go around the whole thing with a 3D effect, rather
than individual nodes, like the following:

<figure>
    <img src="{{ page.root }}//static/drawtype_glasslike_framed.png" alt="Glasslike_framed's Edges">
    <figcaption>
        Glasslike_Framed's Edges
    </figcaption>
</figure>

```lua
minetest.register_node("default:glass", {
    description = "Glass",
    drawtype = "glasslike_framed",

    tiles = {"default_glass.png", "default_glass_detail.png"},
    inventory_image = minetest.inventorycube("default_glass.png"),

    paramtype = "light",
    sunlight_propagates = true, -- Sunlight can shine through block
    is_ground_content = false, -- Stops caves from being generated over this node.

    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    sounds = default.node_sound_glass_defaults()
})
```

### Glasslike_Framed_Optional

"optional" drawtypes need less rendering time if deactivated on the client's side.

## Allfaces

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_allfaces.png" alt="Allfaces drawtype">
    <figcaption>
        Allfaces drawtype
    </figcaption>
</figure>

Allfaces are nodes which show all of their faces, even if they're against
another node. This is mainly used by leaves as you don't want a gaping space when
looking through the transparent holes, but instead a nice leaves effect.

```lua
minetest.register_node("default:leaves", {
    description = "Leaves",
    drawtype = "allfaces_optional",
    tiles = {"default_leaves.png"}
})
```

### Allfaces_Optional

Allows clients to disable it using `new_style_leaves = 0`, requiring less rendering time.

TorchLike
---------

TorchLike nodes are 2D nodes which allow you to have different textures
depending on whether they are placed against a wall, on the floor, or on the ceiling.

TorchLike nodes are not restricted to torches, you could use them for switches or other
items which need to have different textures depending on where they are placed.

```lua
minetest.register_node("foobar:torch", {
    description = "Foobar Torch",
    drawtype = "torchlike",
    tiles = {
        {"foobar_torch_floor.png"},
        {"foobar_torch_ceiling.png"},
        {"foobar_torch_wall.png"}
    },
    inventory_image = "foobar_torch_floor.png",
    wield_image = "default_torch_floor.png",
    light_source = LIGHT_MAX-1,

    -- Determines how the torch is selected, ie: the wire box around it.
    -- each value is { x1, y1, z1, x2, y2, z2 }
    -- (x1, y1, y1) is the bottom front left corner
    -- (x2, y2, y2) is the opposite - top back right.
    -- Similar to the nodebox format.
    selection_box = {
        type = "wallmounted",
        wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
        wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
        wall_side = {-0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1},
    }
})
```

## Nodebox

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_nodebox.gif" alt="Nodebox drawtype">
    <figcaption>
        Nodebox drawtype
    </figcaption>
</figure>

Nodeboxes allow you to create a node which is not cubic, but is instead made out
of as many cuboids as you like.

```lua
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
```

The most important part is the nodebox table:

```lua
{-0.5, -0.5, -0.5,       0.5,    0,  0.5},
{-0.5,    0,    0,       0.5,  0.5,  0.5}
```

Each row is a cuboid which are joined to make a single node.
The first three numbers are the co-ordinates, from -0.5 to 0.5 inclusive, of
the bottom front left most corner, the last three numbers are the opposite corner.
They are in the form X, Y, Z, where Y is up.

`paramtype = "light"` allows light to propagate from or through the node
with light value.

You can use the [NodeBoxEditor](https://forum.minetest.net/viewtopic.php?f=14&t=2840) to
create node boxes by dragging the edges, it is more visual than doing it by hand.

### Wallmounted Nodebox

Sometimes you want different nodeboxes for when it is placed on the floor, wall, or ceiling like with torches.

```lua
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
```

## Mesh

Whilst node boxes are generally easier to make, they are limited in that
they can only consist of cuboids. Node boxes are also unoptimised;
Inner faces will still be rendered even when they're completely hidden.

A face is a flat surface on a mesh. An inner face occurs when the faces of two
different node boxes overlap, causing parts of the node box model to be
invisible but still rendered.

You can register a mesh node as so:

```lua
minetest.register_node("mymod:meshy", {
    drawtype = "mesh",

    -- Holds the texture for each "material"
    tiles = {
        "mymod_meshy.png"
    },

    -- Path to the mesh
    mesh = "mymod_meshy.b3d",    
})
```

Make sure that the mesh is available in a `models` directory.
Most of the time the mesh should be in your mod's folder, however it's okay to
share a mesh provided by another mod you depend on. For example, a mod that
adds more types of furniture may want to share the model provided by a basic
furniture mod.

## Signlike

Signlike nodes are flat nodes with can be mounted on the sides of other nodes.

Despite the name of this drawtype, signs don't actually tend to use signlike but
instead use the `nodebox` drawtype to provide a 3D effect. The `signlike` drawtype
is, however, commonly used by ladders.

```lua
minetest.register_node("default:ladder_wood", {    
    drawtype = "signlike",

    tiles = {"default_ladder_wood.png"},

    -- Required: store the rotation in param2
    paramtype2 = "wallmounted",

    selection_box = {
        type = "wallmounted",
    },
})
```

## Plantlike

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_plantlike.png" alt="Plantlike Drawtype">
    <figcaption>
        Plantlike Drawtype
    </figcaption>
</figure>

Plantlike nodes draw their tiles in an X like pattern.

```lua
minetest.register_node("default:papyrus", {
    drawtype = "plantlike",

    -- Only one texture used
    tiles = {"default_papyrus.png"},

    selection_box = {
        type = "fixed",
        fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
    },
})
```

## Firelike

Firelike is similar to plantlike, except that it is designed to "cling" to walls
and ceilings.

<figure>
    <img src="{{ page.root }}//static/drawtype_firelike.png" alt="Firelike nodes">
    <figcaption>
        Firelike nodes
    </figcaption>
</figure>

```lua
minetest.register_node("mymod:clingere", {
    drawtype = "firelike",

    -- Only one texture used
    tiles = { "mymod:clinger" },
})
```
