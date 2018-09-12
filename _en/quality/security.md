---
title: Security
layout: default
root: ../..
idx: 6.25
description: Use LuaCheck to find errors
redirect_from: /en/chapters/luacheck.html
---

## Introduction

Security is very important in making sure that your mod doesn't cause the server
owner to lose data or control.

* [Core Concepts](#core-concepts)
* [Formspecs](#formspecs)
    * [Never Trust Submissions](#never-trust-submissions)
    * [Time of Check isn't Time of Use](#time_of_check_isnt_time_of_use)
* [(Insecure) Environments](#insecure-environments)

## Core Concepts

The most important concept in security is to **never trust the user**.
Anything the user submits should be treated as malicious.
This means that you should always check that the user has the correct permissions,
that the give valid information, and they are otherwise allowed to do that action
(ie: in range or an owner)

A malicious action isn't necessarily the modification or destruction of data,
but can be accessing data they're not supposed to such as password hashes or
private messages.
This is especially bad if the server stores information such as emails or ages,
which some may do for verification purposes.

## Formspecs

### Never Trust Submissions

Any users can submit almost any formspec with any values at any time.

Here's some real code found in a mod:

{% highlight lua %}
minetest.register_on_player_receive_fields(function(player, formname, fields)
    -- Todo: fix security issue here
    local name = player:get_player_name()
    if formname ~= "mymod:fs" then
        return
    end

    for key, field in pairs(fields) do
        local x,y,z = string.match(key, "goto_([%d-]+)_([%d-]+)_([%d-]+)")
        if x and y and z then
            player:setpos({ x=tonumber(x), y=tonumber(y), z=tonumber(z) })
            return true
        end
    end
end
{% endhighlight %}

Can you spot the issue? A malicious user could submit a formspec containing
their own position values, allowing them to teleport to anywhere they wish to.
This could even be automated using client modifications to essentially replicate
the `/teleport` command with no need for a privilege.

The solution for this kind of issue is to use a
[Context](../players/formspecs.html#contexts), as shown in
the formspecs chapter.

### Time of Check isn't Time of Use

Any users can submit any formspec with any values at any time, except where the
engine forbids it:

* A node formspec submission will be blocked if the user is too far away.
* From 5.0 onward, named formspecs will be blocked if they haven't been shown yet.

This means that you should check in the handler that the user meets the
conditions for showing the formspec in the first place, and any corresponding
actions.

The vulnerability caused by checking for permissions in the show formspec but not
in the handle formspec is called Time Of Check is not Time Of Use (TOCTOU).


## (Insecure) Environments

Minetest allows mods to request an unsandboxed environment, giving them access
to the full Lua API.

Can you spot the vulnerability in the following?

{% highlight lua %}
local ie = minetest.request_insecure_environment()
ie.os.execute(("path/to/prog %d"):format(3))
{% endhighlight %}

`String.format` is a function in the global shared table `String`.
A malicious mod could override this function and pass stuff to os.execute:

{% highlight lua %}
String.format = function()
    return "xdg-open 'http://example.com'"
end
{% endhighlight %}

The mod could pass something a lot more malicious than opening a website, such
as giving a remote user control over the machine.

Some rules for using an insecure environment:

* Always store it in a local and never pass it into a function.
* Make sure you can trust any input given to an insecure function, to avoid the
  issue above. This means avoiding globally redefinable functions.
