---
title: Node Metadata
layout: default
root: ../..
idx: 3.3
description: Using get_meta to obtain a NodeMetaRef.
redirect_from: /en/chapters/node_metadata.html
---

## Introduction

In this chapter you will learn how to manipulate a node's metadata.

* [What is Node Metadata?](#what-is-node-medadata)
* [Getting a Metadata Object](#getting-a-metadata-object)
* [Reading Metadata](#reading-metadata)
* [Setting Metadata](#setting-metadata)
* [Lua Tables](#lua-tables)
* [Infotext](#infotext)
* [Your Turn](#your-turn)

## What is Node Metadata?

Metadata is data about data. So Node Metadata is **data about a node**.

You may use metadata to store:

* A node's inventory (such as in a chest).
* Progress on crafting (such as in a furnace).
* Who owns the node (such as the owner of a locked chest).

The node's type, light levels, and orientation are not stored in the metadata.
These are part of the data itself.

Metadata is stored in a key value relationship. For example:

| Key     | Value   |
|---------|---------|
| foo     | bar     |
| owner   | player1 |
| counter | 5       |

## Getting a Metadata Object

If you know the position of a node, you can retrieve its metadata:

{% highlight lua %}
local meta = minetest.get_meta(pos)
-- where pos = { x = 1, y = 5, z = 7 }
{% endhighlight %}

## Reading Metadata

After retrieving the metadata, you can read its values:

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

The functions available include:

* get_string
* get_int
* get_float
* get_inventory

To get booleans, you should use `get_string` and `minetest.is_yes`:

{% highlight lua %}
local value = minetest.is_yes(meta:get_string("key"))

if value then
    print("is yes")
else
    print("is no")
end
{% endhighlight %}

## Setting Metadata

You can set node metadata. For example:

{% highlight lua %}
local value = "one"
meta:set_string("key", value)

meta:set_string("foo", "bar")
{% endhighlight %}

This can be done using the following functions:

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

The Minetest engine reads the field `infotext` to make text
appear on mouse-over. This is used by furnaces to show progress and by signs
to show their text. For example:

{% highlight lua %}
meta:set_string("infotext", "Here is some text that will appear on mouse-over!")
{% endhighlight %}

## Your Turn

* Make a node which disappears after it has been punched five times.
(Use `on_punch` in the node definition and `minetest.set_node`.)
