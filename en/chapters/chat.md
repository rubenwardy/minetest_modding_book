---
title: Chat and Commands
layout: default
root: ../../
---

## Introduction

In this chapter we will learn how to interact with player chat, including
sending messages, intercepting messages and registering chat commands.

* Send a message to all players.
* Send a message to a certain player.
* Chat commands.
* Complex subcommands.
* Intercepting messages.

## Send a message to all players

It's as simple as calling the chat_send_all function, as so:

{% highlight lua %}
minetest.chat_send_all("This is a chat message to all players")
{% endhighlight %}

Here is an example of how it would appear ingame (there are other messages
around it).

    <player1> Look at this entrance
    This is a chat message to all players
    <player2> What about it?

## Send a message to a certain player

It's as simple as calling the chat_send_player function, as so:

{% highlight lua %}
minetest.chat_send_player("player1", "This is a chat message for player1")
{% endhighlight %}

Only player1 can see this message, and it's displayed the same as above.

### Older mods

Occasionally you'll see mods with code like this:

{% highlight lua %}
minetest.chat_send_player("player1", "This is a server message", true)
minetest.chat_send_player("player1", "This is a server message", false)
{% endhighlight %}

The boolean at is no longer used, and has no affect
<sup>[[commit]](https://github.com/minetest/minetest/commit/9a3b7715e2c2390a3a549d4e105ed8c18defb228)</sup>.


## Chat commands

In order to register a chat command, such as /foo, use register_chatcommand:

{% highlight lua %}
minetest.register_chatcommand("foo", {
    privs = {
        interact = true
    },
    func = function(name, param)
        return true, "You said " .. param .. "!"
    end
})
{% endhighlight %}

Calling /foo bar will result in `You said bar!` in the chat console.

Let's do a break down:

{% highlight lua %}
privs = {
    interact = true
},
{% endhighlight %}

This makes it so that only players with the `interact` [privilege](privileges.html) can run the
command. Other players will see an error message informing them which
privilege they're missing.

{% highlight lua %}
return true, "You said " .. param .. "!"
{% endhighlight %}

This returns two values, firstly a boolean which says that the command succeeded
and secondly the chat message to send to the player.

The reason that a player name rather than a player object is passed is because
**the player might not actually be online, but may be running commands from IRC**.
So don't assume that `minetest.get_player_by_name` will work in a chat command call back,
or any other function that requires an ingame player. `minetest.show_formspec` will also
not work for IRC players, so you should provide a text only version. For example, the
email mod allows both `/inbox` to show the formspec, and `/inbox text` to send to chat.

## Complex subcommands

It is often required to make complex chat commands, such as:

* /msg <name> <message>
* /team join <teamname>
* /team leave <teamname>
* /team list

Traditionally mods implemented this using Lua patterns. However, a much easier
way is to use a mod library that I wrote to do this for you.
See [Complex Chat Commands](chat_complex.html).


## Intercepting messages

You can use register_on_chat_message, like so:

{% highlight lua %}
minetest.register_on_chat_message(function(name, message)
    print(name .. " said " .. message)
    return false
end)
{% endhighlight %}

By returning false, we're allowing the chat message to be sent by the default
handler. You can actually miss out the line `return false`, and it would still
work the same.

**WARNING: CHAT COMMANDS ARE ALSO INTERCEPTED.** If you only want to catch
player messages, you need to do this:

{% highlight lua %}
minetest.register_on_chat_message(function(name, message)
    if message:sub(1, 1) == "/" then
        print(name .. " ran chat command")
        return false
    end

    print(name .. " said " .. message)
    return false
end)
{% endhighlight %}
