---
title: Common Mistakes
layout: default
root: ../..
idx: 8.1
redirect_from: /en/chapters/common_mistakes.html
---

## Introduction <!-- omit in toc -->

This chapter details common mistakes, and how to avoid them.

- [Be Careful When Storing ObjectRefs (ie: players or entities)](#be-careful-when-storing-objectrefs-ie-players-or-entities)
- [Don't Trust Formspec Submissions](#dont-trust-formspec-submissions)
- [Set ItemStacks After Changing Them](#set-itemstacks-after-changing-them)

## Be Careful When Storing ObjectRefs (ie: players or entities)

An ObjectRef is invalidated when the player or entity it represents leaves
the game. This may happen when the player goes offline, or the entity is unloaded
or removed.

The methods of ObjectRefs will always return nil when invalid, since Minetest 5.2.
Any call will essentially be ignored.

You should avoid storing ObjectRefs where possible. If you do to store an
ObjectRef, you should make you check it before use, like so:

```lua
-- This only works in Minetest 5.2+
if obj:get_pos() then
	-- is valid!
end
```

## Don't Trust Formspec Submissions

Malicious clients can submit formspecs whenever they like, with
whatever content they like.

For example, the following code has a vulnerability which allows players to
give themselves moderator privileges:

```lua
local function show_formspec(name)
    if not minetest.check_player_privs(name, { privs = true }) then
        return false
    end

    minetest.show_formspec(name, "modman:modman", [[
        size[3,2]
        field[0,0;3,1;target;Name;]
        button_exit[0,1;3,1;sub;Promote]
    ]])
    return true
})

minetest.register_on_player_receive_fields(function(player,
        formname, fields)
    -- BAD! Missing privilege check here!

    local privs = minetest.get_player_privs(fields.target)
    privs.kick  = true
    privs.ban   = true
    minetest.set_player_privs(fields.target, privs)
    return true
end)
```

Add a privilege check to solve this:

```lua
minetest.register_on_player_receive_fields(function(player,
        formname, fields)
    if not minetest.check_player_privs(name, { privs = true }) then
        return false
    end

    -- code
end)
```

## Set ItemStacks After Changing Them

Have you noticed that it's simply called an `ItemStack` in the API, not an `ItemStackRef`,
similar to `InvRef`? This is because an `ItemStack` isn't a reference - it's a
copy. Stacks work on a copy of the data rather than the stack in the inventory.
This means that modifying a stack won't actually modify that stack in the inventory.

For example, don't do this:

```lua
local inv = player:get_inventory()
local stack = inv:get_stack("main", 1)
stack:get_meta():set_string("description", "Partially eaten")
-- BAD! Modification will be lost
```

Do this instead:

```lua
local inv = player:get_inventory()
local stack = inv:get_stack("main", 1)
stack:get_meta():set_string("description", "Partially eaten")
inv:set_stack("main", 1, stack)
-- Correct! Item stack is set
```

The behaviour of callbacks is slightly more complicated. Modifying an `ItemStack` you
are given will change it for the caller too, and any subsequent callbacks. However,
it will only be saved in the engine if the callback caller sets it.

```lua
minetest.register_on_item_eat(function(hp_change, replace_with_item,
        itemstack, user, pointed_thing)
    itemstack:get_meta():set_string("description", "Partially eaten")
    -- Almost correct! Data will be lost if another
    -- callback cancels the behaviour
end)
```

If no callbacks cancel this, the stack will be set and the description will be updated,
but if a callback does cancel this, then the update may be lost.

It's better to do this instead:

```lua
minetest.register_on_item_eat(function(hp_change, replace_with_item,
        itemstack, user, pointed_thing)
    itemstack:get_meta():set_string("description", "Partially eaten")
    user:get_inventory():set_stack("main", user:get_wield_index(),
            itemstack)
    -- Correct, description will always be set!
end)
```

If the callbacks cancel or the callback runner doesn't set the stack,
then the update will still be set.
If the callbacks or the callback runner set the stack, then the use of
set_stack doesn't matter.
