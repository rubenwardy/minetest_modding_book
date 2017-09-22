---
title: HUD
layout: default
root: ../../
---

## Introduction

Heads Up Display (HUD) elements allow you to show text, images, and other graphical elements.

The HUD doesn't accept user input. For that, you should use a [Formspec](formspecs.html).

* [Positioning](#positioning)
* [Basic Interface](#basic-interface)
* [Text Elements](#text-elements)
* [Image Elements](#image-elements)
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
        alt="The player inventory formspec, with annotated list names.">
</figure>

The offset is then used to move an element relative to the percentage position.

For the purposes of this chapter, you will learn how to position and update a
score panel like so:

[image of panel needed]

In the above screenshot all of the elements have the same percentage position -
(100%, 50%) - but different offsets. This allows the whole thing to be anchored
to the right of the window, but to resize without breaking.

## Basic Interface

You can create a hud element once you have a copy of the player object:

{% highlight lua %}
local player = minetest.get_player_by_name("username")
local idx = player:hud_add({
     hud_elem_type = "text",
     position      = {x = 0.5, y = 0.5},
     offset        = {x = 0,   y = 0},
     text          = "Hello world!",
     alignment     = 0,  -- center aligned
     scale         = {x = 100, y = 100}, -- covered later
})
{% endhighlight %}

The element's type is given using the `hud_elem_type` property in the definition
table. The meaning of other properties varies based on this type, and they will
be explained in more detail later.

The `hud_add` function returns an element ID - this can be used later to modify
or remove a HUD element:

{% highlight lua %}
player:hud_change(idx, "text", "New Text")
player:hud_remove(idx)
{% endhighlight %}

The `hud_change` method takes the element ID, the property to change, and the new
value. The above call changes the `text` property from "Hello world!" to "New Text".

This means that doing the `hud_change` immediately after the `hud_add` is
functionally equivalent to the following:

{% highlight lua %}
local idx = player:hud_add({
     hud_elem_type = "text",
     position      = {x = 0.5, y = 0.5},
     offset        = {x = 0,   y = 0},
     text          = "New Text",
     alignment     = 0,
     scale         = {x = 100, y = 100},
})
{% endhighlight %}

## Text Elements

A text element is the simplest type of HUD element.

### Parameters

* `scale` - Maximum size of text, text outside these bounds is cropped, eg: `{x=100, y=100}`
* `text` - The text to show, eg: `"Hello world!"`
* `alignment` - How the text is aligned in the bounds. Use `-1` for left, `0` for center, `1` for right.
* `number` - The text's color in Hexadecimal, eg: `0xFF0000`

### Colors

<!-- TODO: move this elsewhere? -->

Use the `number` attribute to apply colors to the text.
Colors are in [Hexadecimal form](http://www.colorpicker.com/).
For example:

{% highlight lua %}
local idx = player:hud_add({
    hud_elem_type = "text",
    position = {x = 1, y = 0},
    offset = {x=-100, y = 20},
    scale = {x = 100, y = 100},
    text = "My Text",
    number = 0xFF0000 -- Red
})
{% endhighlight %}

## Image Elements

Image elements display an image on the HUD.

The X co-ordinate of the `scale` attribute is the scale of the image, with 1 being the original texture size.
Negative values represent the percentage of the screen the image should use. For example, x=-100 means 100% (width).

Use `text` to specify the name of the texture.

## Other Elements

Read [lua_api.txt]({{ page.root }}lua_api.html#hud-element-types) for a complete list of HUD elements.
