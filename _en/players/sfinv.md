---
title: "SFINV: Inventory Formspec"
layout: default
root: ../../
idx: 4.7
---

## Introduction

Simple Fast Inventory (SFINV) is a mod found in Minetest Game that is used to
create the player's inventory [formspec](formspecs.html). SFINV comes with
an API that allows you to add and otherwise manage the pages shown.

Whilst SFINV by default shows pages as tabs, pages are called "pages" as
it's entirely possible that a mod or subgame decides to show them in
some other format instead.

* [Registering a Page](#registering-a-page)
    * [A more complex example](#a-more-complex-example)
* [Receiving events](#receiving-events)
* [Conditionally showing to players](#conditionally-showing-to-players)
* [on_enter and on_leave callbacks](#on_enter-and-on_leave-callbacks)

## Registering a Page

So, to register a page you need to call the aptly named `sfinv.register_page`
function with the page's name, and its definition. Here is a minimal example:

{% highlight lua %}
sfinv.register_page("mymod:hello", {
    title = "Hello!",
    get = function(self, player, context)
        -- TODO: implement this
    end
})
{% endhighlight %}

You can also override an existing page using `sfinv.override_page`.

If you ran the above code and clicked the page's tab, it would probably crash
as sfinv is expecting a response from the `get` method. So let's add a response
to fix that:

{% highlight lua %}
sfinv.register_page("mymod:hello", {
    title = "Hello!",
    get = function(self, player, context)
        return sfinv.make_formspec(player, context,
                "label[0.1,0.1;Hello world!]", true)
    end
})
{% endhighlight %}

The `make_formspec` function surrounds your formspec with sfinv's formspec code.
The fourth parameter, currently set as `true`, determines whether or not the
player's inventory is shown.

<figure>
    <img src="{{ page.root }}/static/sfinv_hello_world.png" alt="Furnace Inventory">
    <figcaption>
        Your first sfinv page! Not exactly very exciting, though.
    </figcaption>
</figure>

### A more complex example

Let's make things more exciting. Here is the code for the formspec generation
part of a player admin tab. This tab will allow admins to kick or ban players by
selecting them in a list and clicking a button.

{% highlight lua %}
sfinv.register_page("myadmin:myadmin", {
    title = "Tab",
    get = function(self, player, context)
        local players = {}
        context.myadmin_players = players

        -- Using an array to build a formspec is considerably faster
        local formspec = {
            "textlist[0.1,0.1;7.8,3;playerlist;"
        }

        -- Add all players to the text list, and to the players list
        local is_first = true
        for _ , player in pairs(minetest.get_connected_players()) do
            local player_name = player:get_player_name()
            players[#players + 1] = player_name
            if not is_first then
                formspec[#formspec + 1] = ","
            end
            formspec[#formspec + 1] = minetest.formspec_escape(player_name)
            is_first = false
        end
        formspec[#formspec + 1] = "]"

        -- Add buttons
        formspec[#formspec + 1] = "button[0.1,3.3;2,1;kick;Kick]"
        formspec[#formspec + 1] = "button[2.1,3.3;2,1;ban;Kick + Ban]"

        -- Wrap the formspec in sfinv's layout (ie: adds the tabs and background)
        return sfinv.make_formspec(player, context,
                table.concat(formspec, ""), false)
    end,
})
{% endhighlight %}

There's nothing new about the above code, all the concepts are covered above and
in previous chapters.

<figure>
    <img src="{{ page.root }}/static/sfinv_admin_fs.png" alt="Player Admin Page">
    <figcaption>
        The player admin page created above.
    </figcaption>
</figure>

## Receiving events

You can receive formspec events by adding a `on_player_receive_fields` function
to a sfinv definition.

{% highlight lua %}
on_player_receive_fields = function(self, player, context, fields)
    -- TODO: implement this
end,
{% endhighlight %}

Fields is the exact same as the fields given to the subscribers of
`minetest.register_on_player_receive_fields`. The return value of
`on_player_receive_fields` is the same as a normal player receive fields.
Please note that sfinv will consume events relevant to itself, such as
navigation tab events, so you won't receive them in this callback.

Now let's implement the `on_player_receive_fields` for our admin mod:

{% highlight lua %}
on_player_receive_fields = function(self, player, context, fields)
    -- text list event,  check event type and set index if selection changed
    if fields.playerlist then
        local event = minetest.explode_textlist_event(fields.playerlist)
        if event.type == "CHG" then
            context.myadmin_selected_idx = event.index
        end

    -- Kick button was pressed
    elseif fields.kick then
        local player_name = context.myadmin_players[context.myadmin_selected_idx]
        if player_name then
            minetest.chat_send_player(player:get_player_name(),
                    "Kicked " .. player_name)
            minetest.kick_player(player_name)
        end

    -- Ban button was pressed
    elseif fields.ban then
        local player_name = context.myadmin_players[context.myadmin_selected_idx]
        if player_name then
            minetest.chat_send_player(player:get_player_name(),
                    "Banned " .. player_name)
            minetest.ban_player(player_name)
            minetest.kick_player(player_name, "Banned")
        end
    end
end,
{% endhighlight %}

There's a rather large problem with this, however. Anyone can kick or ban players! You
need a way to only show this to players with the kick or ban privileges.
Luckily SFINV allows you to do this!

## Conditionally showing to players

You can add an `is_in_nav` function to your page's definition if you'd like to
control when the page is shown:

{% highlight lua %}
is_in_nav = function(self, player, context)
    local privs = minetest.get_player_privs(player:get_player_name())
    return privs.kick or privs.ban
end,
{% endhighlight %}

If you only need to check one priv or want to perform an and, you should use
`minetest.check_player_privs()` instead of `get_player_privs`.

Note that the `is_in_nav` is only called when the player's inventory formspec is
generated. This happens when a player joins the game, switches tabs, or a mod
requests it using SFINV's API.

This means that you need to manually request that SFINV regenerates the inventory
formspec on any events that may change `is_in_nav`'s result. In our case,
we need to do that whenever kick or ban is granted or revoked to a player:

{% highlight lua %}
local function on_grant_revoke(grantee, granter, priv)
    if priv == "kick" or priv == "ban" then
        local player = minetest.get_player_by_name(grantee)
        if player then
            sfinv.set_player_inventory_formspec(player)
        end
    end
end

-- Check that the function exists, in order to support older Minetest versions
if minetest.register_on_priv_grant then
    minetest.register_on_priv_grant(on_grant_revoke)
    minetest.register_on_priv_revoke(on_grant_revoke)
end
{% endhighlight %}

## on_enter and on_leave callbacks

You can run code when a player enters (your tab becomes selected) or
leaves (another tab is about to be selected) your tab.

Please note that you can't cancel these, as it would be a bad user experience
if you could.

Also note that the inventory may not be visible at the time
these callbacks are called. For example, on_enter is called for the home page
when a player joins the game even before they open their inventory!

{% highlight lua %}
on_enter = function(self, player, context)

end,

on_leave = function(self, player, context)

end,
{% endhighlight %}

## Adding to an existing page

<div class="notice">
    <h2>To Do</h2>

    This section will be added soon&trade;.
    This placeholder is just to let you know that it is possible!
</div>
