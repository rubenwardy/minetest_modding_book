---
title: Chat and Commands
layout: default
root: ../..
idx: 4.2
description: Registering a chatcommand and handling chat messages with register_on_chat_message
redirect_from: /en/chapters/chat.html
cmd_online:
    level: warning
    title: Offline players can run commands
    message: <p>A player name is passed instead of a player object because mods
             can run commands on behalf of offline players. For example, the IRC
             bridge allows players to run commands without joining the game.</p>

             <p>So make sure that you don't assume that the player is online.
             You can check by seeing if <pre>minetest.get_player_by_name</pre> returns a player.</p>

cb_cmdsprivs:
    level: warning
    title: Privileges and Chat Commands
    message: The shout privilege isn't needed for a player to trigger this callback.
             This is because chat commands are implemented in Lua, and are just
             chat messages that begin with a /.

---

## Introduction <!-- omit in toc -->

Mods can interact with player chat, including
sending messages, intercepting messages, and registering chat commands.

- [Sending Messages to All Players](#sending-messages-to-all-players)
- [Sending Messages to Specific Players](#sending-messages-to-specific-players)
- [Chat Commands](#chat-commands)
- [Complex Subcommands](#complex-subcommands)
- [Intercepting Messages](#intercepting-messages)

## Sending Messages to All Players

To send a message to every player in the game, call the chat_send_all function.

```lua
minetest.chat_send_all("This is a chat message to all players")
```

Here is an example of how this appears in-game:

    <player1> Look at this entrance
    This is a chat message to all players
    <player2> What about it?

The message appears on a separate line to distinguish it from in-game player chat.

## Sending Messages to Specific Players

To send a message to a specific player, call the chat_send_player function:

```lua
minetest.chat_send_player("player1", "This is a chat message for player1")
```

This message displays in the same manner as messages to all players, but is
only visible to the named player, in this case, player1.

## Chat Commands

To register a chat command, for example `/foo`, use `register_chatcommand`:

```lua
minetest.register_chatcommand("foo", {
    privs = {
        interact = true,
    },
    func = function(name, param)
        return true, "You said " .. param .. "!"
    end,
})
```

In the above snippet, `interact` is listed as a required
[privilege](privileges.html) meaning that only players with the `interact` privilege can run the command.

Chat commands can return up to two values,
the first being a Boolean indicating success, and the second being a
message to send to the user.

{% include notice.html notice=page.cmd_online %}

## Complex Subcommands

It is often required to make complex chat commands, such as:

* `/msg <to> <message>`
* `/team join <teamname>`
* `/team leave <teamname>`
* `/team list`

This is usually done using [Lua patterns](https://www.lua.org/pil/20.2.html).
Patterns are a way of extracting stuff from text using rules.

```lua
local to, msg = string.match(param, "^([%a%d_-]+) (*+)$")
```

The above code implements `/msg <to> <message>`. Let's go through left to right:

* `^` means match the start of the string.
* `()` is a matching group - anything that matches stuff in here will be
  returned from string.match.
* `[]` means accept characters in this list.
* `%a` means accept any letter and `%d` means accept any digit.
* `[%a%d_-]` means accept any letter or digit or `_` or `-`.
* `+` means match the thing before one or more times.
* `*` means match any character in this context.
* `$` means match the end of the string.

Put simply, the pattern matches the name (a word with only letters/numbers/-/_),
then a space, then the message (one or more of any character). The name and
message are returned, because they're surrounded by parentheses.

That's how most mods implement complex chat commands. A better guide to Lua
Patterns would probably be the
[lua-users.org tutorial](http://lua-users.org/wiki/PatternsTutorial)
or the [PIL documentation](https://www.lua.org/pil/20.2.html).

<p class="book_hide">
There is also a library written by the author of this book which can be used
to make complex chat commands without patterns called
<a href="chat_complex.html">Chat Command Builder</a>.
</p>


## Intercepting Messages

To intercept a message, use register_on_chat_message:

```lua
minetest.register_on_chat_message(function(name, message)
    print(name .. " said " .. message)
    return false
end)
```

By returning false, you allow the chat message to be sent by the default
handler. You can actually remove the line `return false` and it would still
work the same, because `nil` is returned implicitly and is treated like false.

{% include notice.html notice=page.cb_cmdsprivs %}

You should make sure you take into account that it may be a chat command,
or the user may not have `shout`.

```lua
minetest.register_on_chat_message(function(name, message)
    if message:sub(1, 1) == "/" then
        print(name .. " ran chat command")
    elseif minetest.check_player_privs(name, { shout = true }) then
        print(name .. " said " .. message)
    else
        print(name .. " tried to say " .. message ..
                " but doesn't have shout")
    end

    return false
end)
```
