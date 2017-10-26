---
title: HUD
layout: default
root: ../../
---

## Introduction

Heads Up Display (HUD) elements allow you to show text, images, and other graphical elements.

The HUD doesn't accept user input. For that, you should use a [Formspec](formspecs.html).

* [Positioning](#positioning)
* [Text Elements](#text-elements)
    * [Parameters](#parameters)
    * [Our Example](#our-example)
* [Image Elements](#image-elements)
    * [Parameters](#parameters-1)
    * [Scale](#scale)
* [Changing an Element](#changing-an-element)
* [Storing IDs](#storing-ids)
* [Other Elements](#other-elements)

## Positioning

Screens come in a variety of different sizes and densities, and the HUD needs
to work well on all screen types.

Minetest's solution to this is to specify the location of an element using both
a percentage position and an offset.
The percentage position is relative to the screen size, so to place an element
in the center of the screen you would need to provide a percentage position of half
the screen, eg (50%, 50%), and an offset of (0, 0).

<figure>
    <img
        width="300"
        src="{{ page.root }}/static/hud_diagram_center.svg"
        alt="Diagram showing a centered text element">
</figure>

The offset is then used to move an element relative to the percentage position.

For the purposes of this chapter, you will learn how to position and update a
score panel like so:

<figure>
    <img
        src="{{ page.root }}/static/hud_final.png"
        alt="screenshot of the HUD we're aiming for">
</figure>

In the above screenshot all of the elements have the same percentage position -
(100%, 50%) - but different offsets. This allows the whole thing to be anchored
to the right of the window, but to resize without breaking.

## Text Elements

You can create a hud element once you have a copy of the player object:

{% highlight lua %}
local player = minetest.get_player_by_name("username")
local idx = player:hud_add({
     hud_elem_type = "text",
     position      = {x = 0.5, y = 0.5},
     offset        = {x = 0,   y = 0},
     text          = "Hello world!",
     alignment     = {x = 0, y = 0},  -- center aligned
     scale         = {x = 100, y = 100}, -- covered later
})
{% endhighlight %}

The `hud_add` function returns an element ID - this can be used later to modify
or remove a HUD element.

### Parameters

The element's type is given using the `hud_elem_type` property in the definition
table. The meaning of other properties varies based on this type.

`scale` is the maximum bounds of text, text outside these bounds is cropped, eg: `{x=100, y=100}`.

`alignment` is where the result of position and offset is on the text - for example,
`{x=-1,y=0}` will make the result of position and offset point to the left of the
text's bounds. This is used to make the text element left, center, or right justified.

The text's color in [Hexadecimal form](http://www.colorpicker.com/), eg: `0xFF0000`,
and stored in


### Our Example

Let's go ahead, and place all of the text in our score panel:

{% highlight lua %}
player:hud_add({
    hud_elem_type = "text",
    position  = {x = 1, y = 0.5},
    offset    = {x = -120, y = -25},
    text      = "Stats",
    alignment = 0,
    scale     = { x = 100, y = 30},
    number    = 0xFFFFFF,
})

-- Get the dig and place count from storage, or default to 0
local digs        = tonumber(player:get_attribute("scoreboard:digs") or 0)
local digs_text   = "Digs: " .. digs
local places      = tonumber(player:get_attribute("scoreboard:digs") or 0)
local places_text = "Places: " .. places

player:hud_add({
    hud_elem_type = "text",
    position  = {x = 1, y = 0.5},
    offset    = {x = -180, y = 0},
    text      = digs_text,
    alignment = -1,
    scale     = { x = 50, y = 10},
    number    = 0xFFFFFF,
})

player:hud_add({
    hud_elem_type = "text",
    position  = {x = 1, y = 0.5},
    offset    = {x = -70, y = 0},
    text      = places_text,
    alignment = -1,
    scale     = { x = 50, y = 10},
    number    = 0xFFFFFF,
})
{% endhighlight %}

This results in the following:

<figure>
    <img
        src="{{ page.root }}/static/hud_text.png"
        alt="screenshot of the HUD we're aiming for">
</figure>


## Image Elements

Image elements are created in a very similar way to text elements:

{% highlight lua %}
player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -220, y = 0},
    text      = "scoreboard_background.png",
    scale     = { x = 1, y = 1},
    alignment = { x = 1, y = 0 },
})
{% endhighlight %}

You will now have this:

<figure>
    <img
        src="{{ page.root }}/static/hud_background_img.png"
        alt="screenshot of the HUD so far">
</figure>

### Parameters

The `text` field is used to provide the image name.

If a co-ordinate is positive, then it is a scale factor with 1 being the
original image size, and 2 being double the size, and so on.
However, if a co-ordinate is negative it is a percentage of the screensize.
For example, `x=-100` is 100% of the width.

### Scale

Let's make the progress bar for our score panel as an example of scale:

{% highlight lua %}
local percent = tonumber(player:get_attribute("scoreboard:score") or 0.2)

player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -215, y = 23},
    text      = "scoreboard_bar_empty.png",
    scale     = { x = 1, y = 1},
    alignment = { x = 1, y = 0 },
})

player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -215, y = 23},
    text      = "scoreboard_bar_full.png",
    scale     = { x = percent, y = 1},
    alignment = { x = 1, y = 0 },
})
{% endhighlight %}

We now have a HUD that looks like the one in the first post! There is one problem however, it won't update when the stats change

## Changing an Element

You can use the ID returned by the hud_add method to update or remove it later.

{% highlight lua %}
local idx = player:hud_add({
     hud_elem_type = "text",
     text          = "Hello world!",
     -- parameters removed for brevity
})

player:hud_change(idx, "text", "New Text")
player:hud_remove(idx)
{% endhighlight %}

The `hud_change` method takes the element ID, the property to change, and the new
value. The above call changes the `text` property from "Hello World" to "Test".

This means that doing the `hud_change` immediately after the `hud_add` is
functionally equivalent to the following, in a rather inefficient way:

{% highlight lua %}
local idx = player:hud_add({
     hud_elem_type = "text",
     text          = "New Text",
})
{% endhighlight %}

## Storing IDs

{% highlight lua %}
scoreboard = {}
local saved_huds = {}

function scoreboard.update_hud(player)
    local player_name = player:get_player_name()

    local digs = tonumber(player:get_attribute("scoreboard:digs") or 0)
    local digs_text   = "Digs: " .. digs
    local places = tonumber(player:get_attribute("scoreboard:digs") or 0)
    local places_text = "Places: " .. places

    local percent = tonumber(player:get_attribute("scoreboard:score") or 0.2)

    local ids = saved_huds[player_name]
    if ids then
        player:hud_change(ids["places"], "text", places_text)
        player:hud_change(ids["digs"],   "text", digs_text)
        player:hud_change(ids["bar_foreground"],
                "scale", { x = percent, y = 1 })
    else
        ids = {}
        saved_huds[player_name] = ids

        -- create HUD elements and set ids into `ids`
    end
end

minetest.register_on_joinplayer(scoreboard.update_hud)

minetest.register_on_leaveplayer(function(player)
    saved_huds[player:get_player_name()] = nil
end)
{% endhighlight %}


## Other Elements

Read [lua_api.txt]({{ page.root }}lua_api.html#hud-element-types) for a complete list of HUD elements.
