---
title: ItemStacks
layout: default
root: ../..
idx: 5.1
redirect_from: /en/chapters/itemstacks.html
---

## Introduction

In this chapter you will learn how to use ItemStacks.

* Creating ItemStacks
* Name and Count
* Adding and Taking Items
* Wear
* Lua Tables
* Meta data
* More Methods

## Creating ItemStacks

An item stack is a... stack of items. It's basically just an item type with
a count of items in the stack.

You can create a stack like so:

{% highlight lua %}
local items = ItemStack("default:dirt")
local items = ItemStack("default:stone 99")
{% endhighlight %}

You could alternatively create a blank ItemStack and fill it using methods:

{% highlight lua %}
local items = ItemStack()
if items:set_name("default:dirt") then
    items:set_count(99)
else
    print("An error occured!")
end
{% endhighlight %}

And you can copy stacks like this:

{% highlight lua %}
local items2 = ItemStack(items)
{% endhighlight %}

## Name and Count

{% highlight lua %}
local items = ItemStack("default:stone")
print(items:get_name()) -- default:stone
print(items:get_count()) -- 1

items:set_count(99)
print(items:get_name()) -- default:stone
print(items:get_count()) -- 99

if items:set_name("default:dirt") then
    print(items:get_name()) -- default:dirt
    print(items:get_count()) -- 99
else
    error("This shouldn't happen")
end
{% endhighlight %}

## Adding and Taking Items

### Adding

Use `add_item` to add items to an ItemStack.
An ItemStack of the items that could not be added is returned.

{% highlight lua %}
local items = ItemStack("default:stone 50")
local to_add = ItemStack("default:stone 100")
local leftovers = items:add_item(to_add)

print("Could not add" .. leftovers:get_count() .. " of the items.")
-- ^ will be 51
{% endhighlight %}

## Taking

The following code takes **up to** 100.
If there aren't enough items in the stack, it will take as much as it can.

{% highlight lua %}
local taken = items:take_item(100)
-- taken is the ItemStack taken from the main ItemStack

print("Took " .. taken:get_count() .. " items")
{% endhighlight %}

## Wear

ItemStacks also have wear on them. Wear is a number out of 65535, the higher it is,
the more wear.

You use `add_wear()`, `get_wear()` and `set_wear(wear)`.

{% highlight lua %}
local items = ItemStack("default:dirt")
local max_uses = 10

-- This is done automatically when you use a tool that digs things
-- It increases the wear of an item by one use.
items:add_wear(65535 / (max_uses - 1))
{% endhighlight %}

When digging a node, the amount of wear a tool gets may depends on the node
being dug. So max_uses varies depending on what is being dug.

## Lua Tables

{% highlight lua %}
local data = items:to_table()
local items2 = ItemStack(data)
{% endhighlight %}

## Meta data

ItemStacks can have meta data, and use the same API as [Node Metadata](node_metadata.html).

{% highlight lua %}
local meta = items:get_meta()
meta:set_string("foo", meta:get_string("foo") .. " ha!")

print(dump(meta:get_string("foo")))
-- if ran multiple times, would give " ha! ha! ha!"
{% endhighlight %}

## More Methods

Have a look at the
[list of methods for an ItemStack]({{ page.root }}/lua_api.html#methods_5).
There are a lot more available than talked about here.
