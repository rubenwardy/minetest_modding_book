---
title: ItemStack
layout: default
root: ../
---

## Introduction

In this chapter you will learn how to use ItemStacks.

* Creating ItemStacks
* Name and Count
* Wear
* Copying a stack
* Lua Tables
* Metadata
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

## Wear

ItemStacks also have wear on them. Wear is a number out of 65535, the higher is
more warn.

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

## Copying a stack

It's as simple as this:

{% highlight lua %}
local items2 = ItemStack(items)
{% endhighlight %}

## Lua Tables

{% highlight lua %}
local data = items:to_table()
local items2 = ItemStack(data)
{% endhighlight %}

## Metadata

ItemStacks can also have a single field of metadata attached to
them.

{% highlight lua %}
local meta = items:get_metadata()
print(dump(meta))
meta = meta .. " ha!"
items:set_metadata(meta)
-- if ran multiple times, would give " ha! ha! ha!"
{% endhighlight %}

## More Methods

Have a look at the
[list of methods for an ItemStack](http://rubenwardy.com/minetest_modding_book/lua_api.html#methods_5).
There are a lot more available than talked about here.
