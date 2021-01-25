---
title: Nodes, Items, and Crafting
layout: default
root: ../..
idx: 2.1
description: Learn how to register node, items, and craft recipes using register_node, register_item, and register_craft.
redirect_from: /en/chapters/nodes_items_crafting.html
---

## Introduction <!-- omit in toc -->

Registering new nodes and craftitems, and creating craft recipes, are
basic requirements for many mods.

- [What are Nodes and Items?](#what-are-nodes-and-items)
- [Registering Items](#registering-items)
  - [Item Names](#item-names)
  - [Item Aliases](#item-aliases)
  - [Textures](#textures)
- [Registering a basic node](#registering-a-basic-node)
- [Actions and Callbacks](#actions-and-callbacks)
  - [on_use](#onuse)
- [Crafting](#crafting)
  - [Shaped](#shaped)
  - [Shapeless](#shapeless)
  - [Cooking and Fuel](#cooking-and-fuel)
- [Groups](#groups)
- [Tools, Capabilities, and Dig Types](#tools-capabilities-and-dig-types)

## What are Nodes and Items?

Nodes, craftitems, and tools are all Items.
An item is something that could be found in an inventory -
even though it may not be possible through normal gameplay.

A node is an item which can be placed or be found in the world.
Every position in the world must be occupied with one and only one node -
seemingly blank positions are usually air nodes.

A craftitem can't be placed and is only found in inventories or as a dropped item
in the world.

A tool has the ability to wear and typically has non-default digging capabilities.
In the future, it's likely that craftitems and tools will merge into one type of
item, as the distinction between them is rather artificial.

## Registering Items

Item definitions consist of an *item name* and a *definition table*.
The definition table contains attributes which affect the behaviour of the item.

```lua
minetest.register_craftitem("modname:itemname", {
    description = "My Special Item",
    inventory_image = "modname_itemname.png"
})
```

### Item Names

Every item has an item name used to refer to it, which should be in the
following format:

    modname:itemname

The modname is the name of the mod in which the item is registered, and the
item name is the name of the item itself.
The item name should be relevant to what the item is and can't already be registered.

### Item Aliases

Items can also have *aliases* pointing to their name.
An *alias* is a pseudo-item name which results in the engine treating any
occurrences of the alias as if it were the item name.
There are two main common uses of this:

* Renaming removed items to something else.
  There may be unknown nodes in the world and in inventories if an item is
  removed from a mod without any corrective code.
* Adding a shortcut. `/giveme dirt` is easier than `/giveme default:dirt`.

Registering an alias is pretty simple.
A good way to remember the order of the arguments is `from → to` where
*from* is the alias and *to* is the target.

```lua
minetest.register_alias("dirt", "default:dirt")
```

Mods need to make sure to resolve aliases before dealing directly with item names,
as the engine won't do this.
This is pretty simple though:

```lua
itemname = minetest.registered_aliases[itemname] or itemname
```

### Textures

Textures should be placed in the textures/ folder with names in the format
`modname_itemname.png`.\\
JPEG textures are supported, but they do not support transparency and are generally
bad quality at low resolutions.
It is often better to use the PNG format.

Textures in Minetest are usually 16 by 16 pixels.
They can be any resolution, but it is recommended that they are in the order of 2,
for example, 16, 32, 64, or 128.
This is because other resolutions may not be supported correctly on older devices,
resulting in decreased performance.

## Registering a basic node

```lua
minetest.register_node("mymod:diamond", {
    description = "Alien Diamond",
    tiles = {"mymod_diamond.png"},
    is_ground_content = true,
    groups = {cracky=3, stone=1}
})
```

The `tiles` property is a table of texture names the node will use.
When there is only one texture, this texture is used on every side.
To give a different texture per-side, supply the names of 6 textures in this order:

    up (+Y), down (-Y), right (+X), left (-X), back (+Z), front (-Z).
    (+Y, -Y, +X, -X, +Z, -Z)

Remember that +Y is upwards in Minetest, as is the convention with
3D computer graphics.

```lua
minetest.register_node("mymod:diamond", {
    description = "Alien Diamond",
    tiles = {
        "mymod_diamond_up.png",    -- y+
        "mymod_diamond_down.png",  -- y-
        "mymod_diamond_right.png", -- x+
        "mymod_diamond_left.png",  -- x-
        "mymod_diamond_back.png",  -- z+
        "mymod_diamond_front.png", -- z-
    },
    is_ground_content = true,
    groups = {cracky = 3},
    drop = "mymod:diamond_fragments"
    -- ^  Rather than dropping diamond, drop mymod:diamond_fragments
})
```

The is_ground_content attribute allows caves to be generated over the stone.
This is essential for any node which may be placed during map generation underground.
Caves are cut out of the world after all the other nodes in an area have generated.

## Actions and Callbacks

Minetest heavily uses a callback-based modding design.
Callbacks can be placed in the item definition table to allow response to various
different user events.

### on_use

By default, the use callback is triggered when a player left-clicks with an item.
Having a use callback prevents the item being used to dig nodes.
One common use of the use callback is for food:

```lua
minetest.register_craftitem("mymod:mudpie", {
    description = "Alien Mud Pie",
    inventory_image = "myfood_mudpie.png",
    on_use = minetest.item_eat(20),
})
```

The number supplied to the minetest.item_eat function is the number of hit points
healed when this food is consumed.
Each heart icon the player has is worth two hitpoints.
A player can usually have up to 10 hearts, which is equal to 20 hitpoints.
Hitpoints don't have to be integers (whole numbers); they can be decimals.

minetest.item_eat() is a function which returns a function, setting it
as the on_use callback.
This means the code above is roughly similar to this:

```lua
minetest.register_craftitem("mymod:mudpie", {
    description = "Alien Mud Pie",
    inventory_image = "myfood_mudpie.png",
    on_use = function(...)
        return minetest.do_item_eat(20, nil, ...)
    end,
})
```

By understanding how item_eat works by simply returning a function, it's
possible to modify it to do more complex behaviour such as play a custom sound.

## Crafting

There are several types of crafting recipe available, indicated by the `type`
property.

* shaped - Ingredients must be in the correct position.
* shapeless - It doesn't matter where the ingredients are,
  just that there is the right amount.
* cooking - Recipes for the furnace to use.
* fuel - Defines items which can be burned in furnaces.
* tool_repair - Defines items which can be tool repaired.

Craft recipes are not items, so they do not use Item Names to uniquely
identify themselves.

### Shaped

Shaped recipes are when the ingredients need to be in the right shape or
pattern to work. In the example below, the fragments need to be in a
chair-like pattern for the craft to work.

```lua
minetest.register_craft({
    type = "shaped",
    output = "mymod:diamond_chair 99",
    recipe = {
        {"mymod:diamond_fragments", "",                         ""},
        {"mymod:diamond_fragments", "mymod:diamond_fragments",  ""},
        {"mymod:diamond_fragments", "mymod:diamond_fragments",  ""}
    }
})
```

One thing to note is the blank column on the right-hand side.
This means that there *must* be an empty column to the right of the shape, otherwise
this won't work.
If this empty column shouldn't be required, then the empty strings can be left
out like so:

```lua
minetest.register_craft({
    output = "mymod:diamond_chair 99",
    recipe = {
        {"mymod:diamond_fragments", ""                       },
        {"mymod:diamond_fragments", "mymod:diamond_fragments"},
        {"mymod:diamond_fragments", "mymod:diamond_fragments"}
    }
})
```

The type field isn't actually needed for shaped crafts, as shaped is the
default craft type.

### Shapeless

Shapeless recipes are a type of recipe which is used when it doesn't matter
where the ingredients are placed, just that they're there.

```lua
minetest.register_craft({
    type = "shapeless",
    output = "mymod:diamond 3",
    recipe = {
        "mymod:diamond_fragments",
        "mymod:diamond_fragments",
        "mymod:diamond_fragments",
    },
})
```

### Cooking and Fuel

Recipes with the type "cooking" are not made in the crafting grid,
but are cooked in furnaces, or other cooking tools that might be found in mods.

```lua
minetest.register_craft({
    type = "cooking",
    output = "mymod:diamond_fragments",
    recipe = "default:coalblock",
    cooktime = 10,
})
```

The only real difference in the code is that the recipe is just a single item,
compared to being in a table (between braces).
They also have an optional "cooktime" parameter which
defines how long the item takes to cook.
If this is not set, it defaults to 3.

The recipe above works when the coal block is in the input slot,
with some form of fuel below it.
It creates diamond fragments after 10 seconds!

This type is an accompaniment to the cooking type, as it defines
what can be burned in furnaces and other cooking tools from mods.

```lua
minetest.register_craft({
    type = "fuel",
    recipe = "mymod:diamond",
    burntime = 300,
})
```

They don't have an output like other recipes, but they have a burn time
which defines how long they will last as fuel in seconds.
So, the diamond is good as fuel for 300 seconds!

## Groups

Items can be members of many groups and groups can have many members.
Groups are defined using the `groups` property in the definition table
and have an associated value.

```lua
groups = {cracky = 3, wood = 1}
```

There are several reasons you use groups.
Firstly, groups are used to describe properties such as dig types and flammability.
Secondly, groups can be used in a craft recipe instead of an item name to allow
any item in the group to be used.

```lua
minetest.register_craft({
    type = "shapeless",
    output = "mymod:diamond_thing 3",
    recipe = {"group:wood", "mymod:diamond"}
})
```

## Tools, Capabilities, and Dig Types

Dig types are groups which are used to define how strong a node is when dug
with different tools.
A dig type group with a higher associated value means the node is easier
and quicker to cut.
It's possible to combine multiple dig types to allow the more efficient use
of multiple types of tools.
A node with no dig types cannot be dug by any tools.


| Group  | Best Tool | Description |
|--------|-----------|-------------|
| crumbly | spade    | Dirt, sand |
| cracky | pickaxe   | Tough (but brittle) stuff like stone |
| snappy | *any*       | Can be cut using fine tools;<br>e.g. leaves, smallplants, wire, sheets of metal  |
| choppy | axe | Can be cut using a sharp force; e.g. trees, wooden planks |
| fleshy | sword | Living things like animals and the player.<br>This could imply some blood effects when hitting. |
| explody | ? | Especially prone to explosions  |
| oddly_breakable_by_hand | *any* | Torches and such - very quick to dig |


Every tool has a tool capability.
A capability includes a list of supported dig types, and associated properties
for each type such as dig times and the amount of wear.
Tools can also have a maximum supported hardness for each type, which makes
it possible to prevent weaker tools from digging harder nodes.
It's very common for tools to include all dig types in their capabilities,
with the less suitable ones having very inefficient properties.
If the item a player is currently wielding doesn't have an explicit tool
capability, then the capability of the current hand is used instead.

```lua
minetest.register_tool("mymod:tool", {
    description = "My Tool",
    inventory_image = "mymod_tool.png",
    tool_capabilities = {
        full_punch_interval = 1.5,
        max_drop_level = 1,
        groupcaps = {
            crumbly = {
                maxlevel = 2,
                uses = 20,
                times = { [1]=1.60, [2]=1.20, [3]=0.80 }
            },
        },
        damage_groups = {fleshy=2},
    },
})
```

Groupcaps is the list of supported dig types for digging nodes.
Damage groups are for controlling how tools damage objects, which will be
discussed later in the Objects, Players, and Entities chapter.
