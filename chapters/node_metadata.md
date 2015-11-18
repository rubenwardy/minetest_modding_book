---
title: Node Metadata
layout: default
root: ../
---

## Introduction

In this chapter you will learn how to manipulate a node's metadata.

* What is Node Metadata?
* Getting a Metadata Object
* Reading Metadata
* Setting Metadata
* Lua Tables
* Infotext
* Your Turn

## What is Node Metadata?

Metadata is data about data. So Node Metadata is **data about a node**.

You may use metadata to store:

* an node's inventory (such as in a chest).
* progress on crafting (such as in a furnace).
* who owns the node (such as in a locked chest).

The node's type, light levels,
and orientation are not stored in the metadata, but rather are part
of the data itself.

Metadata is stored in a key value relationship.

| Key     | Value   |
|---------|---------|
| foo     | bar     |
| owner   | player1 |
| counter | 5       |

## Getting a Metadata Object

Once you have a position of a node, you can do this:

{% highlight lua %}
local meta = minetest.get_meta(pos)
-- where pos = { x = 1, y = 5, z = 7 }
{% endhighlight %}

## Reading Metadata

{% highlight lua %}
local value = meta:get_string("key")

if value then
	print(value)
else
	-- value == nil
	-- metadata of key "key" does not exist
	print(value)
end
{% endhighlight %}

Here are all the get functions you can use, as of writing:

* get_string
* get_int
* get_float
* get_inventory

In order to do booleans, you should use `get_string` and `minetest.is_yes`:


{% highlight lua %}
local value = minetest.is_yes(meta:get_string("key"))

if value then
	print("is yes")
else
	print("is no")
end
{% endhighlight %}

## Setting Metadata

Setting meta data works pretty much exactly the same way.

{% highlight lua %}
local value = "one"
meta:set_string("key", value)

meta:set_string("foo", "bar")
{% endhighlight %}

Here are all the set functions you can use, as of writing:

* set_string
* set_int
* set_float

## Lua Tables

You can convert to and from lua tables using `to_table` and `from_table`:

{% highlight lua %}
local tmp = meta:to_table()
tmp.foo = "bar"
meta:from_table(tmp)
{% endhighlight %}

## Infotext

The Minetest Engine reads the field `infotext` in order to make text
appear on mouse-over. This is used by furnaces to show progress and signs
to show their text.

{% highlight lua %}
meta:set_string("infotext", "Here is some text that will appear on mouse over!")
{% endhighlight %}

## Your Turn

* Make a block which disappears after it has been punched 5 times.
  (use on_punch in the node def and minetest.set_node)
