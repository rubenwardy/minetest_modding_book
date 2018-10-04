---
title: Privileges
layout: default
root: ../..
idx: 4.1
description: Registering privs.
redirect_from: /en/chapters/privileges.html
---

## Introduction

Privileges, often called privs for short, give players the ability to perform
certain actions. Server owners can grant and revoke privileges to control
which abilities each player has.

* [When to use Privileges](#when-to-use-privileges)
* [Declaring Privileges](#declaring-privileges)
* [Checking for Privileges](#checking-for-privileges)
* [Getting and Setting Privileges](#getting-and-setting-privileges)
* [Adding Privileges to basic_privs](#adding-privileges-to-basic-privs)

## When to use Privileges

A privilege should give a player the ability to do something.
Privileges are **not** for indicating class or status.

**Good Privileges:**

* interact
* shout
* noclip
* fly
* kick
* ban
* vote
* worldedit
* area_admin - admin functions of one mod is ok

**Bad Privileges:**

* moderator
* admin
* elf
* dwarf

## Declaring Privileges

Use `register_privilege` to declare a new privilege:

```lua
minetest.register_privilege("vote", {
    description = "Can vote on issues",
    give_to_singleplayer = true
})
```

`give_to_singleplayer` defaults to true when not specified, so it isn't
actually needed in the above definition.

## Checking for Privileges

To quickly check whether a player has all the required privileges:

```lua
local has, missing = minetest.check_player_privs(player_or_name,  {
    interact = true,
    vote = true })
```

In this example, `has` is true if the player has all the privileges needed.
If `has` is false, then `missing` will contain a key-value table
of the missing privileges.

```lua
local has, missing = minetest.check_player_privs(name, {
        interact = true,
        vote = true })

if has then
    print("Player has all privs!")
else
    print("Player is missing privs: " .. dump(missing))
end
```

If you don't need to check the missing privileges, you can put
`check_player_privs` directly into the if statement.

```lua
if not minetest.check_player_privs(name, { interact=true }) then
    return false, "You need interact for this!"
end
```

## Getting and Setting Privileges

Player privileges can be accessed or modified regardless of the player
being online.


```lua
local privs = minetest.get_player_privs(name)
print(dump(privs))

privs.vote = true
minetest.set_player_privs(name, privs)
```

Privileges are always specified as a key-value table with the key being
the privilege name and the value being a boolean.

```lua
{
    fly = true,
    interact = true,
    shout = true
}
```

## Adding Privileges to basic_privs

Players with the `basic_privs` privilege are able to grant and revoke a limited
set of privileges. It's common to give this privilege to moderators, so that
they can grant and revoke `interact` and `shout`, but can't grant themselves or other
players privileges such as `give` and `server`, which have greater potential for abuse.

To add a privilege to `basic_privs` and adjust which privileges your moderators can
grant and revoke from other players, you must change the `basic_privs` setting.
To do this, you must edit the minetest.conf file.

By default, `basic_privs` has the following value:

    basic_privs = interact, shout

To add `vote`, update this to:

    basic_privs = interact, shout, vote

This will allow players with `basic_privs` to grant and revoke the `vote` privilege.
