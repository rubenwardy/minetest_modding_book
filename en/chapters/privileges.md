---
title: Privileges
layout: default
root: ../../
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

A privilege should give a player **the ability to do something**.
Privileges are **not for indicating class or status**.

The main admin of a server (the name set by the `name` setting in the
minetest.conf file) is automatically given all available privileges.

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

{% highlight lua %}
minetest.register_privilege("vote", {
    description = "Can vote on issues",
    give_to_singleplayer = true
})
{% endhighlight %}

If `give_to_singleplayer` is true, you can remove it, because true is the default
when it is not specified. This simplifies the privilege registration to:

{% highlight lua %}
minetest.register_privilege("vote", {
    description = "Can vote on issues"
})
{% endhighlight %}

## Checking for Privileges

To quickly check whether a player has all the required privileges:

{% highlight lua %}
local has, missing = minetest.check_player_privs(player_or_name,  {
    interact = true,
    vote = true })
{% endhighlight %}

In this example, `has` is true if the player has all the privileges needed.\\
If `has` is false, then `missing` will contain a dictionary
of missing privileges.

{% highlight lua %}
if minetest.check_player_privs(name, {interact=true, vote=true}) then
    print("Player has all privs!")
else
    print("Player is missing some privs!")
end

local has, missing = minetest.check_player_privs(name, {
    interact = true,
    vote = true })
if has then
    print("Player has all privs!")
else
    print("Player is missing privs: " .. dump(missing))
end
{% endhighlight %}

## Getting and Setting Privileges

To get a table containing a player's privileges, regardless of whether
the player is logged in, use `minetest.get_player_privs`:

{% highlight lua %}
local privs = minetest.get_player_privs(name)
print(dump(privs))
{% endhighlight %}

This example may give:

{% highlight lua %}
{
    fly = true,
    interact = true,
    shout = true
}
{% endhighlight %}

To set a player's privileges, use `minetest.set_player_privs`:

{% highlight lua %}
minetest.set_player_privs(name, {
    interact = true,
    shout = true })
{% endhighlight %}

To grant a player privileges, use a combination of the above two functions:

{% highlight lua %}
local privs = minetest.get_player_privs(name)
privs.vote = true
minetest.set_player_privs(name, privs)
{% endhighlight %}

## Adding Privileges to basic_privs

Players with the `basic_privs` privilege are able to grant and revoke a limited
set of privileges. It's common to give this privilege to moderators so they can
grant and revoke `interact` and `shout`, but can't grant themselves or other
players privileges such as `give` and `server`, which have greater potential for abuse.

To add a privilege to `basic_privs` and adjust which privileges your moderators can
grant and revoke from other players, you must change the `basic_privs` setting.
To do this, you must edit the minetest.conf file. 

By default `basic_privs` has the following value:

    basic_privs = interact, shout

To add `vote`, update this to:

    basic_privs = interact, shout, vote

This will allow players with `basic_privs` to grant and revoke the `vote` privilege.
