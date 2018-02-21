---
title: Basic Map Operations
layout: default
root: ../../
---

## Introduction

In this chapter you will learn how to perform basic actions on the map.

* [Map Structure](#map-structure)
* [Reading](#reading)
	* [Reading nodes](#reading-nodes)
	* [Finding nodes](#finding-nodes)
* [Writing](#writing)
* [Loading and Deleting](#loading-and-deleting)

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

### Reading nodes

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

### Finding nodes

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

### Writing nodes

You can use `set_node` to write to the map. Each call to set_node will cause
lighting to be recalculated, which means that set_node is fairly slow for large
numbers of nodes.

{% highlight lua %}
minetest.set_node({ x = 1, y = 3, z = 4 }, { name = "default:mese" })

local node = minetest.get_node({ x = 1, y = 3, z = 4 })
print(node.name) --> default:mese
{% endhighlight %}


### Moving and swapping nodes

Moving a node is the same as swapping a node, except that one of the nodes
becomes air.
Here is a naive example to move a node:

{% highlight lua %}
-- DO NOT ACTUALLY USE THIS
local pos1  = { x = 1, y = 3, z = 4 }
local pos2  = vector.add(pos, { x = 1, y = 0, z = 0 })
local node1 = minetest.get_node(pos1)
local node2 = minetest.get_node(pos2)
minetest.set_node(pos1, node2)
minetest.set_node(pos2, node1)
-- DO NOT ACTUALLY USE THIS
{% endhighlight %}

This won't copy any node meta data to the new position, or delete the old meta
data. Luckily Minetest has a function which you can use instead of the above:

{% highlight lua %}
minetest.swap_node(pos, vector.add(pos, { x = 1, y = 0, z = 0 }))
{% endhighlight %}

### Removing nodes

A node must always be present. When someone says to remove a node, what
is usually meant is they want to set the node to `air`.

The following two lines will both remove a node, and are both identical:

{% highlight lua %}
minetest.remove_node(pos)
minetest.set_node(pos, { name = "air" })
{% endhighlight %}

## Loading and Deleting

You can use `minetest.emerge_area` and `minetest.delete_area` to load
and delete map blocks.

<div class="notice">
    <h2>To Do</h2>

    This section will be added soon&trade;.
</div>

<!--
## Efficient Bulk Operations
## To Do

* line_of_sight
* raycast
* dig_node
* place_node
* punch_node
-->
