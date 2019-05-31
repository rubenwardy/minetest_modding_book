---
title: ItemStacks and Inventories
layout: default
root: ../..
idx: 2.4
description: Manipulate InvRefs and ItemStacks
redirect_from:
- /en/chapters/inventories.html
- /en/chapters/itemstacks.html
- /en/inventories/inventories.html
- /en/inventories/itemstacks.html
---

## Introduction  <!-- omit in toc -->

In this chapter, you will learn how to use and manipulate inventories, whether
that be a player inventory, a node inventory, or a detached inventory.

- [What are ItemStacks and Inventories?](#what-are-itemstacks-and-inventories)
- [ItemStacks](#itemstacks)
- [Inventory Locations](#inventory-locations)
- [Lists](#lists)
  - [Size and Width](#size-and-width)
  - [Checking Contents](#checking-contents)
- [Modifying Inventories and ItemStacks](#modifying-inventories-and-itemstacks)
  - [Adding to a List](#adding-to-a-list)
  - [Taking Items](#taking-items)
  - [Manipulating Stacks](#manipulating-stacks)
- [Wear](#wear)
- [Lua Tables](#lua-tables)

## What are ItemStacks and Inventories?

An ItemStack is the data behind a single cell in an inventory.

An *inventory* is a collection of *inventory lists*, each of which
is a 2D grid of ItemStacks.
Inventory lists are simply called *lists* in the context
of inventories.
The point of an inventory is to allow multiple grids when Players
and Nodes only have at most one inventory in them.

## ItemStacks

ItemStacks have three components to them.

The item name may be the item name of a registered item, an alias, or an unknown
item name.
Unknown items are common when users uninstall mods, or when mods remove items without
precautions, such as registering aliases.

```lua
print(stack:get_name())
stack:set_name("default:dirt")

if not stack:is_known() then
    print("Is an unknown item!")
end
```

The count will always be 0 or greater.
Through normal gameplay, the count should be no more than the maximum stack size
of the item - `stack_max`.
However, admin commands and buggy mods may result in stacks exceeding the maximum
size.

```lua
print(stack:get_stack_max())
```




An ItemStack can be empty, in which case the count will be 0.

```lua
print(stack:get_count())
stack:set_count(10)
```

ItemStacks can be constructed in multiple ways using the ItemStack function.

```lua
ItemStack() -- name="", count=0
ItemStack("default:pick_stone") -- count=1
ItemStack("default:stone 30")
ItemStack({ name = "default:wood", count = 10 })
```

Item metadata is an unlimited key-value store for data about the item.
Key-value means that you use a name (called the key) to access the data (called the value).
Some keys have special meaning, such as `description` which is used to have a per-stack
item description.
This will be covered in more detail in the Metadata and Storage chapter.

## Inventory Locations

An Inventory Location is where and how the inventory is stored.
There are three types of inventory location: player, node, and detached.
An inventory is directly tied to one and only one location - updating the inventory
will cause it to update immediately.

Node inventories are related to the position of a specific node, such as a chest.
The node must be loaded because it is stored in [node metadata](node_metadata.html).

```lua
local inv = minetest.get_inventory({ type="node", pos={x=1, y=2, z=3} })
```

The above obtains an *inventory reference*, commonly referred to as *InvRef*.
Inventory references are used to manipulate an inventory.
*Reference* means that the data isn't actually stored inside that object,
but the object instead directly updates the data in-place.

Player inventories can be obtained similarly or using a player reference.
The player must be online to access their inventory.

```lua
local inv = minetest.get_inventory({ type="player", name="player1" })
-- or
local inv = player:get_inventory()
```

A detached inventory is one which is independent of players or nodes.
Detached inventories also don't save over a restart.
Detached inventories need to be created before they can be used -
this will be covered later.

```lua
local inv = minetest.get_inventory({
    type="detached", name="inventory_name" })
```

The location of an inventory reference can be found like so:

```lua
local location = inv:get_location()
```

## Lists

Inventory Lists are a concept used to allow multiple grids to be stored inside a single location.
This is especially useful for the player as there are a number of common lists
which all games have, such as the *main* inventory and *craft* slots.

### Size and Width

Lists have a size, which is the total number of cells in the grid, and a width,
which is only used within the engine.
The width of the list is not used when drawing the inventory in a window,
because the code behind the window determines the width to use.

```lua
if inv:set_size("main", 32) then
    inv:set_width("main", 8)
    print("size:  " .. inv.get_size("main"))
    print("width: " .. inv:get_width("main"))
else
    print("Error! Invalid itemname or size to set_size()")
end
```

`set_size` will fail and return false if the listname or size is invalid.
For example, the new size may be too small to fit all the current items
in the inventory.

### Checking Contents

`is_empty` can be used to see if a list contains any items:

```lua
if inv:is_empty("main") then
    print("The list is empty!")
end
```

`contains_item` can be used to see if a list contains a specific item.

## Modifying Inventories and ItemStacks

### Adding to a List

To add items to a list named `"main"` while respecting maximum stack sizes:

```lua
local stack    = ItemStack("default:stone 99")
local leftover = inv:add_item("main", stack)
if leftover:get_count() > 0 then
    print("Inventory is full! " ..
            leftover:get_count() .. " items weren't added")
end
```

### Taking Items

To remove items from a list:

```lua
local taken = inv:remove_item("main", stack)
print("Took " .. taken:get_count())
```

### Manipulating Stacks

You can modify individual stacks by first getting them:

```lua
local stack = inv:get_stack(listname, 0)
```

Then modifying them by setting properties or by using the methods which
respect `stack_size`:


```lua
local stack    = ItemStack("default:stone 50")
local to_add   = ItemStack("default:stone 100")
local leftover = stack:add_item(to_add)
local taken    = stack:take_item(19)

print("Could not add"  .. leftover:get_count() .. " of the items.")
-- ^ will be 51

print("Have " .. stack:get_count() .. " items")
-- ^ will be 80
--   min(50+100, stack_max) - 19 = 80
--     where stack_max = 99
```

`add_item` will add items to an ItemStack and return any that could not be added.
`take_item` will take up to the number of items but may take less, and returns the stack taken.

Finally, set the item stack:

```lua
inv:set_stack(listname, 0, stack)
```

## Wear

Tools can have wear; wear shows a progress bar and makes the tool break when completely worn.
Wear is a number out of 65535; the higher it is, the more worn the tool is.

Wear can be manipulated using `add_wear()`, `get_wear()`, and `set_wear(wear)`.

```lua
local stack = ItemStack("default:pick_mese")
local max_uses = 10

-- This is done automatically when you use a tool that digs things
-- It increases the wear of an item by one use.
stack:add_wear(65535 / (max_uses - 1))
```

When digging a node, the amount of wear a tool gets may depend on the node
being dug. So max_uses varies depending on what is being dug.

## Lua Tables

ItemStacks and Inventories can be converted to and from tables.
This is useful for copying and bulk operations.

```lua
-- Entire inventory
local data = inv1:get_lists()
inv2:set_lists(data)

-- One list
local listdata = inv1:get_list("main")
inv2:set_list("main", listdata)
```

The table of lists returned by `get_lists()` will be in this form:

```lua
{
    list_one = {
        ItemStack,
        ItemStack,
        ItemStack,
        ItemStack,
        -- inv:get_size("list_one") elements
    },
    list_two = {
        ItemStack,
        ItemStack,
        ItemStack,
        ItemStack,
        -- inv:get_size("list_two") elements
    }
}
```

`get_list()` will return a single list as just a list of ItemStacks.

One important thing to note is that the set methods above don't change the size
of the lists.
This means that you can clear a list by setting it to an empty table and it won't
decrease in size:

```lua
inv:set_list("main", {})
```
