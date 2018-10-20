---
title: "SFINV: Inventory Formspec"
layout: default
root: ../..
idx: 4.7
redirect_from: /en/chapters/sfinv.html
---

## Introduction

Simple Fast Inventory (SFINV) is a mod found in Minetest Game that is used to
create the player's inventory [formspec](formspecs.html). SFINV comes with
an API that allows you to add and otherwise manage the pages shown.

Whilst SFINV by default shows pages as tabs, pages are called pages
because it is entirely possible that a mod or game decides to show them in
some other format instead.
For example, multiple pages could be shown in one formspec.

* [Registering a Page](#registering-a-page)
* [Receiving events](#receiving-events)
* [Conditionally showing to players](#conditionally-showing-to-players)
* [on_enter and on_leave callbacks](#on_enter-and-on_leave-callbacks)

## Registering a Page

SFINV provides the aptly named `sfinv.register_page` function to create pages.
Simply call the function with the page's name and its definition:

```lua
sfinv.register_page("mymod:hello", {
    title = "Hello!",
    get = function(self, player, context)
        return sfinv.make_formspec(player, context,
                "label[0.1,0.1;Hello world!]", true)
    end
})
```

The `make_formspec` function surrounds your formspec with SFINV's formspec code.
The fourth parameter, currently set as `true`, determines whether the
player's inventory is shown.

Let's make things more exciting; here is the code for the formspec generation
part of a player admin tab. This tab will allow admins to kick or ban players by
selecting them in a list and clicking a button.

```lua
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
            formspec[#formspec + 1] =
                    minetest.formspec_escape(player_name)
            is_first = false
        end
        formspec[#formspec + 1] = "]"

        -- Add buttons
        formspec[#formspec + 1] = "button[0.1,3.3;2,1;kick;Kick]"
        formspec[#formspec + 1] = "button[2.1,3.3;2,1;ban;Kick + Ban]"

        -- Wrap the formspec in sfinv's layout
        -- (ie: adds the tabs and background)
        return sfinv.make_formspec(player, context,
                table.concat(formspec, ""), false)
    end,
})
```

There's nothing new about the above code; all the concepts are
covered above and in previous chapters.

<figure>
    <img src="{{ page.root }}//static/sfinv_admin_fs.png" alt="Player Admin Page">
</figure>

## Receiving events

You can receive formspec events by adding a `on_player_receive_fields` function
to a sfinv definition.

```lua
on_player_receive_fields = function(self, player, context, fields)
    -- TODO: implement this
end,
```

`on_player_receive_fields` works the same as
`minetest.register_on_player_receive_fields`, except that `context` is
given instead of `formname`.
Please note that SFINV will consume events relevant to itself, such as
navigation tab events, so you won't receive them in this callback.

Now let's implement the `on_player_receive_fields` for our admin mod:

```lua
on_player_receive_fields = function(self, player, context, fields)
    -- text list event,  check event type and set index if selection changed
    if fields.playerlist then
        local event = minetest.explode_textlist_event(fields.playerlist)
        if event.type == "CHG" then
            context.myadmin_selected_idx = event.index
        end

    -- Kick button was pressed
    elseif fields.kick then
        local player_name =
                context.myadmin_players[context.myadmin_selected_idx]
        if player_name then
            minetest.chat_send_player(player:get_player_name(),
                    "Kicked " .. player_name)
            minetest.kick_player(player_name)
        end

    -- Ban button was pressed
    elseif fields.ban then
        local player_name =
                context.myadmin_players[context.myadmin_selected_idx]
        if player_name then
            minetest.chat_send_player(player:get_player_name(),
                    "Banned " .. player_name)
            minetest.ban_player(player_name)
            minetest.kick_player(player_name, "Banned")
        end
    end
end,
```

There's a rather large problem with this, however. Anyone can kick or ban players! You
need a way to only show this to players with the kick or ban privileges.
Luckily SFINV allows you to do this!

## Conditionally showing to players

You can add an `is_in_nav` function to your page's definition if you'd like to
control when the page is shown:

```lua
is_in_nav = function(self, player, context)
    local privs = minetest.get_player_privs(player:get_player_name())
    return privs.kick or privs.ban
end,
```

If you only need to check one priv or want to perform an 'and', you should use
`minetest.check_player_privs()` instead of `get_player_privs`.

Note that the `is_in_nav` is only called when the player's inventory formspec is
generated. This happens when a player joins the game, switches tabs, or a mod
requests for SFINV to regenerate.

This means that you need to manually request that SFINV regenerates the inventory
formspec on any events that may change `is_in_nav`'s result. In our case,
we need to do that whenever kick or ban is granted or revoked to a player:

```lua
local function on_grant_revoke(grantee, granter, priv)
    if priv ~= "kick" and priv ~= "ban" then
        return
    end

    local player = minetest.get_player_by_name(grantee)
    if not player then
        return
    end

    local context = sfinv.get_or_create_context(player)
    if context.page ~= "myadmin:myadmin" then
        return
    end

    sfinv.set_player_inventory_formspec(player, context)
end

minetest.register_on_priv_grant(on_grant_revoke)
minetest.register_on_priv_revoke(on_grant_revoke)
```

## on_enter and on_leave callbacks

A player *enters* a tab when the tab is selected, and *leaves* a
tab when another tab is about to be selected.
It's possible for multiple pages to be selected if a custom theme is
used.

Note that these events may not be triggered by the player.
The player may not even have the formspec open at that time.
For example, on_enter is called for the home page when a player
joins the game even before they open their inventory.

It's not possible to cancel a page change, as that would potentially
confuse the player.

```lua
on_enter = function(self, player, context)

end,

on_leave = function(self, player, context)

end,
```

## Adding to an existing page

To add content to an existing page, you will need to override the page
and modify the returned formspec.

```lua
local old_func = sfinv.registered_pages["sfinv:crafting"].get
sfinv.override_page("sfinv:crafting", {
    get = function(self, player, context, ...)
        local ret = old_func(self, player, context, ...)

        if type(ret) == "table" then
            ret.formspec = ret.formspec .. "label[0,0;Hello]"
        else
            -- Backwards compatibility
            ret = ret .. "label[0,0;Hello]"
        end

        return ret
    end
})
```
