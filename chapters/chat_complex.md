---
title: Complex Chat Commands
layout: default
root: ../
---

## Introduction

This chapter will show you how to make complex chat commands, such as
`/msg <name> <message>`, `/team join <teamname>` or `/team leave <teamname>`.

## Why ChatCmdBuilder?

Traditionally mods implemented these complex commands using Lua patterns.
I however find Lua patterns annoying to write and unreadable.
Because of this, I created a library to do this for you.

{% highlight lua %}
ChatCmdBuilder.new("sethp", function(cmd)
	cmd:sub(":target :hp:int", function(name, target, hp)
		local player = minetest.get_player_by_name(target)		
		if player then
			player:set_hp(hp)
			return true, "Killed " .. target
		else
			return false, "Unable to find " .. target
		end
	end)
end, {
	description = "Set hp of player",
	privs = {
		kick = true
		-- ^ probably better to register a custom priv
	}
})
{% endhighlight %}

`ChatCmdBuilder.new(name, setup_func, def)` creates a new chat command called
`name`. It then calls the function passed to it (`setup_func`), which then creates
sub commands. Each `cmd:sub(route, func)` is a sub command.

A sub command is a particular response to an input param. When a player runs
the chat command, the first sub command that matches their input will be run,
and no others. If no subcommands match then the user will be told of the invalid
syntax. For example, in the above code snippet if a player
types something of the form `/sethp username 12` then the function passed
to cmd:sub will be called. If they type `/sethp 12 bleh` then a wrong
input message will appear.

`:name :hp:int` is a route. It describes the format of the param passed to /teleport.

## Routes

A route is made up of terminals and variables. Terminals must always be there.
For example, `join` in `/team join :username :teamname`. The spaces also count
as terminals.

Variables can change value depending on what the user types. For example, `:username`
and `:teamname`.

Variables are defined as `:name:type`. The `name` is used in the help documention.
The `type` is used to match the input. If the type is not given, then the type is
`word`.

Valid types are:

* `word`   - default. Any string without spaces.
* `int`    - Any integer/whole number, no decimals.
* `number` - Any number, including ints and decimals.
* `pos`    - 1,2,3 or 1.1,2,3.4567 or (1,2,3) or 1.2, 2 ,3.2
* `text`   - Any string. There can only ever be one text variable,
             no variables or terminals can come afterwards.

In `:name :hp:int`, there are two variables there:

* `name` - type of `word` as no type is specified. Accepts any string without spaces.
* `hp` - type of `int`

## Subcommand functions

The first argument is the caller's name. The variables are then passed to the
function in order.

{% highlight lua %}
cmd:sub(":target :hp:int", function(name, target, hp)
	-- subcommand function
end)
{% endhighlight %}

## Installing ChatCmdBuilder

There are two ways to install:

1. Install ChatCmdBuilder as a mod and depend on it.
2. Include the init.lua file in ChatCmdBuilder as chatcmdbuilder.lua in your mod,
   and dofile it.

## Admin complex command

Here is an example that creates a chat command that allows us to do this:

* `/admin kill <username>` - kill user
* `/admin move <username> to <pos>` - teleport user
* `/admin log <username>` - show report log
* `/admin log <username> <message>` - log to report log

{% highlight lua %}
local admin_log
local function load()
	admin_log = {}
end
local function save()
	-- todo
end
load()

ChatCmdBuilder.new("admin", function(cmd)
	cmd:sub("kill :name", function(name, target)
		local player = minetest.get_player_by_name(target)
		if player then
			player:set_hp(0)
			return true, "Killed " .. target
		else
			return false, "Unable to find " .. target
		end
	end)

	cmd:sub("move :name to :pos:pos", function(name, target, pos)
		local player = minetest.get_player_by_name(target)
		if player then
			player:setpos(pos)
			return true, "Moved " .. target .. " to " .. minetest.pos_to_string(pos)
		else
			return false, "Unable to find " .. target
		end
	end)

	cmd:sub("log :username", function(name, target)
		local log = admin_log[target]
		if log then
			return true, table.concat(log, "\n")
		else
			return false, "No entries for " .. target
		end
	end)

	cmd:sub("log :username :message", function(name, target, message)
		local log = admin_log[target] or {}
		table.insert(log, message)
		admin_log[target] = log
		save()
		return true, "Logged"
	end)
end, {
	description = "Admin tools",
	privs = {
		kick = true,
		ban = true
	}
})
{% endhighlight %}
