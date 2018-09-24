---
title: Storage and Metadata
layout: default
root: ../..
idx: 3.3
description: Mod Storage, NodeMetaRef (get_meta).
redirect_from:
  - /en/chapters/node_metadata.html
  - /en/map/node_metadata.html
---

## Introduction

In this chapter you will learn how you can store data.

* [Metadata](#metadata)
    * [What is Metadata?](#what-is-metadata)
    * [Obtaining a Metadata Object](#obtaining-a-metadata-object)
    * [Reading and Writing](#reading-and-writing)
    * [Special Keys](#special-keys)
    * [Private Metadata](#private-metadata)
    * [Storing Tables](#storing-tables)
    * [Lua Tables](#lua-tables)
* [Mod Storage](#mod-storage)
* [Databases](#databases)
* [Deciding Which to Use](#deciding-which-to-use)
* [Your Turn](#your-turn)

## Metadata

### What is Metadata?

In Minetest, Metadata is a key-value store used to attach custom data to something.
You can use metadata to store information against a Node, Player, or ItemStack.

Each type of metadata uses the exact same API.
Metadata stores values as strings, but there are a number of methods to
convert and store other primitive types.

Some keys in metadata may have special meaning.
For example, `infotext` in node metadata is used to store the tooltip which shows
when hovering over the node using the crosshair.
To avoid conflicts with other mods, you should use the standard namespace
convention for keys: `modname:keyname`.
The exception is for conventional data such as the owner name which is stored as
`owner`.

Metadata is data about data.
The data itself, such as a node's type or an stack's count, is not metadata.

### Obtaining a Metadata Object

If you know the position of a node, you can retrieve its metadata:

```lua
local meta = minetest.get_meta({ x = 1, y = 2, z = 3 })
```

Player and ItemStack metadata are obtained using `get_meta()`:

```lua
local pmeta = player:get_meta()
local imeta = stack:get_meta()
```

### Reading and Writing

In most cases, `get_<type>()` and `set_<type>()` methods will be used to read
and write to meta.
Metadata stores strings, so the string methods will directly set and get the value.

```lua
print(meta:get_string("foo")) --> ""
meta:set_string("foo", "bar")
print(meta:get_string("foo")) --> "bar"
```

All of the typed getters will return a neutral default value if the key doesn't
exist, such as `""` or `0`.
You can use `get()` to return a string or nil.

As Metadata is a reference, any changes will be updated to the source automatically.
ItemStacks aren't references however, so you'll need to update the itemstack in the
inventory.

The non-typed getters and setters will convert to and from strings:

```lua
print(meta:get_int("count"))    --> 0
meta:set_int("count", 3)
print(meta:get_int("count"))    --> 3
print(meta:get_string("count")) --> "3"
```

### Special Keys

`infotext` is used in Node Metadata to show a tooltip when hovering the crosshair over a node.
This is useful in order to show the owner of the node or the status.

`description` is used in ItemStack Metadata to override the description when
hovering over the stack in an inventory.
You can use colors by encoding them with `minetest.colorize()`.

`owner` is a common key used to store the username of the player that owns the
item or node.

### Storing Tables

Tables must be converted to strings before they can be stored.
Minetest offers two formats for doing this: Lua and JSON.

The Lua method tends to be a lot faster and exactly matches the format Lua
uses for tables.
JSON is a more standard format and is better structured, and so is well suited
when you need to exchange information with another program.

```lua
local data = { username = "player1", score = 1234 }
meta:set_string("foo", minetest.serialize(data))

data = minetest.deserialize(minetest:get_string("foo"))
```

### Private Metadata

Entries in Node Metadata can be marked as private, and not sent to the client.
Entries not marked as private will be sent to the client.

```lua
meta:set_string("secret", "asd34dn")
meta:mark_as_private("secret")
```

### Lua Tables

You can convert to and from Lua tables using `to_table` and `from_table`:

```lua
local tmp = meta:to_table()
tmp.foo = "bar"
meta:from_table(tmp)
```

## Mod Storage

Mod storage uses the exact same API as Metadata, although it's not technically
Metadata.
Mod storage is per-mod, and can only be obtained during load time in order to
know which mod is requesting it.

```lua
local storage = minetest.get_mod_storage()
```

You can now manipulate the storage just like metadata:

```lua
storage:set_string("foo", "bar")
```

## Databases

If the mod is likely to be used on a server and will store lots of data,
it's a good idea to offer a database storage method.
You should make this optional by separating how the data is stored and where
it is used.
Using a database such as sqlite requires using the insecure environment, and
can be painful for the user to set up.

```lua
local backend
if use_database then
    backend =
        dofile(minetest.get_modpath("mymod") .. "/backend_sqlite.lua")
else
    backend =
        dofile(minetest.get_modpath("mymod") .. "/backend_storage.lua")
end

backend.get_foo("a")
backend.set_foo("a", { score = 3 })
```

The backend_storage.lua file should include a mod storage implementation:

```lua
local storage = minetest.get_mod_storage()
local backend = {}

function backend.set_foo(key, value)
    storage:set_string(key, minetest.serialize(value))
end

function backend.get_foo(key, value)
    return minetest.deserialize(storage:get_string(key))
end

return backend
```

The backend_sqlite would do a similar thing, but use the Lua *lsqlite3* library
instead of mod storage.
You'll need to request an insecure environment and require the library:

```lua
local ie = minetest.request_insecure_environment()
assert(ie, "Please add mymod to secure.trusted_mods")

local _sql = ie.require("lsqlite3")
-- Prevent other mods from using the global sqlite3 library
if sqlite3 then
    sqlite3 = nil
end
```

Teaching about SQL or how to use the lsqlite3 library is out of scope for this book.
Insecure environments will be covered in more detail in the
[security](../quality/security.html) chapter.

## Deciding Which to Use

The type of method you use depends on what the data is about,
how it is formatted, and how large it is.
As a guideline, small data is up to 10K, medium data is up to 10MB, and large
data is any size above that.

Node metadata is a good choice when the data is related to the node.
Storing medium data is fairly efficient if you make it private.

Item metadata should not be used to store anything but small amounts of data as it is not
possible to avoid sending it to the client.
The data will also be copied every time the stack is moved, or is accessed from Lua.

Mod storage is good for medium data but writing large data may be inefficient.
It's better to use a database for large data, to avoid having to write all the
data out on every save.

## Your Turn

* Make a node which disappears after it has been punched five times.
(Use `on_punch` in the node definition and `minetest.set_node`.)
