---
title: Lua Voxel Manipulators
layout: default
root: ../..
idx: 3.5
description: Learn how to use LVMs to speed up map operations.
redirect_from: /en/chapters/lvm.html
---

## Introduction <!-- omit in toc -->

The functions outlined in the [Basic Map Operations](environment.html) chapter
are convenient and easy to use, but for large areas they are inefficient.
Every time you call `set_node` or `get_node`, your mod needs to communicate with
the engine. This results in constant individual copying operations between the
engine and your mod, which is slow and will quickly decrease the performance of
your game. Using a Lua Voxel Manipulator (LVM) can be a better alternative.

- [Concepts](#concepts)
- [Reading into the LVM](#reading-into-the-lvm)
- [Reading Nodes](#reading-nodes)
- [Writing Nodes](#writing-nodes)
- [Example](#example)
- [Your Turn](#your-turn)

## Concepts

An LVM allows you to load large areas of the map into your mod's memory.
You can then read and write this data without further interaction with the
engine and without running any callbacks, which means that these
operations are very fast. Once done, you can then write the area back into
the engine and run any lighting calculations.

## Reading into the LVM

You can only load a cubic area into an LVM, so you need to work out the minimum
and maximum positions that you need to modify. Then you can create and read into
an LVM. For example:

```lua
local vm         = minetest.get_voxel_manip()
local emin, emax = vm:read_from_map(pos1, pos2)
```

For performance reasons, an LVM will almost never read the exact area you tell it to.
Instead, it will likely read a larger area. The larger area is given by `emin` and `emax`,
which stand for *emerged min pos* and *emerged max pos*. An LVM will load the area
it contains for you - whether that involves loading from memory, from disk, or
calling the map generator.

## Reading Nodes

To read the types of nodes at particular positions, you'll need to use `get_data()`.
This returns a flat array where each entry represents the type of a
particular node.

```lua
local data = vm:get_data()
```

You can get param2 and lighting data using the methods `get_light_data()` and `get_param2_data()`.

You'll need to use `emin` and `emax` to work out where a node is in the flat arrays
given by the above methods. There's a helper class called `VoxelArea` which handles
the calculation for you.

```lua
local a = VoxelArea:new{
    MinEdge = emin,
    MaxEdge = emax
}

-- Get node's index
local idx = a:index(x, y, z)

-- Read node
print(data[idx])
```

When you run this, you'll notice that `data[vi]` is an integer. This is because
the engine doesn't store nodes using strings, for performance reasons.
Instead, the engine uses an integer called a content ID.
You can find out the content ID for a particular type of node with
`get_content_id()`. For example:

```lua
local c_stone = minetest.get_content_id("default:stone")
```

You can then check whether the node is stone:

```lua
local idx = a:index(x, y, z)
if data[idx] == c_stone then
    print("is stone!")
end
```

It is recommended that you find and store the content IDs of nodes types
at load time because the IDs of a node type will never change. Make sure to store
the IDs in a local variable for performance reasons.

Nodes in an LVM data array are stored in reverse co-ordinate order, so you should
always iterate in the order `z, y, x`. For example:

```lua
for z = min.z, max.z do
    for y = min.y, max.y do
        for x = min.x, max.x do
            -- vi, voxel index, is a common variable name here
            local vi = a:index(x, y, z)
            if data[vi] == c_stone then
                print("is stone!")
            end
        end
    end
end
```

The reason for this touches on the topic of computer architecture. Reading from RAM is rather
costly, so CPUs have multiple levels of caching. If the data that a process requests
is in the cache, it can very quickly retrieve it. If the data is not in the cache,
then a cache miss occurs and it will fetch the data it needs from RAM. Any data
surrounding the requested data is also fetched and then replaces the data in the cache. This is
because it's quite likely that the process will ask for data near that location again. This means
a good rule of optimisation is to iterate in a way that you read data one after
another, and avoid *cache thrashing*.

## Writing Nodes

First, you need to set the new content ID in the data array:

```lua
for z = min.z, max.z do
    for y = min.y, max.y do
        for x = min.x, max.x do
            local vi = a:index(x, y, z)
            if data[vi] == c_stone then
                data[vi] = c_air
            end
        end
    end
end
```

When you finish setting nodes in the LVM, you then need to upload the data
array to the engine:

```lua
vm:set_data(data)
vm:write_to_map(true)
```

For setting lighting and param2 data, use the appropriately named
`set_light_data()` and `set_param2_data()` methods.

`write_to_map()` takes a Boolean which is true if you want lighting to be
calculated. If you pass false, you need to recalculate lighting at a future
time using `minetest.fix_light`.

## Example

```lua
-- Get content IDs during load time, and store into a local
local c_dirt  = minetest.get_content_id("default:dirt")
local c_grass = minetest.get_content_id("default:dirt_with_grass")

local function grass_to_dirt(pos1, pos2)
    -- Read data into LVM
    local vm = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map(pos1, pos2)
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local data = vm:get_data()

    -- Modify data
    for z = pos1.z, pos2.z do
        for y = pos1.y, pos2.y do
            for x = pos1.x, pos2.x do
                local vi = a:index(x, y, z)
                if data[vi] == c_grass then
                    data[vi] = c_dirt
                end
            end
        end
    end

    -- Write data
    vm:set_data(data)
    vm:write_to_map(true)
end
```

## Your Turn

* Create `replace_in_area(from, to, pos1, pos2)`, which replaces all instances of
  `from` with `to` in the area given, where `from` and `to` are node names.
* Make a function which rotates all chest nodes by 90&deg;.
* Make a function which uses an LVM to cause mossy cobble to spread to nearby
  stone and cobble nodes.
  Does your implementation cause mossy cobble to spread more than a distance of one node each
  time? If so, how could you stop this?
