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

* Basic Concepts.
* Types of Inventories.
    * Player Inventories.
    * Node Inventories.
    * Detached Inventories.
* InvRef and Lists.
    * Type of inventory.
    * List sizes.
    * List is empty.
    * Lua Tables.
    * Lua Tables for Lists.
* InvRef, Items and Stacks.
    * Adding to a list.
    * Checking for room.
    * Taking items.
    * Contains.
    * Manipulating Stacks.

## Basic Concepts

Components of an inventory:

* An **Inventory** is a collection of **Inventory List**s (also called a **list** when in the context of inventories).
* An **Inventory List** is an array of **slot**s. (By array, I mean a table indexed by numbers).
* A **slot** is a place a stack can be - there may be a stack there or there may not.
* An **InvRef** is an object that represents an inventory, and has functions to manipulate it.

There are three ways you can get inventories:

* **Player Inventories** - an inventory attached to a player.
* **Node Inventories** - an inventory attached to a node.
* **Detached Inventories** - an inventory which is not attached to a node or player.

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


## Types of Inventories

There are three types of Inventories.

### Player Inventories.

This is what you see when you press i.
A player inventory usually has two grids, one for the main inventory, one for crafting.

{% highlight lua %}
local inv = minetest.get_inventory({type="player", name="celeron55"})
{% endhighlight %}

### Node Inventories.

An inventory related to a position, such as a chest.
The node must be loaded, as it's stored in [Node Metadata](node_metadata.html).

{% highlight lua %}
local inv = minetest.get_inventory({type="node", pos={x=, y=, z=}})
{% endhighlight %}

### Detached Inventories

A detached inventory is independent of players and nodes.
One example of a detached inventory is the creative inventory is detached,
as all players see the same inventory.
You may also use this if you want multiple chests to share the same inventory.

This is how you get a detached inventory:

{% highlight lua %}
local inv = minetest.get_inventory({type="detached", name="inventory_name"})
{% endhighlight %}

And this is how you can create one:

{% highlight lua %}
minetest.create_detached_inventory("inventory_name", callbacks)
{% endhighlight %}

Creates a detached inventory. If it already exists, it is cleared.
You can supply a [table of callbacks](../lua_api.html#detached-inventory-callbacks).

## InvRef and Lists

### Type of Inventory

You can check where the inventory is from by doing:

{% highlight lua %}
local location = inv:get_location()
{% endhighlight %}

It will return a table like the one passed to `minetest.get_inventory()`.

If the location is unknown, `{type="undefined"}` is returned.

### List sizes

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

### List is empty

{% highlight lua %}
if inv:is_empty("main") then
    print("The list is empty!")
end
{% endhighlight %}

### Lua Tables

You can convert an inventory to a Lua table using:

{% highlight lua %}
local lists = inv:get_lists()
{% endhighlight %}

It will be in this form:

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

You can then set an inventory like this:

{% highlight lua %}
inv:set_lists(lists)
{% endhighlight %}

Please note that the sizes of lists will not change.

### Lua Tables for Lists

You can do the same as above, but for individual lists

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

You can then set the list like this:

{% highlight lua %}
inv:set_list("list_one", list)
{% endhighlight %}

Please note that the sizes of lists will not change.

## InvRef, Items and Items

### Adding to a list

{% highlight lua %}
local stack = ItemStack("default:stone 99")
local leftover = inv:add_item("main", stack)
if leftover:get_count() > 0 then
    print("Inventory is full! " .. leftover:get_count() .. " items weren't added")
end
{% endhighlight %}

`"main"` is the name of the list you're adding to.

### Checking for room

{% highlight lua %}
if not inv:room_for_item("main", stack) then
    print("Not enough room!")
end
{% endhighlight %}

### Taking items

{% highlight lua %}
local taken = inv:remove_item("main", stack)
print("Took " .. taken:get_count())
{% endhighlight %}

### Contains

This works if the item count is split up over multiple stacks,
for example looking for "default:stone 200" will work if there
are stacks of 99 + 95 + 6.

{% highlight lua %}
if not inv:contains_item(listname, stack) then
    print("Item not in inventory!")
end
{% endhighlight %}

### Manipulating Stacks

Finally, you can manipulate individual stacks like so:


{% highlight lua %}
local stack = inv:get_stack(listname, 0)
inv:set_stack(listname, 0, stack)
{% endhighlight %}
