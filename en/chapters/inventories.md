---
title: Inventories
layout: default
root: ../../
---

## Introduction

In this chapter you will learn how to use manipulate inventories, whether that
is a player inventory, a node inventory, or a detached inventory.
This chapter assumes that you already know how to create and manipulate
[ItemStacks](itemstacks.html).

* [Basic Concepts](#basic-concepts)
* [Types of Inventories](#types-of-inventories)
    * [Player Inventories](#player-inventories)
    * [Node Inventories](#node-inventories)
    * [Detached Inventories](#detached-inventories)
* [InvRef and Lists](#invref-and-lists)
    * [Inventory Location](#inventory-location)
    * [List Sizes](#list-sizes)6
    * [Empty Lists](#empty-lists)
    * [Lua Tables](#lua-tables)
    * [Lua Tables for Lists](#lua-tables-for-lists)
* [InvRef, Items and Stacks](#invref-items-and-stacks)
    * [Adding to a List](#adding-to-a-list)
    * [Checking for Room](#checking-for-room)
    * [Taking Items](#taking-items)
    * [Checking Inventory Contents](#checking-inventory-contents)
    * [Manipulating Stacks](#manipulating-stacks)

## Basic Concepts

Components of an inventory:

* An **inventory** is a collection of **inventory list**s, which are simply called **list**s in the context of inventories.
* An **inventory list** is an array of **slot**s. (An array is a table indexed by numbers).
* A **slot** contains a stack which may or may not be empty.
* An **InvRef** is an object that represents an inventory, and has functions to manipulate it.

## Types of Inventories

There are three types of inventory:

* **Player Inventories**: An inventory attached to a player.
* **Node Inventories**: An inventory attached to a node.
* **Detached Inventories**: An inventory which is not attached to a node or player.

<figure>
    <img src="{{ page.root }}/static/inventories_lists.png" alt="The player inventory formspec, with annotated list names.">
    <figcaption>
        This image shows the two inventories visible when you press i.
        The gray boxes are inventory lists.<br />
        The creative inventory, left (in red) is detached and it made up of a
        single list.<br />
        The player inventory, right (in blue) is a player inventory
        and is made up of three lists.<br />
        Note that the trash can is a <a href="formspecs.html">formspec</a>
        element, and is not part of the inventory.
    </figcaption>
</figure>

### Player Inventories.

A player inventory usually has two grids, one for the main inventory and one for crafting.
Press i in game to see your player inventory. 

Use a player's name to get their inventory:

{% highlight lua %}
local inv = minetest.get_inventory({type="player", name="celeron55"})
{% endhighlight %}

### Node Inventories.

A node inventory is related to the position of a specific node, such as a chest.
The node must be loaded, because it is stored in [node metadata](node_metadata.html).

Use its position to get a node inventory:

{% highlight lua %}
local inv = minetest.get_inventory({type="node", pos={x=, y=, z=}})
{% endhighlight %}

### Detached Inventories

A detached inventory is independent of players and nodes.
One example of a detached inventory is the creative inventory. It is detached from
any specific player because all players see the same creative inventory.
A detached inventory would also allow multiple chests to share the same inventory.

Use the inventory name to get a detached inventory:

{% highlight lua %}
local inv = minetest.get_inventory({type="detached", name="inventory_name"})
{% endhighlight %}

You can create your own detached inventories:

{% highlight lua %}
minetest.create_detached_inventory("inventory_name", callbacks)
{% endhighlight %}

This creates a detached inventory or, if the inventory already exists, it is cleared.
You can also supply a [table of callbacks](../lua_api.html#detached-inventory-callbacks).

## InvRef and Lists

### Inventory Location

You can check where an inventory is located:

{% highlight lua %}
local location = inv:get_location()
{% endhighlight %}

This will return a table like the one passed to `minetest.get_inventory()`.

If the location is unknown, `{type="undefined"}` is returned.

### List Sizes

Inventory lists have a size, for example `main` has size of 32 slots by default.
They also have a width, which is used to divide them into a grid.

{% highlight lua %}
if inv:set_size("main", 32) then
    inv:set_width("main", 8)
    print("size:  " .. inv.get_size("main"))
    print("width: " .. inv:get_width("main"))
else
    print("Error!")
end
{% endhighlight %}

<!--The width and height of an inventory in a [formspec](formspecs.html) is
determined by the formspec element, not by the inventory. By that I mean
a list doesn't have a width or height, only the maximum number of stacks/slots.-->

### Empty Lists

You can use `list_is_empty` to check if a list is empty:

{% highlight lua %}
if inv:is_empty("main") then
    print("The list is empty!")
end
{% endhighlight %}

### Lua Tables

You can convert an inventory to a Lua table:

{% highlight lua %}
local lists = inv:get_lists()
{% endhighlight %}

The table will be in this form:

{% highlight lua %}
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
{% endhighlight %}

You can then set the inventory:

{% highlight lua %}
inv:set_lists(lists)
{% endhighlight %}

Please note that the sizes of lists will not change.

### Lua Tables for Lists

You can do the above for individual lists:

{% highlight lua %}
local list = inv:get_list("list_one")
{% endhighlight %}

It will be in this form:

{% highlight lua %}
{
    ItemStack,
    ItemStack,
    ItemStack,
    ItemStack,
    -- inv:get_size("list_one") elements
}
{% endhighlight %}

You can then set the list:

{% highlight lua %}
inv:set_list("list_one", list)
{% endhighlight %}

Please note that the sizes of lists will not change.

## InvRef, Items and Stacks

### Adding to a List

To add items to a list named `"main"`:

{% highlight lua %}
local stack = ItemStack("default:stone 99")
local leftover = inv:add_item("main", stack)
if leftover:get_count() > 0 then
    print("Inventory is full! " .. leftover:get_count() .. " items weren't added")
end
{% endhighlight %}

### Checking for Room

To check whether a list has room for items:

{% highlight lua %}
if not inv:room_for_item("main", stack) then
    print("Not enough room!")
end
{% endhighlight %}

### Taking Items

To remove items from a list:

{% highlight lua %}
local taken = inv:remove_item("main", stack)
print("Took " .. taken:get_count())
{% endhighlight %}

### Checking Inventory Contents

To check whether an inventory contains a specific quantity of an item:

{% highlight lua %}
if not inv:contains_item(listname, stack) then
    print("Item not in inventory!")
end
{% endhighlight %}

This works if the item count is split up over multiple stacks.
For example checking for "default:stone 200" will work if there
are stacks of 99 + 95 + 6.

### Manipulating Stacks

You can manipulate individual stacks:

{% highlight lua %}
local stack = inv:get_stack(listname, 0)
inv:set_stack(listname, 0, stack)
{% endhighlight %}
