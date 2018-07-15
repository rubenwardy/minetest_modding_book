---
title: Basic Map Operations
layout: default
root: ../../
idx: 3.1
description: Basic operations like set_node and get_node
redirect_from: /en/chapters/environment.html
---

## Introduction

In this chapter you will learn how to perform basic actions on the map.

* [Map Structure](#map-structure)
* [Reading](#reading)
    * [Reading Nodes](#reading-nodes)
    * [Finding Nodes](#finding-nodes)
* [Writing](#writing)
    * [Writing Nodes](#writing-nodes)
    * [Removing Nodes](#removing-nodes)
* [Loading Blocks](#loading-blocks)
* [Deleting Blocks](#deleting-blocks)

## Map Structure

The Minetest map is split into MapBlocks, each MapBlocks being a cube of size 16.
As players travel around the map, MapBlocks are created, loaded, and unloaded.
Areas of the map which are not yet loaded are full of *ignore* nodes, an impassable
unselectable placeholder node. Empty space is full of *air* nodes, an invisible node
you can walk through.

Loaded map blocks are often refered to as *active blocks*. Active Blocks can be
read from or written to by mods or players, have active entities. The Engine also
performs operations on the map, such as performing liquid physics.

MapBlocks can either be loaded from the world database or generated. MapBlocks
will be generated up to the map generation limit (`mapgen_limit`) which is set
at its maximum value, 31000, by default. Existing MapBlocks can however be
loaded from the world database outside of the generation limit.


<!--Multiple MapBlocks are generated at a time in groups called *MapChunks*. Each
MapChunk is by default 5x5x5<sup>1</sup> MapBlocks, which is 80x80x80 nodes.
The size of a MapChunk can change using the chunk_size setting but will always
be a cube. -->



## Reading

### Reading Nodes

You can read from the map once you have a position:

{% highlight lua %}
local node = minetest.get_node({ x = 1, y = 3, z = 4 })
print(dump(node)) --> { name=.., param1=.., param2=.. }
{% endhighlight %}

If the position is a decimal, it will be rounded to the containing node.
The function will always return a table containing the node information:

* `name` - The node name, will be ignore when the area is unloaded.
* `param1` - See the node definition, will commonly be light.
* `param2` - See the node definition.

It's worth noting that the function won't load the containing block if the block
is inactive, but will instead return a table with `name` being `ignore`.

You can use `minetest.get_node_or_nil` instead, which will return `nil` rather
than a table with a name of `ignore`. It still won't load the block, however.
This may still return `ignore` if a block actually contains ignore.
This will happen near the edge of the map as defined by the map generation
limit (`mapgen_limit`).

### Finding Nodes

Minetest offers a number of helper functions to speed up common map actions.
The most commonly used of these are for finding nodes.

For example, say we wanted to make a certain type of plant that grows
better near mese. You would need to search for any nearby mese nodes,
and adapt the growth rate accordingly.

{% highlight lua %}
local grow_speed = 1
local node_pos   = minetest.find_node_near(pos, 5, { "default:mese" })
if node_pos then
    minetest.chat_send_all("Node found at: " .. dump(node_pos))
    grow_speed = 2
end
{% endhighlight %}

Lets say, for example, that the growth rate increases the more mese there is
nearby. You should then use a function which can find multiple nodes in area:

{% highlight lua %}
local pos1       = vector.subtract(pos, { x = 5, y = 5, z = 5 })
local pos2       = vector.add(pos, { x = 5, y = 5, z = 5 })
local pos_list   = minetest.find_nodes_in_area(pos1, pos2, { "default:mese" })
local grow_speed = 1 + #pos_list
{% endhighlight %}

The above code doesn't quite do what we want, as it checks based on area, whereas
`find_node_near` checks based on range. In order to fix this we will,
unfortunately, need to manually check the range ourselves.

{% highlight lua %}
local pos1       = vector.subtract(pos, { x = 5, y = 5, z = 5 })
local pos2       = vector.add(pos, { x = 5, y = 5, z = 5 })
local pos_list   = minetest.find_nodes_in_area(pos1, pos2, { "default:mese" })
local grow_speed = 1
for i=1, #pos_list do
    local delta = vector.subtract(pos_list[i], pos)
    if delta.x*delta.x + delta.y*delta.y <= 5*5 then
        grow_speed = grow_speed + 1
    end
end
{% endhighlight %}

Now your code will correctly increase `grow_speed` based on mese nodes in range.
Note how we compared the squared distance from the position, rather than square
rooting it to obtain the actual distance. This is because computers find square
roots computationally expensive, so you should avoid them as much as possible.

There are more variations of the above two functions, such as
`find_nodes_with_meta` and `find_nodes_in_area_under_air`, which work in a
similar way and are useful in other circumstances.

## Writing

### Writing Nodes

You can use `set_node` to write to the map. Each call to set_node will cause
lighting to be recalculated, which means that set_node is fairly slow for large
numbers of nodes.

{% highlight lua %}
minetest.set_node({ x = 1, y = 3, z = 4 }, { name = "default:mese" })

local node = minetest.get_node({ x = 1, y = 3, z = 4 })
print(node.name) --> default:mese
{% endhighlight %}

set_node will remove any associated meta data or inventory from that position.
This isn't desirable in all circumstances, especially if you're using multiple
node definitions to represent one conceptual node. An example of this is the
furnace node - whilst you think conceptually of it as one node, it's actually
two.

You can set a node without deleting meta data or the inventory like so:

{% highlight lua %}
minetest.swap_node({ x = 1, y = 3, z = 4 }, { name = "default:mese" })
{% endhighlight %}

### Removing Nodes

A node must always be present. When someone says to remove a node, what
is usually meant is they want to set the node to `air`.

The following two lines will both remove a node, and are both identical:

{% highlight lua %}
minetest.remove_node(pos)
minetest.set_node(pos, { name = "air" })
{% endhighlight %}

In fact, remove_node will call set_node with name being air.

## Loading Blocks

You can use `minetest.emerge_area` to load map blocks. Emerge area is asynchronous,
meaning the the blocks won't be loaded instantly. Instead they will be loaded
soon in the future, and the callback will be called each time.

{% highlight lua %}
-- Load a 20x20x20 area
local halfsize = { x = 10, y = 10, z = 10 }
local pos1 = vector.subtract(pos, halfsize)
local pos2 = vector.add     (pos, halfsize)

local context = {} -- persist data between callback calls
minetest.emerge_area(pos1, pos2, emerge_callback, context)
{% endhighlight %}

Minetest will call `emerge_callback` whenever it loads a block, with some
progress information.

{% highlight lua %}
local function emerge_callback(pos, action, num_calls_remaining, context)
    -- On first call, record number of blocks
    if not context.total_blocks then
        context.total_blocks  = num_calls_remaining + 1
        context.loaded_blocks = 0
    end

    -- Increment number of blocks loaded
    context.loaded_blocks = context.loaded_blocks + 1

    -- Send progress message
    if context.total_blocks == context.loaded_blocks then
        minetest.chat_send_all("Finished loading blocks!")
    end
        local perc = 100 * context.loaded_blocks / context.total_blocks
        minetest.chat_send_all(string.format("Loading blocks %d/%d (%.2f%%)",
            context.loaded_blocks, context.total_blocks, perc)
    end
end
{% endhighlight %}

This is not the only way of loading blocks; Using a LVM will also cause the
encompassed blocks to be loaded synchronously.

## Deleting Blocks

You can use delete_blocks to delete a range of map blocks:

{% highlight lua %}
-- Delete a 20x20x20 area
local halfsize = { x = 10, y = 10, z = 10 }
local pos1 = vector.subtract(pos, halfsize)
local pos2 = vector.add     (pos, halfsize)

minetest.delete_area(pos1, pos2)
{% endhighlight %}

This will delete all map blocks in that area, *inclusive*. This means that some
nodes will be deleted outside the area as they will be on a mapblock which overlaps
the area bounds.
