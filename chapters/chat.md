---
title: Chat
layout: default
root: ../
---

## Introduction

In this chapter we will learn how to interact with player chat, including
sending messages, intercepting messages and registering chat commands.

* Send a message to all players.
* Send a message to a certain player.
	* Server =!=
* Chat commands.
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

### Server =!=

You can prefix a message to a single player with `Server =!=` by using

{% highlight lua %}
minetest.chat_send_player("player1", "This is a server message", true)
{% endhighlight %}

It will look like this:

	<player1> Look at this entrance
	Server =!= This is a server message
	<player2> What about it?

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

This makes it so that only players with the `interact` privilege can run the
command. Other players will see an error message informing them which
privilege they're missing.

{% highlight lua %}
return true, "You said " .. param .. "!"
{% endhighlight %}

This returns two values, firstly a boolean which says that the command succeeded
and secondly the chat message to send to the player.

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
