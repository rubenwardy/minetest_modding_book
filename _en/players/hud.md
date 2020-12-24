---
title: HUD
layout: default
root: ../..
idx: 4.6
description: Learn how to display HUD elements
redirect_from: /en/chapters/hud.html
---

## Introduction <!-- omit in toc -->

Heads Up Display (HUD) elements allow you to show text, images, and other graphical elements.

The HUD doesn't accept user input; for that, you should use a [formspec](formspecs.html).

- [Positioning](#positioning)
	- [Position and Offset](#position-and-offset)
	- [Alignment](#alignment)
	- [Scoreboard](#scoreboard)
- [Text Elements](#text-elements)
	- [Parameters](#parameters)
	- [Our Example](#our-example)
- [Image Elements](#image-elements)
	- [Parameters](#parameters-1)
	- [Scale](#scale)
- [Changing an Element](#changing-an-element)
- [Storing IDs](#storing-ids)
- [Other Elements](#other-elements)

## Positioning

### Position and Offset

<figure class="right_image">
    <img
        width="300"
        src="{{ page.root }}//static/hud_diagram_center.svg"
        alt="Diagram showing a centered text element">
</figure>

Screens come in a variety of different physical sizes and resolutions, and
the HUD needs to work well on all screen types.

Minetest's solution to this is to specify the location of an element using both
a percentage position and an offset.
The percentage position is relative to the screen size, so to place an element
in the centre of the screen, you would need to provide a percentage position of half
the screen, e.g. (50%, 50%), and an offset of (0, 0).

The offset is then used to move an element relative to the percentage position.

<div style="clear:both;"></div>

### Alignment

Alignment is where the result of position and offset is on the element -
for example, `{x = -1.0, y = 0.0}` will make the result of position and offset point
to the left of the element's bounds. This is particularly useful when you want to
make a text element aligned to the left, centre, or right.

<figure>
    <img
        width="500"
        src="{{ page.root }}//static/hud_diagram_alignment.svg"
        alt="Diagram showing alignment">
</figure>

The above diagram shows 3 windows (blue), each with a single HUD element (yellow)
and a different alignment each time. The arrow is the result of the position
and offset calculation.

### Scoreboard

For the purposes of this chapter, you will learn how to position and update a
score panel like so:

<figure>
    <img
        src="{{ page.root }}//static/hud_final.png"
        alt="screenshot of the HUD we're aiming for">
</figure>

In the above screenshot, all the elements have the same percentage position
(100%, 50%) - but different offsets. This allows the whole thing to be anchored
to the right of the window, but to resize without breaking.

## Text Elements

You can create a HUD element once you have a copy of the player object:

```lua
local player = minetest.get_player_by_name("username")
local idx = player:hud_add({
     hud_elem_type = "text",
     position      = {x = 0.5, y = 0.5},
     offset        = {x = 0,   y = 0},
     text          = "Hello world!",
     alignment     = {x = 0, y = 0},  -- center aligned
     scale         = {x = 100, y = 100}, -- covered later
})
```

The `hud_add` function returns an element ID - this can be used later to modify
or remove a HUD element.

### Parameters

The element's type is given using the `hud_elem_type` property in the definition
table. The meaning of other properties varies based on this type.

`scale` is the maximum bounds of text; text outside these bounds is cropped, e.g.: `{x=100, y=100}`.

`number` is the text's colour, and is in [hexadecimal form](http://www.colorpicker.com/), e.g.: `0xFF0000`.


### Our Example

Let's go ahead and place all the text in our score panel:

```lua
-- Get the dig and place count from storage, or default to 0
local meta        = player:get_meta()
local digs_text   = "Digs: " .. meta:get_int("score:digs")
local places_text = "Places: " .. meta:get_int("score:places")

player:hud_add({
    hud_elem_type = "text",
    position  = {x = 1, y = 0.5},
    offset    = {x = -120, y = -25},
    text      = "Stats",
    alignment = 0,
    scale     = { x = 100, y = 30},
    number    = 0xFFFFFF,
})

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
```

This results in the following:

<figure>
    <img
        src="{{ page.root }}//static/hud_text.png"
        alt="screenshot of the HUD we're aiming for">
</figure>


## Image Elements

Image elements are created in a very similar way to text elements:

```lua
player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -220, y = 0},
    text      = "score_background.png",
    scale     = { x = 1, y = 1},
    alignment = { x = 1, y = 0 },
})
```

You will now have this:

<figure>
    <img
        src="{{ page.root }}//static/hud_background_img.png"
        alt="screenshot of the HUD so far">
</figure>

### Parameters

The `text` field is used to provide the image name.

If a co-ordinate is positive, then it is a scale factor with 1 being the
original image size, 2 being double the size, and so on.
However, if a co-ordinate is negative, it is a percentage of the screen size.
For example, `x=-100` is 100% of the width.

### Scale

Let's make the progress bar for our score panel as an example of scale:

```lua
local percent = tonumber(meta:get("score:score") or 0.2)

player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -215, y = 23},
    text      = "score_bar_empty.png",
    scale     = { x = 1, y = 1},
    alignment = { x = 1, y = 0 },
})

player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -215, y = 23},
    text      = "score_bar_full.png",
    scale     = { x = percent, y = 1},
    alignment = { x = 1, y = 0 },
})
```

We now have a HUD that looks like the one in the first post!
There is one problem however, it won't update when the stats change.

## Changing an Element

You can use the ID returned by the `hud_add` method to update it or remove it later.

```lua
local idx = player:hud_add({
     hud_elem_type = "text",
     text          = "Hello world!",
     -- parameters removed for brevity
})

player:hud_change(idx, "text", "New Text")
player:hud_remove(idx)
```

The `hud_change` method takes the element ID, the property to change, and the new
value. The above call changes the `text` property from "Hello World" to "New text".

This means that doing the `hud_change` immediately after the `hud_add` is
functionally equivalent to the following, in a rather inefficient way:

```lua
local idx = player:hud_add({
     hud_elem_type = "text",
     text          = "New Text",
})
```

## Storing IDs

```lua
score = {}
local saved_huds = {}

function score.update_hud(player)
    local player_name = player:get_player_name()

    -- Get the dig and place count from storage, or default to 0
    local meta        = player:get_meta()
    local digs_text   = "Digs: " .. meta:get_int("score:digs")
    local places_text = "Places: " .. meta:get_int("score:places")
    local percent     = tonumber(meta:get("score:score") or 0.2)

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

minetest.register_on_joinplayer(score.update_hud)

minetest.register_on_leaveplayer(function(player)
    saved_huds[player:get_player_name()] = nil
end)
```


## Other Elements

Read [lua_api.txt](https://minetest.gitlab.io/minetest/hud/) for a complete list of HUD elements.
