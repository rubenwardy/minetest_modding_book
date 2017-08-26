---
title: Privileges
layout: default
root: ../../
---

## Introduction

Privileges allow server owners to grant or revoke the right to do certain
actions.

* When should a priv be used?
* Checking for privileges
* Getting and Setting

## When should a priv be used?

A privilege should give a player **the right to do something**.
They are **not for indicating class or status**.

The main admin of a server (the name set by the `name` setting) has all privileges
given to them.

**Good:**

* interact
* shout
* noclip
* fly
* kick
* ban
* vote
* worldedit
* area_admin - admin functions of one mod is ok

**Bad:**

* moderator
* admin
* elf
* dwarf

## Declaring a privilege

{% highlight lua %}
minetest.register_privilege("vote", {
    description = "Can vote on issues",
    give_to_singleplayer = true
})
{% endhighlight %}

If `give_to_singleplayer` is true, then you can remove it as that's the default
value when not specified:

{% highlight lua %}
minetest.register_privilege("vote", {
    description = "Can vote on issues"
})
{% endhighlight %}

## Checking for privileges

There is a quicker way of checking that a player has all the required privileges:

{% highlight lua %}
local has, missing = minetest.check_player_privs(player_or_name,  {
    interact = true,
    vote = true })
{% endhighlight %}

`has` is true if the player has all the privileges needed.\\
If `has` is false, then `missing` will contain a dictionary
of missing privileges<sup>[checking needed]</sup>.

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

## Getting and Setting

You can get a table containing a player's privileges using `minetest.get_player_privs`:

{% highlight lua %}
local privs = minetest.get_player_privs(name)
print(dump(privs))
{% endhighlight %}

This works whether or not a player is logged in.\\
Running that example may give the following:

{% highlight lua %}
{
    fly = true,
    interact = true,
    shout = true
}
{% endhighlight %}

To set a player's privs, you use `minetest.set_player_privs`:

{% highlight lua %}
minetest.set_player_privs(name, {
    interact = true,
    shout = true })
{% endhighlight %}

To grant a player some privs, you would use a mixture of those two:

{% highlight lua %}
local privs = minetest.get_player_privs(name)
privs.vote = true
minetest.set_player_privs(name, privs)
{% endhighlight %}

## Adding privileges to basic_privs

<div class="notice">
    <h2>Workaround / PR pending</h2>

    This is a workaround for a missing feature.
    I have submitted a
    <a href="https://github.com/minetest/minetest/pull/3976">pull request / patch</a>
    to make it so you don't need to edit builtin to add a priv to basic_privs.
</div>

To allow people with basic_privs to grant and revoke your priv, you'll
need to edit [builtin/game/chatcommands.lua](https://github.com/minetest/minetest/blob/master/builtin/game/chatcommands.lua#L164-L252):

In both grant and revoke, change the following if statement:

{% highlight lua %}
if priv ~= "interact" and priv ~= "shout" and
        not core.check_player_privs(name, {privs=true}) then
    return false, "Your privileges are insufficient."
end
{% endhighlight %}

For example, to add vote:

{% highlight lua %}
if priv ~= "interact" and priv ~= "shout" and priv ~= "vote" and
        not core.check_player_privs(name, {privs=true}) then
    return false, "Your privileges are insufficient."
end
{% endhighlight %}
