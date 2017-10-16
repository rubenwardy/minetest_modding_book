---
title: Chat and Commands
layout: default
root: ../../
---

## Introduction

Mods can interact with player chat, including
sending messages, intercepting messages and registering chat commands.

* [Sending Messages to All Players](#sending-messages-to-all-players)
* [Sending Messages to Specific Players](#sending-messages-to-specific-players)
* [Chat Commands](#chat-commands)
* [Complex Subcommands](#complex-subcommands)
* [Intercepting Messages](#intercepting-messages)

## Sending Messages to All Players

To send a message to every player in the game, call the chat_send_all function.

{% highlight lua %}
minetest.chat_send_all("This is a chat message to all players")
{% endhighlight %}

Here is an example of how this appears in-game:

    <player1> Look at this entrance
    This is a chat message to all players
    <player2> What about it?

The message appears on a separate line to distinguish it from in-game player chat.

## Sending Messages to Specific Players

To send a message to a specific player, call the chat_send_player function:

{% highlight lua %}
minetest.chat_send_player("player1", "This is a chat message for player1")
{% endhighlight %}

This message displays in the same manner as messages to all players, but is
only visible to the named player, in this case player1.

### Older Mods

Occasionally you'll see mods where the chat_send_player function includes a
boolean:

{% highlight lua %}
minetest.chat_send_player("player1", "This is a server message", true)
minetest.chat_send_player("player1", "This is a server message", false)
{% endhighlight %}

The boolean is no longer used, and has no affect
<sup>[[commit]](https://github.com/minetest/minetest/commit/9a3b7715e2c2390a3a549d4e105ed8c18defb228)</sup>.


## Chat Commands

To register a chat command, for example /foo, use register_chatcommand:

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

Calling /foo bar will display `You said bar!` in the chat console.

You can restrict which players are able to run commands:

{% highlight lua %}
privs = {
    interact = true
},
{% endhighlight %}

This means only players with the `interact` [privilege](privileges.html) can run the
command. Other players will see an error message informing them of which
privilege they're missing. If the player has the necessary privileges, the command
will run and the message will be sent:

{% highlight lua %}
return true, "You said " .. param .. "!"
{% endhighlight %}

This returns two values, a boolean which shows the command succeeded
and the chat message to send to the player.

A player name, instead of a player object, is passed because
**the player might not actually be in-game, but may be running commands from IRC**.
Due to this, you should not assume `minetest.get_player_by_name`, or any other
function that requires an in-game player, will work in a chat command call back.

`minetest.show_formspec` also won't work when a command is run from IRC, so you
should provide a text only version. For example, the email mod allows both `/inbox`
to show a formspec, and `/inbox text` to send information to chat.

## Complex Subcommands

It is often required to make complex chat commands, such as:

* /msg <name> <message>
* /team join <teamname>
* /team leave <teamname>
* /team list

Many mods implement this using Lua patterns; however, a much easier
approach is to use a mod library. See rubenwardy's
[Complex Chat Commands](chat_complex.html).


## Intercepting Messages

To intercept a message, use register_on_chat_message:

{% highlight lua %}
minetest.register_on_chat_message(function(name, message)
    print(name .. " said " .. message)
    return false
end)
{% endhighlight %}

By returning false, you allow the chat message to be sent by the default
handler. You can actually remove the line `return false`, and it would still
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
