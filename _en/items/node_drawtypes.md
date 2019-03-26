---
title: Node Drawtypes
layout: default
root: ../..
idx: 2.3
description: Guide to all drawtypes, including node boxes/nodeboxes and mesh nodes.
redirect_from: /en/chapters/node_drawtypes.html
---

## Introduction

The method by which a node is drawn is called a *drawtype*. There are many
available drawtypes. The behaviour of a drawtype can be controlled
by providing properties in the node type definition. These properties
are fixed for all instances of this node. It is possible to control some properties
per-node using something called `param2`.

In the previous chapter, the concept of nodes and items was introduced, but a
full definition of a node wasn't given. The Minetest world is a 3D grid of
positions. Each position is called a node, and consists of the node type
(name) and two parameters (param1 and param2). The function
`minetest.register_node` is a bit misleading in that it doesn't actually
register a node - it registers a new *type* of node.

The node params are used to control how a node is individually rendered.
`param1` is used to store the lighting of a node, and the meaning of
`param2` depends on the `paramtype2` property of the node type definition.

* [Cubic Nodes: Normal and Allfaces](#cubic-nodes-normal-and-allfaces)
* [Glasslike Nodes](#glasslike-nodes)
    * [Glasslike_Framed](#glasslike_framed)
* [Airlike Nodes](#airlike-nodes)
* [Lighting and Sunlight Propagation](#lighting-and-sunlight-propagation)
* [Liquid Nodes](#liquid-nodes)
* [Node Boxes](#node-boxes)
    * [Wallmounted Node Boxes](#wallmounted-node-boxes)
* [Mesh Nodes](#mesh-nodes)
* [Signlike Nodes](#signlike-nodes)
* [Plantlike Nodes](#plantlike-Nodes)
* [Firelike Nodes](#firelike-nodes)
* [More Drawtypes](#more-drawtypes)


## Cubic Nodes: Normal and Allfaces

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_normal.png" alt="Normal Drawtype">
    <figcaption>
        Normal Drawtype
    </figcaption>
</figure>

The normal drawtype is typically used to render a cubic node.
If the side of a normal node is against a solid side, then that side won't be rendered,
resulting in a large performance gain.

In contrast, the allfaces drawtype will still render the inner side when up against
a solid node. This is good for nodes with partially transparent sides, such as
leaf nodes. You can use the allfaces_optional drawtype to allow users to opt-out
of the slower drawing, in which case it'll act like a normal node.

```lua
minetest.register_node("mymod:diamond", {
    description = "Alien Diamond",
    tiles = {"mymod_diamond.png"},
    groups = {cracky = 3},
})

minetest.register_node("default:leaves", {
    description = "Leaves",
    drawtype = "allfaces_optional",
    tiles = {"default_leaves.png"}
})
```

Note: the normal drawtype is the default drawtype, so you don't need to explicitly
specify it.


## Glasslike Nodes

The difference between glasslike and normal nodes is that placing a glasslike node
next to a normal node won't cause the side of the normal node to be hidden.
This is useful because glasslike nodes tend to be transparent, and so using a normal
drawtype would result in the ability to see through the world.

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

### Glasslike_Framed

This makes the node's edge go around the whole thing with a 3D effect, rather
than individual nodes, like the following:

<figure>
    <img src="{{ page.root }}//static/drawtype_glasslike_framed.png" alt="Glasslike_framed's Edges">
    <figcaption>
        Glasslike_Framed's Edges
    </figcaption>
</figure>

You can use the glasslike_framed_optional drawtype to allow the user to *opt-in*
to the framed appearance.

```lua
minetest.register_node("default:glass", {
    description = "Glass",
    drawtype = "glasslike_framed",
    tiles = {"default_glass.png", "default_glass_detail.png"},
    inventory_image = minetest.inventorycube("default_glass.png"),
    paramtype = "light",
    sunlight_propagates = true, -- Sunlight can shine through block
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    sounds = default.node_sound_glass_defaults()
})
```


## Airlike Nodes

These nodes are not rendered, and thus have no textures.

```lua
minetest.register_node("myair:air", {
    description = "MyAir (you hacker you!)",
    drawtype = "airlike",
    paramtype = "light",
    sunlight_propagates = true,

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


## Lighting and Sunlight Propagation

The lighting of a node is stored in param1. In order to work out how to shade
a node's side, the light value of the neighbouring node is used.
Because of this, solid nodes don't have light values because they block light.

By default, a node type won't allow light to be stored in any node instances.
It's usually desirable for some nodes such as glass and air to be able to
let light through. To do this, there are two properties which need to be defined:

```lua
paramtype = "light",
sunlight_propagates = true,
```

The first line means that param1 does, in fact, store the light level.
The second line means that sunlight should go through this node without decreasing in value.


## Liquid Nodes

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_liquid.png" alt="Liquid Drawtype">
    <figcaption>
        Liquid Drawtype
    </figcaption>
</figure>

Each type of liquid requires two node definitions - one for the liquid source, and
another for flowing liquid.

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

Flowing nodes have a similar definition, but with a different name and animation.
See default:water_flowing in the default mod in minetest_game for a full example.


## Node Boxes

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_nodebox.gif" alt="Nodebox drawtype">
    <figcaption>
        Nodebox drawtype
    </figcaption>
</figure>

Node boxes allow you to create a node which is not cubic, but is instead made out
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

You can use the [NodeBoxEditor](https://forum.minetest.net/viewtopic.php?f=14&t=2840) to
create node boxes by dragging the edges, it is more visual than doing it by hand.


### Wallmounted Node Boxes

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

## Mesh Nodes

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


## Signlike Nodes

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


## Plantlike Nodes

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

## Firelike Nodes

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

## More Drawtypes

This is not a comprehensive list, there's more types including:

* Fencelike
* Plantlike rooted - for underwater plants
* Raillike - for cart tracks
* Torchlike - for 2D wall/floor/ceiling nodes.
  The torches in Minetest Game actually use two different node definitions of
  mesh nodes (default:torch and default:torch_wall).

As always, read the [Lua API documentation](../../lua_api.html#node-drawtypes)
for the complete list.
